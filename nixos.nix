{
  pkgs,
  self,
  ...
}: let
  username = import ./username.nix;
in {
  home-manager.users.${username} = {
    nixpkgs.config = {
      allowUnfree = true;
    };

    home.stateVersion = "22.11";
  };

  environment.etc."current-flake".source = self;

  environment.systemPackages = with pkgs; [
    cachix
    #   sed
  ];

  age.identityPaths = ["/home/${username}/.ssh/id_ed25519" "/home/${username}/.ssh/id_rsa"];

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
      options = "--delete-older-than 7d";
    };
  };

  system = {
    stateVersion = "22.11"; # Did you read the comment?
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };
}
