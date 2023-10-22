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

    # billions must use different ssh ports
    variables = {
      NIX_SSHOPTS = "-p 45";
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
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
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
