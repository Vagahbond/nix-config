<div align="center">
  <p>
    <img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/vagahbond/nix-config/build.yml?color=%23cba6f7&logo=nixos&logoColor=%23cba6f7&style=flat-square">
    <img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/vagahbond/nix-config/alejandra.yml?color=%2374c7ec&logo=eslint&logoColor=%2374c7ec&style=flat-square">
  </p>
</div>

# My nixos dotfiles

Welcome to my nixos dotfiles. I use these to configure my nixos machines.

[Check the options here!](https://vagahbond.github.io/nix-config/)

This configuration aims to be a modular abstraction of NixOS's configuration options. It is organized per feature, and each feature is a module that can be enabled or disabled with fewest options possible.

Each software is individually configured the way that I like it, so all of my machines can be of the same experience for me.

## How to use

1. Fork this repo on the machine you want
2. Change the name in `username.nix` to yours
3. In the `hosts` folder, add your own host: a folder named after it
4. Copy-paste the `default.nix` file from any other host.
5. You can copy-paste `features.nix` from another host or create your own using [this documentation](https://vagahbond.github.io/nix-config/)
6. On your target host, generate a `hardware-configuration.nix` and add it to your host directory with the two other files. If you intend to use Impermanence, dont forget to setup the tmpfs mounts. Examples available on my hosts.
7. Format your disks on the target host using [nixos's tutorial](https://nixos.wiki/wiki/NixOS_Installation_Guide#Partitioning) or your own wae.
8. Generate your ssh key that'll be used for your host and add it to `secrets.nix`. Of course, create your own secrets if needed and remove mines.
9. Use your fork or clone of this repo to install your host: from a nixos ISO, run this command:

```bash
nixos-install --flake github:<yourusername>/<yourfork>#<yourhost>
```

10. Reboot. you might need a `nixos-rebuild switch --flake <your-flake-url>`

You're done !

It might seem like a lot of steps but don't forget this config sets up your whole system.

## Structure

The main structure of the conf is contained in the `modules` folder. Each module is a feature, and each feature is a folder containing a `default.nix` file and an `options.nix`.

The flake inputs were centralized to `flake.nix` because it's more stabel and I am too lazy to use a patched nix.

Files that are in `hosts` contain host-specific configuration(such as `hardware-configuration.nix`), and options for every present module.

```
.
├── flake.lock
├── flake.nix
├── hosts
│   ├── blade
│   ├── default.nix
│   └── framework
│       ├── default.nix
│       └── hardware-configuration.nix
├── modules
│   ├── browser
│   ├── default.nix
│   ├── desktop
│   ├── dev
│   ├── editor
│   ├── flake.nix
│   ├── input
│   ├── locales
│   ├── medias
│   ├── network
│   ├── output
│   ├── productivity
│   ├── security
│   ├── social
│   ├── system
│   ├── terminal
│   └── virtualisation
├── nixos.nix
├── readme.md
├── result -> /nix/store/0bg3g9v6ivvs57yib91h2w4d59qsaip5-nixos-system-framework-23.05.20230516.963006a
├── secrets
│   ├── edit_secret.sh
│   ├── secrets.nix
│   ├── wifi.age
│   └── wifi.env
├── username.nix
└── user.nix
```

## Rice

Desktops are separated in rices, that way the conf is prepared to welcome several different rice (we all know ricers here right, cannot live 2 seconds without starting a new rice).

Each rice is a folder in `modules/desktop/rices`. Each rice contains a `default.nix` file that contains the configuration for the rice, and a `flake.nix` file that contains the inputs for the rice.

For more info on my rice and dotfiles, head to [this documentation](./modules/desktop/hyprland/readme.md).

**Deprecation** Beware, I intend too extend this functionnality usign another repository and to make it even more overengineered.

## Secrets

Secrets are value that I don't want you, little hacker, to know. They are managed using [ragenix](https://github.com/yaxitech/ragenix).
Ragenix is a tool that allows to manage secrets using age encryption, and to import them in nixos configuration without putting them in clear in your repos.

To use secrets, you'll have to create your own `.age` files, and use your own SSH keys to encrypt them.

Then, thanks to the configuration in `secrets/secrets.nix`, nix will be able to decrypt them and use them in the configuration while building the system.

Check the `secrets` dir to find what secrets there are in this conf or how to manage them.

## Impermanence

Impermanence allows to boot en tmpfs and easily bind files and folders for apps that I use. This way, I only persist what I need for my apps to work, nothing more.

## Usage

This configuration is adapted to my own needs so I insist that you should be changing it for your own tastes.

What I want to propose here is an architecture, a model to start from. I want to propose a way to organize your dotfiles, and a way to manage secrets, while keeping your configuration readablem, and as modular as possible.

What I would advise you to do is to fork this repo, and to change the configuration for each software to your own tastes.

## Objectives

Hosts:

- [x] Framework: working laptop (Framework 13" laptop, go buy one NOW)
- [x] Blade: gaming laptop (mid-2019 Razer Blade 15)
- [x] Dedistonks: multi-purpose on-premise server in some data-center
- [ ] Idkyet: home made server (some old 2012 Toshiba satelite lol)

Tasks:

- [x] Create every configuration options (god this is gonna take long)
- [x] Scatter files better in the configuration
- [x] A way to manage secrets using a password manager (Bitwarden)
- [x] Ssh server functionnality for my servers
- [ ] Podman configuration (I've been told it's better than docker on nixos)
- [x] Preconfigured Lens for kubernetes
- [x] scatter users groups
- [x] Reproducible VIM configuration
- [x] Reproducible Firefox configuration
- [ ] Make an ISO with a script or something that makes it very easy to install this setup and bootstrap a host.
- [ ] make only one ISO fit all hosts with needed functionalities and available config

## Special mentions

- Special thanks to [NotAShelf](https://github.com/NotAShelf) for his [nyx](https://github.com/NotAShelf/nyx) and his [neovim-flake](https://github.com/NotAShelf/neovim-flake) repos that help lots of people win precious time and energy. Although Raf is a cunt and I wish that he trips on a tree root and eat dirt.

- Thanks to people on Hyprland and NixOS discord servers for their help and support.

- Thanks [Vaxry](https://github.com/vaxerski) for all his work on his wayland compositor Hyprland and its community.

If you're starting with Arch and rices, maybe my [previous rice](https://github.com/Vagahbond/reyece) could help you. It's a bit outdated but it's a good start.
