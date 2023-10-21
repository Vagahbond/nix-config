{inputs, ...}: let
  username = import ../../username.nix;
in {
  imports = [
    ../../modules
    inputs.agenix.nixosModules.default
  ];

  config = {
    age.identityPaths = [
      "/home/${username}/.ssh/id_ed25519"
    ];

    modules = {
      dev = {
        enable = true;
        languages = ["nix"];
      };

      editor = {
        terminal = ["neovim"];
      };

      network = {
        ssh.enable = false;
      };

      security = {
        keyring.enable = true;
        polkit.enable = false;
      };

      system = {
        processManager = "htop";
        ntfs.enable = true;
        compression.enable = true;
      };

      terminal = {
        theFuck.enable = true;
        shell = "zsh";
      };

      services = {
        ssh.enable = true;
      };
    };
  };
}
