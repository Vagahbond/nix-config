![](https://github.com/vagahbond/nix-config/actions/workflows/alejandra.yml/badge.svg)

![](https://github.com/vagahbond/nix-config/actions/workflows/build.yml/badge.svg)

# My nixos dotfiles

Welcome to my nixos dotfiles. I use these to configure my nixos machines.

The objective is to run it on several machines : 
- [x] working laptop (Framework 13" laptop, go buy one NOW)
- [ ] gaming laptop (mid-2019 Razer Blade 15)
- [ ] kubernetes master node (some bare metal in some datacenter)
- [ ] home made server (some old 2012 Toshiba satelite lol)

This configuration aims to be a modular abstraction of NixOS's configuration options. It is organized per feature, and each feature is a module that can be enabled or disabled with fewest options possible.

Each software is individually configured the way that I like it, in a way that I'll always find familiar interfaces  and quircks on each of my machines.

You can easily fork this repo and make it yours by changing the deep configuration for each software. I believe this architecture is made to be used as a template for your own dotfiles.

Secrets are managed using [ragenix](https://github.com/yaxitech/ragenix). You'll have to create `.age` files yourself and use youur own SSH keys to use those values.

I'll provide a few informations to help you understand how to use this repo. For any question, open an issue, or find me on Hyprland/NixOS discord servers.

## Table of contents

- [My nixos dotfiles](#my-nixos-dotfiles)
  - [Table of contents](#table-of-contents)
  - [Features](#features)
    - [Browser](#browser)
    - [Development](#development)
    - [Editor](#editor)
    - [Input](#input)
    - [Locales](#locales)
    - [Medias](#medias)
    - [Network](#network)
    - [Output](#output)
    - [Productivity](#productivity)
    - [Security](#security)
    - [Social](#social)
    - [System](#system)
    - [Terminal](#terminal)
    - [virtualisation](#virtualisation)
    - [Desktop](#desktop)
  - [Structure](#structure)
  - [Rice](#rice)
  - [Secrets](#secrets)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Objectives](#objectives)
  - [Special mentions](#special-mentions)


## Features
Here's a simplified tree of what I use for each feature.
If you do not want one of them on your machine, just remove it from the `imports` list in the corresponding `default.nix` file.

For each of these options there will be an enable option, and no more in most cases. Settings will be kept as minimum as possible. 

That way, each device gets to simply enable or disable features depending on their purposes.

By default, for each enabled feature, GUI elements are disabled if the `gui` option is set to false, and enabled otherwise. That war, each feature is defined the same way for servers and desktops.

### Browser
    * Firefox and a few extensions    

### Development
    * Geographical Information System
      * QGIS
    * Http debugging
      * insomnia
    * VCS
      * git
      * gh-cli
      * lazygit
    * languages
      * C/C++
      * Ruby
      * NodeJS
      * Rust
      * Nix
      * Android
  
### Editor
    * Terminal
      * [neovim-flake](https://github.com/notashelf/neovim-flake) (Thanks NotAShelf !)
    * GUI
      * VSCode (Go on, judge me !)
    
### Input
    * Graphic Tablet
      * opentabletdriver
    * USB
      * usbutils
      * libusb
    * Mousepad
      * libinput

### Locales
    * Zone
      * time.timezone
    * Keyboard
      * defaultLocale (default: en_US.UTF-8)
  
### Medias
    * Video
      * vls
      * shotcut
      * handbrake
    * Audio
      * spicetify
      * audacity
    * Image
      * gimp
      * nomacs
    * p2p
      * nicotine-plus

### Network
    * Wifi
      * wpa_gui
      * wpa_supplicant
    * SSH
      * openssh
      * sshs
    * Bluetooth
      * hardware.bluetooth

### Output
    * Sound
      * pavucontrol
      * pipewiere
      * alsa
      * pulse
    * Printing
      * service.printing
  
### Productivity
    * Notes
      * Notion

### Security
    * Passwords
      * password-store
      * bitwarden
    * fingerprint reader
      * fprintd
    * Keyring
      * gnome-keyring
      * seahorse

### Social
    * Chat
      * Discord
      * whatsapp-for-linux
    * Work
      * teams (god please no what an abobination)

### System
    * Utilities
      * zip
      * unzip
      * rar
      * curl
      * tree
      * wget
      * ntfs3g
      * htop/btop
  
### Terminal
    * Shell
      * zsh
    * Style
      * OhMyZsh
    * Utilities
      * thefuck

### virtualisation
    * Docker
      * Docker-compose
      * lazydocker
    * Virtualbox
    * KVM+virt-manager
      * spiceUSBredirection
    * Podman (soon to come)


### Desktop
    * Hyprland
      * Bar
        * eww
      * Screen sharing
        * wireplumber
      * Screenshot
        * grim
        * glurp
      * Clip
        * cliphist
        * wl-clipboard
      * Colors
        * pywal 
        * pywalfox
        * colorz
        * colorthief
      * Lock
        * swaylock-effects
      * Launcher
        * wofi
        * wofi-emoji
      * File explorer
        * thunar
      * Terminal
        * foot
      * Display Manager
        * SDDM with catppuccin theme !
      * fonts
        * nerd FiraCode
        * nerd DroidSansMono
        * nerd Noto
        * font-awesome
        * noto-fonts
      * Backlight
        * light
      * Compositor
        * Hyprland (unexpected, huh ?)
      * Notifications
        * Mako

## Structure 
The main structure of the conf is contained in the `modules` folder. Each module is a feature, and each feature is a folder containing a `default.nix` file and, if needed for inputs, a `flake.nix` file.

These distributed nix files allow to couple tightly inputs and configuration for each feature. That way, depending on the configuration, it's possible to remove useless inputs from the system.

Files that are in `hosts` containe host-specific configuration, and options for every present module. 

```
.
├── flake.lock
├── flake.nix
├── hosts
│   ├── blade
│   ├── default.nix
│   └── framework
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

## Secrets

Secrets are value that I don't want you, little hacker, to know. They are managed using [ragenix](https://github.com/yaxitech/ragenix). 
Ragenix is a tool that allows to manage secrets using age encryption, and to use them in nixos configuration.

To use secrets, you'll have to create your own `.age` files, and use your own SSH keys to encrypt them.

Then, thanks to the configuration in `secrets/secrets.nix`, nix will be able to decrypt them and use them in the configuration while building the system.

Secrets in this configuration cover the following features :
- [x] Wifi
- [ ] SSH keys for GitHub, GitLab, or specific servers
- [ ] Spotify API key
- [ ] Kubernetes kubeconfig
## Installation
This configuration is based on a flake. To use it, you'll need to have a recent version of nix installed on your machine.

By default, you get a `hardware-configuration.nix` file that is generated by `nixos-generate-config` command. This file will go on your `host` folder when creating a host in this configuration.

To install this configuration, you'll need to run the following command : 
```bash
nixos-install --flake github:vagahbond/nixos-dotfiles
```

Make sure that you also copy your SSH private keys to `~/.ssh`, and add your public keys to the secrets configuration.

If the host is already preconfigured, add the right hostname to the previous command: 
```bash
nixos-install --flake github:vagahbond/nixos-dotfiles#blade
```

Then, you should be able, when modifying your config to install it with the following command : 
```bash
nixos-rebuild switch --flake <your-flake-url>
```

or if needed to test it with the following command : 
```bash
nixos-rebuild test --flake <your-flake-url>
```

## Usage
This configuration is adapted to my own needs so I insist that you should be changing it for your own tastes.

What I want to propose here is an architecture, a model to start from. I want to propose a way to organize your dotfiles, and a way to manage secrets, while keeping your configuration readablem, and as modular as possible.

What I would advise you to do is to fork this repo, and to change the configuration for each software to your own tastes.

## Objectives
Here are a few things left to do in this repository: 
- [x] Create every configuration options (god this is gonna take long)
- [ ] Scatter files better in the configuration
- [ ] A way to manage secrets using a password manager (Bitwarden)
- [ ] Ssh server functionnality for my servers
- [ ] Podman configuration (I've been told it's better than docker on nixos)
- [ ] Kubernetes installation for my kubernetes master node
- [ ] Preconfigured Lens for kubernetes
- [ ] Spotifyd configuration to use my server as a spotify connect device
- [ ] scatter users groups
- [ ] Reproducible VSCode configuration
- [ ] Reproducible Firefox configuration
- [ ] Add my hosts:
  - [ ] Blade
  - [ ] Kubernetes server
  - [ ] Home server

## Special mentions
- Special thanks to [NotAShelf](https://github.com/NotAShelf) for his [nyx](https://github.com/NotAShelf/nyx) and his [neovim-flake](https://github.com/NotAShelf/neovim-flake) repos that help lots of people win precious time and energy. 

- Thanks to people on Hyprland and NixOS discord servers for their help and support.

- Thanks [Vaxry](https://github.com/vaxerski) for all his work on Hyprland and its community.
  

If you're starting with Arch and rices, maybe my [previous rice](https://github.com/Vagahbond/reyece) could help you. It's a bit outdated but it's a good start.

