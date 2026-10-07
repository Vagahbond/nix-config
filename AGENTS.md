# AGENTS.md

Personal multi-host Nix flake (NixOS + nix-darwin) for user `vagahbond`. No home-manager. No tests, no CI (`.github/` is empty).

## Hosts (exposed in `flake.nix`)

| Output | Host file | Platform | Notes |
|---|---|---|---|
| `nixosConfigurations.platypute` | `hosts/platypute/` | x86_64-linux | Main server: nginx, services, postgres, docker. tmpfs root (disko) + impermanence. |
| `nixosConfigurations.pixel` | `hosts/pixel.nix` | aarch64-linux | Android AVF VM (`inputs.avf`). No impermanence. |
| `nixosConfigurations.framework` | `hosts/framework.nix` | x86_64-linux | Desktop/dev configuration. Impermanence module loaded, disabled by default; no hardware/disk imports. |
| `nixosConfigurations.guest` | `hosts/guest.nix` | x86_64-linux (base setting) | Generic desktop/dev live environment. Base output exists but asserts that `architecture` is supplied; use its generated live outputs. |
| `darwinConfigurations.air` | `hosts/air.nix` | aarch64-darwin | MacBook. No generated live variants. |

Adding a host: create `hosts/<name>.nix` or `hosts/<name>/default.nix`, then add `lib.mkNixosHost { hostName = "<name>"; }` to `baseConfigurations` in `flake.nix`, or `lib.mkDarwinHost { hostName = "<name>"; }` to `darwinConfigurations`. NixOS hosts automatically gain live variants.

### Generated live environments

- `flake.nix` generates `nixosConfigurations.<host>-live-<architecture>` for every entry in `baseConfigurations` (`platypute`, `pixel`, `framework`, `guest`) and each `liveEnvArchitectures` entry (`x86_64`, `aarch64`): eight live outputs. The old standalone `nixosConfigurations.live` and `hosts/live/` no longer exist.
- Each variant reloads the same host with `hostExtraArgs = { inherit architecture; };` and `hostExtraModules = [ ./live.nix ];`. Host modules, services and hardware imports remain included; these are not stripped-down rescue configurations. The runtime hostname remains the base host name.
- `live.nix` imports the minimal installation CD, channel and disko modules, forces `nixpkgs.hostPlatform` to `${architecture}-linux`, and forces `persistence.enable = false`. It sets volume ID `<host>-live`, ISO filename `nixos.iso`, and disables getty autologin.
- Root comes from the ISO module. `/home` mounts ext4 labelled `live-persist` with `relatime` and `nofail`; this is direct home persistence, not impermanence. Other state is not persisted through the impermanence module.
- ISO filesystem gotcha: nixpkgs' `installation-cd-base.nix` sets the whole `fileSystems` with `lib.mkImageMediaOverride`. Extra mounts in `live.nix` must use that override too or they are silently dropped. Don't redefine `/`.
- `packages.<architecture>-linux.<host>-live` shortcuts are constructed by `isoBuildShortcuts`, grouping all host ISO packages under each architecture's system key. All eight live outputs have shortcuts; use `nix build .#packages.x86_64-linux.guest-live` or the full `nixosConfigurations` ISO path.

## Commands

```sh
# Build/switch (nh is installed by modules/nix/nix.nix)
nh os switch . --hostname platypute --build-host platypute --target-host platypute
nh os switch --dry --build-host platypute --target-host platypute --hostname platypute . --show-trace   # from hosts/platypute/default.nix

# Evaluate without building
nix eval .#nixosConfigurations.platypute.config.system.build.toplevel.drvPath
nix eval .#darwinConfigurations.air.system.drvPath

nix eval .#nixosConfigurations.guest-live-x86_64.config.system.build.isoImage.drvPath
nix build .#nixosConfigurations.guest-live-x86_64.config.system.build.isoImage
nix build .#nixosConfigurations.framework-live-aarch64.config.system.build.isoImage
nix build .#packages.x86_64-linux.guest-live

nix flake update
nix develop
```

Live builds: replace the host and architecture in the examples above as needed. Run from the repo root; default output is `./result/iso/nixos.iso`. Builds need a builder for the target Linux platform (e.g. an x86_64-linux remote builder when building from `air`); generating an aarch64 output does not make a local macOS build possible.

The default devShell is defined through `shell.nix`, available on `x86_64-linux` and `aarch64-darwin`, and includes mermaid-cli + entr for `doc/architecture.md` plus live ISO helpers. There is no longer a `live-env` shell or `build_live_iso` command.

- `flash_live_iso /dev/<disk>`: writes the single ISO under `result/iso/` to the supplied device with `dd`. Requires device write access. Destructive, with no confirmation or whole-disk/mounted-device checks; verify the destination manually and never run against a real disk while testing.
- `create_live_persistent_partition /dev/<disk>` (Linux only, root, interactive `YES` confirm): turns trailing free space on a whole unmounted disk (e.g. a USB stick the ISO was flashed onto) into ext4 labelled `live-persist`, also using that GPT partition name. Supports GPT and MBR. On GPT it runs `sgdisk -e` before the confirmation, so invocation can modify the disk even if later aborted. Never run against a real disk while testing.
- SSH-key injection is not enabled; the SSH identity needed to decrypt secrets must be supplied manually to the live environment.

- `air` has an `upgrade-platypute` script: `ssh -t platypute nh os switch "$NH_FLAKE" --refresh`.
- `NH_FLAKE` points to `git+ssh://forgejo@git.vagahbond.com/vagahbond/nix-config.git`, so remote upgrades use the **pushed** remote repo, not local working tree.
- Several flake inputs are `git+ssh://forgejo@git.vagahbond.com/...` (website, blog, audio-experiments, firesplit, affine-server). Evaluation needs SSH access to that forgejo; failures there are auth/network, not code.
- Flakes only see git-tracked files: `git add` new files before evaluating.

## Custom module system (`lib/modules.nix`) - most important thing

Modules in `modules/` are NOT regular NixOS modules. Each file evaluates to a **list** of entries:

```nix
[
  {
    targets = [ "nixosConfiguration" "darwinConfiguration" ];
    conf = { pkgs, config, username, inputs, libUtils, ... }: { ... };  # normal NixOS/darwin module
  }
  {
    targets = [ "nixosConfiguration" ];
    conf = { config, ... }: { ... };
  }
]
```

- Valid targets are only `"nixosConfiguration"` and `"darwinConfiguration"` (asserted). `conf` is kept only if host type matches.
- Put Linux-only options (systemd, `environment.persistence`, `age` nixos module import, nginx...) in a `nixosConfiguration`-only entry, and darwin-only ones separately. Shared code goes in an entry targeting both.
- A module whose file is `[ ]` (e.g. `modules/admin/keys.nix`) is valid and does nothing.

Hosts select modules via `modules` attrset:

```nix
modules = {
  services = [ "notes" "proxy" ];   # modules/services/notes.nix, modules/services/proxy.nix
  system = { };                     # empty attrset = top-level modules/system.nix
};
```

Each name resolves to `<dir>/<name>.nix` or `<dir>/<name>/default.nix` (assert error if missing). Host file provides `modules` and `configuration` (plain module, may use `imports`, `options`/`config`). The constructor's `hostName` sets `networking.hostName`; no host-level `name` is required. Constructors accept optional `hostExtraArgs` (merged into `specialArgs`) and `hostExtraModules` (appended after host/global modules), used by live variants.

**Only modules listed by a host are evaluated.** Unlisted modules can be stale/broken (e.g. `services/mkReset.nix` and `services/tournament.nix` reference `inputs.mkReset` etc. which are not in `flake.nix`; `editor/office.nix` uses old `config.impermanence.storageLocation`). Check `flake.nix` inputs before enabling a dormant module.

### specialArgs available in every module
`username` (`"vagahbond"`), `inputs` (all flake inputs), `libUtils` (`lib/utils.nix`, e.g. `libUtils.ifSupported config pkg` returns `[pkg]` only if platform supported).

External flake modules are pulled in per-module via `imports = [ inputs.<x>.nixosModules.default ];` inside `conf`, not globally.

## Impermanence

- `modules/impermanence.nix` defines `options.persistence.enable` (`mkEnableOption`, default false) and `options.persistence.storageLocation` (default `/nix/persistent`), and imports impermanence. Only base platypute enables it (tmpfs `/` of 6G, see `hosts/platypute/disk-config.nix`). Framework loads it but leaves it disabled; guest explicitly disables it. `live.nix` forces it off for every live variant, including platypute; the optional `live-persist` `/home` mount is separate.
- Convention: any nixos entry that needs state adds `environment.persistence.${config.persistence.storageLocation} = { directories = [...]; }` (or `users.${username}.directories`). New services storing data outside `/var/lib`, `/var/log`, `/var/cache`, `/var/tmp` must persist it or it is wiped on reboot.
- `pixel` has no impermanence; it stubs `options.environment.persistence` as a free `attrs` option in its host file so these declarations are ignored. Keep that in mind if a module references persistence options differently.

## Secrets (agenix, via `ragenix` input)

- Encrypted files: `secrets/*.age`. Recipients rules: `secrets/secrets.nix` (agenix rules file). Host public keys: `secrets/recipients.nix`.
- Master key `mk = framework` (same key as `air`) is on every secret; add host keys (`platypute`, `pixel`, `dedistonks`) as needed.
- Adding a secret: add rule to `secrets/secrets.nix`, then encrypt with `agenix -e <name>.age` from `secrets/` (the `agenix` binary is installed by `modules/security/secrets.nix`). After changing recipients, rekey (commit "secrets: rekey").
- Decryption identity: `~/.ssh/id_ed25519` of `username` (`age.identityPaths`).
- Declaring in a module (snake_case file, camelCase attr name):
  ```nix
  age.secrets.affineKey = {
    file = ../../secrets/affine_key.age;
    owner = "..."; group = "..."; mode = "400";
  };
  ```
  Consume with `config.age.secrets.<name>.path` (often `_secret = path` for NixOS options supporting it, or `environmentFile(s)`, or `$__file{...}` for grafana).
- `modules/network/ssh.nix` only declares SSH key secrets the current host is a recipient of (reads `secrets.nix` + `recipients.nix` by hostname). `modules/nix/remoteBuild.nix` adds build machines only if `config.age.secrets ? builder_access` / `builder_2_access`.
- `secrets/sshKeys.nix` is a function `{ pkgs, config, username }` returning `{ <name> = { pub; name; priv; }; }` for authorized keys.

## Service module conventions (`modules/services/`)

- Nearly all are `nixosConfiguration`-only and run on platypute.
- Typical layout, with banner comments: `# USERS`, `# SECRETS`, `# SERVICE`, `# PROXY` (`####...####` boxes).
- Exposed via nginx vhost on `*.vagahbond.com` with `forceSSL = true; enableACME = true;` proxying `http://127.0.0.1:<port>` (`proxyWebsockets = true`). ACME/nginx global settings + firewall 80/443 live in `services/proxy.nix`.
- Shared PostgreSQL 17 in `services/postgres.nix` (unix socket only, `enableTCPIP = false`; daily backups uploaded to S3 via rclone). Some apps (affine) instead run their own DB via `virtualisation.oci-containers`.
- Keep `doc/architecture.md` (mermaid diagram of domains, services, DB/S3 deps) in sync when adding/removing services or domains.

## Nix/build gotchas

- platypute is memory/disk constrained: `auto-optimise-store`, GC `--delete-older-than 1d`, `min-free` 10G, remote builder `maxJobs = 1`. Don't raise these casually; comments in `modules/nix/*.nix` explain why.
- NixOS `nix.settings.build-dir = "/nix/build-tmp"` (not `/tmp` or `/var/tmp`: world-writable ancestors are rejected, and root is tmpfs). Setting `TMPDIR` was tried and broke `nh`.
- darwin: `documentation.enable = false` and `system.tools.darwin-uninstaller.enable = false` work around nix-darwin#1817.
- `allowUnfree` enabled everywhere.
- nixpkgs tracks `nixpkgs-unstable`.

## Style

- Formatting looks like nixfmt (RFC style): one list item per line, multi-line function args.
- Use `pkgs.lib` or `lib` from module args; `with pkgs;` for package lists.
- `pkgs.stdenv.hostPlatform.system` for per-system flake package access (`inputs.x.packages.${pkgs.stdenv.hostPlatform.system}.default`).
- Commit messages: `<scope>: <lowercase summary>` (e.g. `notes: promote new instance to prod`, `flake: update`, `secrets: rekey`).

## Templates

`nix flake init -t .#mongodb` / `.#postgresql`: NodeJS dev shells, independent of the system config.
