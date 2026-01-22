
    shellAliases = mkOption {
      type = types.attrs;
      default = { };
      description = ''
        Specific aliases for that system.
      '';
      example = {
        build = "sudo nixos-rebuild build";
      };
    };
  config = mkMerge [
    {
      # Just basic tools I like to use
      environment.systemPackages = with pkgs; [
        lsd
        fzf
        ripgrep
        fd
      ];

      fonts.packages = [ config.theme.font.package ];

    }
    /*
      (mkIf cfg.nh.enable {
        programs.nh = {
          enable = true;
          flake = "/home/${username}/Projects/nixos-config";
        };

      })
    */
    (mkIf cfg.tmux.enable (
      import ./tmux.nix {
        inherit pkgs;
      }
    ))
    (mkIf (cfg.shell == "zsh") {
      /*
        environment = {
          persistence.${storageLocation} = {
            users.${username} = {
              files = [
                ".zshrc"
              ];
            };
          };
        };
      */

      environment.shellAliases = {
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
      // cfg.shellAliases;

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;

        histSize = 10000;
      };

      # users.defaultUserShell = pkgs.zsh;
    })
  ];
}
