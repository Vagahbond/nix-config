{
  lib,
  options,
  specialArgs,
  config,
  modulesPath,
  ...
}: let
  username = ../../username.nix;
in {
  imports = [
    ../../modules
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
    };
  };
}
