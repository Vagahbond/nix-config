{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration = {
    pkgs,
    config,
    ...
  }: {
    options = {
      shell.shellAliases = pkgs.lib.mkOption {
        type = pkgs.lib.types.attrs;
        default = {};
        description = ''
          Specific aliases for that system.
        '';
        example = {
          build = "sudo nixos-rebuild build";
        };
      };
    };
    config = {
      # Just basic tools I like to use
      environment.systemPackages = with pkgs; [
        lsd
        fzf
        ripgrep
        yazi
        fd
      ];

      environment.shellAliases =
        {
          build-iso-remote = "nix build github:vagahbond/nix-config#nixosConfigurations.live.config.system.build.isoImage";
          build-iso = "nix build .#nixosConfigurations.live.config.system.build.isoImage";
          run = "f() {nix run nixpkgs#$1}; f";
          ns = "nix-shell --command zsh";
          nd = "nix develop --command zsh";
          cat = "bat";
          ls = "lsd";
          l = "lsd";
          ff = "fzf";
          gc = "git commit";
          gaa = "git add -A";
          gp = "git push";
          c = "clear";
          dc = "docker compose";
          unzip-all = "for file in ./* ;do unzip -d \"\${file%.*}\" $file; done";
        }
        // config.shell.shellAliases;
    };
  };

  darwinConfiguration = {
    username,
    pkgs,
    ...
  }: {
    fonts.packages = [pkgs.nerd-fonts.departure-mono];

    home-manager.users.${username} = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
      };
    };
  };

  nixosConfiguration = {
    username,
    config,
    pkgs,
    ...
  }: {
    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      histSize = 10000;
    };
    environment = {
      persistence.${config.persistence.storageLocation} = {
        users.${username} = {
          files = [
            ".zshrc"
          ];
        };
      };
    };
  };
}
