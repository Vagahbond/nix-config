{
  description = "My modular NixOS configuration that totally did not take countless horus to make.";

  outputs =
    inputs:
    let

      forAllSystems =
        function:
        inputs.nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-darwin" # Imagine nixing a mac
          ]
          (
            system:
            function (
              import inputs.nixpkgs {
                inherit system;
                config.allowUnfree = true;
              }
            )
          );

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

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            mermaid-cli
            # ZSH
            entr
          ];

          shellHook = ''
            echo "Editing my NixOS configuration!"
          '';
        };
      });
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
      url = "git+ssh://forgejo@git.vagahbond.com/vagahbond/homepage.git";

      inputs.nixpkgs.follows = "nixpkgs";

    };

    audio-experiments = {
      url = "git+ssh://forgejo@git.vagahbond.com/vagahbond/audio-experiments.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blog = {
      url = "git+ssh://forgejo@git.vagahbond.com/vagahbond/blog.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firesplit = {
      url = "git+ssh://forgejo@git.vagahbond.com/vagahbond/firesplit.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
}
