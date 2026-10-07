{
  modules = {
    dev = [
      "git"
      "network"
      "ai"
    ];
    editor = [
      "nvf"
    ];
    admin = [
      "keys"
    ];
    network = [
      "ssh"
    ];
    nix = [
      "nix"
      "remoteBuild"
    ];
    security = [
      "secrets"
    ];
    terminal = [
      "prompt"
      "shell"
      "rss"
      "music"
    ];
    system = { };
    user = { };
    desktop = { };
    impermanence = { };
  };

  configuration =
    {
      pkgs,
      config,
      inputs,
      username,
      architecture ? null,
      ...
    }:
    let
      updatePlatyputeScript = pkgs.writeScriptBin "upgrade-platypute" ''
        ssh -t platypute nh os switch "${config.environment.variables.NH_FLAKE}" --refresh;
      '';
    in
    {
      assertions = [
        # This host can only be used as a built ISO.
        {
          assertion = architecture != null;
          message = "This host can only be used as a built ISO.";
        }
      ];
      system.stateVersion = "26.11";
      nixpkgs.hostPlatform = "x86_64-linux";

      environment.systemPackages = [
        inputs.disko.packages.${pkgs.stdenv.hostPlatform.system}.default
        updatePlatyputeScript
      ];

      persistence.enable = false;

      users.users.${username}.hashedPassword =
        "$y$j9T$ofYLQRbiSsTERtHKAoi.J1$XW1xU541EsKvdMc3WNMEliNvUn4tVxKl99PbSB5gUg/";

    };
}
