{inputs, ...}: let
  username = import ../../username.nix;
in {
  config = {
    age.identityPaths = [
      "/home/${username}/.ssh/id_ed25519"
    ];

    modules = {
      impermanence.enable = true;
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
        ntfs.enable = true;
        compression.enable = true;
      };

      terminal = {
        theFuck.enable = true;
        shell = "zsh";
      };

      virtualisation = {
        docker.enable = true;
      };

      services = {
        ssh.enable = true;
        nextcloud.enable = true;
        vaultwarden.enable = true;
        builder.enable = true;
        homePage.enable = true;
        blog.enable = true;
      };
    };
  };
}
