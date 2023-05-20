{
  lib,
  options,
  specialArgs,
  config,
  modulesPath,
  inputs,
  ...
}: let
  username = ../../username.nix;
in {
  imports = [
    ../../modules
    inputs.agenix.nixosModules.default
  ];

  config = {
    age.identityPaths = [
      "/home/${username}/.ssh/*"
    ];

    modules = {
      graphics.type = "intel";

      browser.firefox.enable = true;

      dev = {
        enable = true;

        enableGeo = true;
        enableNetwork = true;

        languages = ["c-cpp" "nodejs" "nix"];
      };

      editor = {
        gui = ["vscode"];
        terminal = ["neovim"];
      };

      medias = {
        video = {
          player = true;
          downloader = true;
        };

        audio = {
          player = true;
        };

        image = {
          viewer = true;
          editor = true; # need to make those sweet meems
        };
      };

      network = {
        wifi.enable = true;
        bluetooth.enable = true;
        ssh.enableClient = true;
      };
    };
  };
}
