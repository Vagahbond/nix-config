{
  description = "My modular NixOS configuration that totally did not take countless horus to make.";

  outputs =
    { self, ... }@inputs:
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

        globalModules = [ ];
      };

      liveEnvArchitectures = [
        "x86_64"
        "aarch64"
      ];

      baseConfigurations = {
        platypute = lib.mkNixosHost { hostName = "platypute"; };
        pixel = lib.mkNixosHost { hostName = "pixel"; };
        framework = lib.mkNixosHost { hostName = "framework"; };
        guest = lib.mkNixosHost { hostName = "guest"; };

      };

      mkLiveHostName = hostname: architecture: "${hostname}-live-${architecture}";

      liveEnvs = builtins.listToAttrs (
        builtins.concatMap (
          host:
          map (architecture: {
            name = mkLiveHostName host architecture;
            value = lib.mkNixosHost {
              hostName = host;
              hostExtraArgs = {
                inherit architecture;
              };
              hostExtraModules = [
                ./live.nix
              ];
            };
          }) liveEnvArchitectures
        ) (builtins.attrNames baseConfigurations)
      );

      isoBuildShortcuts = builtins.listToAttrs (
        map (architecture: {
          name = "${architecture}-linux";
          value = builtins.listToAttrs (
            map (hostname: {
              name = "${hostname}-live";
              value =
                self.nixosConfigurations.${mkLiveHostName hostname architecture}.config.system.build.isoImage;
            }) (builtins.attrNames baseConfigurations)
          );
        }) liveEnvArchitectures
      );

    in
    {
      nixosConfigurations = baseConfigurations // liveEnvs;

      darwinConfigurations = {
        air = lib.mkDarwinHost { hostName = "air"; };
      };

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell (import ./shell.nix { inherit pkgs; });
      });

      packages = isoBuildShortcuts;

      templates = {
        mongodb = {
          path = ./templates/mongodb;
          description = "NodeJS + MongoDB dev shell";
        };

        postgresql = {
          path = ./templates/postgresql;
          description = "NodeJS + PostgreSQL dev shell";
        };
      };
    };

  inputs = {
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
    };

    autoDarkModeNvim = {
      url = "github:f-person/auto-dark-mode.nvim";
      flake = false;
    };

    website = {
      url = "git+ssh://forgejo@git.vagahbond.com/vagahbond/homepage.git";

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

    affine-server = {
      url = "git+ssh://forgejo@git.vagahbond.com/vagahbond/nix-affine.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/nix-ai-tools";
    };

  };
}
