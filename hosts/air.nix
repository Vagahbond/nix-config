{
  name = "air";
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
      "fingerprint"
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
  };

  configuration =
    { pkgs, config, ... }:
    let
      updatePlatyputeScript = pkgs.writeScriptBin "upgrade-platypute" ''
        ssh -t platypute nh os switch "${config.environment.variables.NH_FLAKE}" --refresh;
      '';

    in
    {
      environment.systemPackages = [
        updatePlatyputeScript
        pkgs.timewarrior
      ];

      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";

    };
}
