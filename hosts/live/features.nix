{inputs, ...}: let
  username = import ../../username.nix;
in {
  config = {
    rice = null;

    modules = {
      impermanence.enable = false;

      graphics.type = null;

      desktop = {
        session = null;
      };

      editor = {
        gui = [];
        terminal = ["neovim"];
      };

      system = {
        compression.enable = true;
      };

      terminal = {
        theFuck.enable = true;
        shell = "zsh";
        shellAliases = {
          clone-config = "git clone https://github.com/vagahbond/nix-config";
          format-disks = "f(){ nix run github:nix-community/disko -- --mode disko $1}; f";
          mount-disk = "f(){ sudo mkdir -p /mnt/nix && sudo mount /dev/$1 /mnt}; f";
          install = "f() {nixos-install --flake .#$1}; f";
        };
      };
    };
  };
}
