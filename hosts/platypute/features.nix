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
        containers.enable = true;
        docker.enable = true;
      };

      services = {
        ssh.enable = true;
        proxy.enable = true;
        nextcloud.enable = true;
        vaultwarden.enable = true;
        builder.enable = true;
        homePage = {
          enable = true;
          proxied = true;
          internalAddr = "192.168.100.3";
          externalAddr = "yoni-firroloni.com";
        };
        blog.enable = true;
      };
    };
  };
}
