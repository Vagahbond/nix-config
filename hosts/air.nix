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
    ];
    system = { };
    user = { };
  };

  configuration =
    { pkgs, ... }:
    let
      updatePlatyputeScript = pkgs.writeScript "update-platypute" ''
        #!${pkgs.runtimeShell}
        set -euo pipefail

        ssh -t platypute nh os switch --refresh "$NIX_CONFIG";
      '';

    in
    {
      environment.systemPackages = [
        updatePlatyputeScript
      ];

      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";

    };
}
