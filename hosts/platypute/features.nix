{inputs, ...}: let
  username = import ../../username.nix;
in {
  config = {
    modules = {
      impermanence.enable = true;

      editor = {
        terminal = ["neovim"];
      };

      network = {
        ssh.enable = false;
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
        proxy.enable = true;
        ssh.enable = true;
        nextcloud.enable = true;
        vaultwarden.enable = true;
        builder.enable = true;
        homePage.enable = true;
        blog.enable = true;
        universe.enable = true;
      };
    };
  };
}
