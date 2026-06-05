{
  description = "My modular NixOS configuration that totally did not take countless horus to make.";

  outputs =
    inputs:
    let
      extraArgs = {
        username = "vagahbond";

        inherit
          inputs
          ;
      };

      lib = import ./lib/modules.nix {
        inherit extraArgs inputs;
        inherit (inputs.nixpkgs) lib;
      };
    in
    {
      nixosConfigurations = {
        platypute = lib.mkNixosHost "platypute";
      };
      darwinConfigurations = {
        air = lib.mkDarwinHost "air";
      };
      nixOnDroidConfigurations = {
        pixel = lib.mkAndroidHost "pixel";
      };
    };

  # Imagine having no clean way to separate your system's dependencies...
  inputs = {
    # pin nixpkgs to switch to stable later
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/prerelease-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    disko.url = "github:nix-community/disko";

    agenix.url = "github:yaxitech/ragenix";

    nvf = {
      url = "github:notashelf/nvf";
      # url = "/Users/vagahbond/Projects/nvf";
    };

    autoDarkModeNvim = {
      url = "github:f-person/auto-dark-mode.nvim";
      flake = false;
    };

    nix-cooker.url = "github:vagahbond/nix-cooker";

    website = {
      url = "github:vagahbond/homepage";
    };

    audio-experiments = {
      url = "github:vagahbond/audio-experiments";
    };

    blog = {
      url = "github:vagahbond/blog";
    };

    firesplit = {
      url = "github:vagahbond/firesplit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mkReset = {
      # url = "/home/vagahbond/Projects/mk_reset_online";
      url = "github:jmsk8/mk_reset_online";
    };

  };
}
