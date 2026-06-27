{
  description = "My modular NixOS configuration that totally did not take countless horus to make.";

  outputs =
    inputs:
    let
      extraArgs = {
        username = "vagahbond";

        libUtils = import ./lib/utils.nix;

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
        pixel = lib.mkNixosHost "pixel";
      };
      darwinConfigurations = {
        air = lib.mkDarwinHost "air";
      };
    };

  # Imagine having no clean way to separate your system's dependencies...
  inputs = {
    # pin nixpkgs to switch to stable later
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    avf = {
      url = "github:nix-community/nixos-avf";
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

    website = {
      url = "github:vagahbond/homepage";

      inputs.nixpkgs.follows = "nixpkgs";

    };

    audio-experiments = {
      url = "github:vagahbond/audio-experiments";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blog = {
      url = "github:vagahbond/blog";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firesplit = {
      url = "github:vagahbond/firesplit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mkReset = {
      # url = "/home/vagahbond/Projects/mk_reset_online";
      url = "github:jmsk8/mk_reset_online";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tournament = {
      url = "git+ssh://git@github.com/Vagahbond/tournment-app-project.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
}
