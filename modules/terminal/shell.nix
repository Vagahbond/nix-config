[

  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
    ];
    conf =
      { config, pkgs, ... }:
      {
        options = {
          shell.shellAliases = pkgs.lib.mkOption {
            type = pkgs.lib.types.attrs;
            default = { };
            description = ''
              Specific aliases for that system.
            '';
            example = {
              build = "sudo nixos-rebuild build";
            };
          };
        };

        config = {
          environment.systemPackages = with pkgs; [
            lsd
            fzf
            ripgrep
            yazi
            fd
          ];

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
          // config.shell.shellAliases;

          programs.zsh.interactiveShellInit = ''
            if ping -c 1 -W 1 8.8.8.8 >/dev/null 2>&1; then
              ${pkgs.curl}/bin/curl https://bible-api.com/data/web/random/PSA 2> /dev/null| jq -r '"\n \(.translation.name) Psalms — \(.random_verse.chapter):\(.random_verse.verse) — \(.random_verse.text | gsub("\n"; " ") | gsub("\\s+"; " ") | trim) "'
            fi
          '';
        };

      };
  }
  {
    targets = [ "darwinConfiguration" ];
    conf = _: {
      config = {

        programs.zsh = {
          enable = true;
          enableCompletion = true;
          enableSyntaxHighlighting = true;
          enableAutosuggestions = true;
        };
      };
    };
  }
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        username,
        config,
        pkgs,
        ...
      }:
      {
        config = {

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
      };
  }
]
