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
    - [Virtualization](#virtualization)
    - [Desktop](#desktop)
  - [Structure](#structure)
  - [Rice](#rice)
  - [Secrets](#secrets)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Objectives](#objectives)


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

### Virtualization
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
│   └── virtualization
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

## Installation

## Usage

## Objectives