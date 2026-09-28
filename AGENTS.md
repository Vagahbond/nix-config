# AGENTS.md

Personal multi-host Nix flake (NixOS + nix-darwin) for user `vagahbond`. No home-manager. No tests, no CI (`.github/` is empty).

## Hosts (exposed in `flake.nix`)

| Output | Host file | Platform | Notes |
|---|---|---|---|
| `nixosConfigurations.platypute` | `hosts/platypute/` | x86_64-linux | Main server: nginx, services, postgres, docker. tmpfs root (disko) + impermanence. |
| `nixosConfigurations.pixel` | `hosts/pixel.nix` | aarch64-linux | Android AVF VM (`inputs.avf`). No impermanence. |
| `darwinConfigurations.air` | `hosts/air.nix` | aarch64-darwin | MacBook. |

`hosts/live/` is NOT wired in the flake and uses an old, incompatible host schema (`platform`, `rice`, `terminal.shell`...). Treat as dead code.

Adding a host: create `hosts/<name>.nix` or `hosts/<name>/default.nix`, then add `lib.mkNixosHost "<name>"` / `lib.mkDarwinHost "<name>"` in `flake.nix`.

## Commands

```sh
# Build/switch (nh is installed by modules/nix/nix.nix)
nh os switch . --hostname platypute --build-host platypute --target-host platypute
nh os switch --dry --build-host platypute --target-host platypute --hostname platypute . --show-trace   # from hosts/platypute/default.nix

# Evaluate without building
nix eval .#nixosConfigurations.platypute.config.system.build.toplevel.drvPath
nix eval .#darwinConfigurations.air.system.drvPath

nix flake update          # most commits are "flake: update"
nix develop               # devShell: mermaid-cli + entr (for doc/architecture.md)
```

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

Each name resolves to `<dir>/<name>.nix` or `<dir>/<name>/default.nix` (assert error if missing). Host file must provide `name` (becomes `networking.hostName`), `modules`, and `configuration` (plain module, may use `imports`, `options`/`config`).

**Only modules listed by a host are evaluated.** Unlisted modules can be stale/broken (e.g. `services/mkReset.nix` and `services/tournament.nix` reference `inputs.mkReset` etc. which are not in `flake.nix`; `editor/office.nix` uses old `config.impermanence.storageLocation`). Check `flake.nix` inputs before enabling a dormant module.

### specialArgs available in every module
`username` (`"vagahbond"`), `inputs` (all flake inputs), `libUtils` (`lib/utils.nix`, e.g. `libUtils.ifSupported config pkg` returns `[pkg]` only if platform supported).

External flake modules are pulled in per-module via `imports = [ inputs.<x>.nixosModules.default ];` inside `conf`, not globally.

## Impermanence

- `modules/impermanence.nix` defines `options.persistence.storageLocation` (default `/nix/persistent`) and imports impermanence. Only platypute uses it (tmpfs `/` of 6G, see `hosts/platypute/disk-config.nix`).
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
