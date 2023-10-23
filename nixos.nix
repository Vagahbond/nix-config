# Some general immutable options for all hosts
{
  pkgs,
  self,
  ...
}: let
  #   docs = import ./doc {inherit (pkgs) lib runCommand nixosOptionsDoc;};
  username = import ./username.nix;
in {
  environment = {
    etc."current-flake".source = self;

    systemPackages = with pkgs; [
      cachix
      #   sed
    ];

    sessionVariables = {
      NIX_SSHOPTS = "-p 45 -t ";
    };
    # billions must use different ssh ports
    variables = {
      NIX_SSHOPTS = "-p 45 -t ";
    };
  };
  age.identityPaths = [
    "/nix/persistent/home/${username}/.ssh/id_ed25519"
    # "/nix/persistent/home/${username}/.ssh/id_rsa"
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      trusted-users = [
        "root"
        username
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };

    buildMachines = [
      {
        hostName = "vagahbond.com";
        system = "x86_64-linux";
        protocol = "ssh-ng";
        maxJobs = 4;
        speedFactor = 2;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
      }
    ];
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  home-manager.users.${username} = {
    nixpkgs.config = {
      allowUnfree = true;
    };

    home.stateVersion = "22.11";
  };

  system = {
    stateVersion = "22.11"; # Did you read the comment?
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };
}
