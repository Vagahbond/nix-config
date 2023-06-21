{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.terminal;
in {
  options.modules.terminal = {
    theFuck.enable = mkEnableOption "Enable if you have fat fingers";

    shell = mkOption {
      type = types.enum ["zsh" "shell"];
      default = "zsh";
      description = ''
        Select the shell you want to use.

        So far only zsh is available.
      '';
      example = "zsh";
    };

    shellAliases = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Specific aliases for that system.
      '';
      example = {
        build = "sudo nixos-rebuild build";
      };
    };
  };

  config =
    mkMerge [
      (mkIf cfg.theFuck.enable {
        environment.systemPackages = with pkgs; [
          thefuck
        ];
      })
      (mkIf (cfg.shell == "zsh") {
          programs.zsh = {
            enable = true;
            enableCompletion = true;
            # ohMyZsh = {
            #   enable = true;
            #   plugins = [
            #     "git"
            #   ];

            #   theme = "refined";
            # };
            autosuggestions.enable = true;
            syntaxHighlighting.enable = true;
            shellAliases =
              {
                update = "sudo nixos-rebuild switch --flake ~/vagahbond-dotfiles";
                build = "sudo nixos-rebuild build --flake ~/vagahbond-dotfiles";
              }
              // cfg.shellAliases;
          };

          programs.starship = {
            enable = true;

            settings = {
              format = "$username$hosntame$directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package\n[󱄅](bold green) $character";

              right_format = "$c\
$cmake\
$cobol\
$daml\
$dart\
$deno\
$dotnet\
$elixir\
$elm\
$erlang\
$fennel\
$golang\
$guix_shell\
$haskell\
$haxe\
$helm\
$java\
$julia\
$kotlin\
$gradle\
$lua\
$nim\
$nodejs\
$ocaml\
$opa\
$perl\
$php\
$pulumi\
$purescript\
$python\
$raku\
$rlang\
$red\
$ruby\
$rust\
$scala\
$solidity\
$swift\
$terraform\
$vlang\
$vagrant\
$zig\
$buf\
$nix_shell\
$conda\
$meson\
$spack\
$memory_usage\
$aws\
$gcloud\
$openstack\
$azure\
$env_var\
$crystal\
$custom\
$sudo\
$cmd_duration\
$line_break\
$jobs\
$battery\
$time\
$status\
$os\
$container\
$shell";

              directory = {
                truncation_symbol = "../";
                style = "bold green";
              };

              character = {
                success_symbol = "[❯](bold green)";
                error_symbol = "[✗](bold red)";
              };
            };
          };

          users.defaultUserShell = pkgs.zsh;
        })
    ];
}
