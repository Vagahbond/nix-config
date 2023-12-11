{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  inherit (config.modules.impermanence) storageLocation;

  username = import ../../username.nix;

  cfg = config.modules.terminal;
in {
  imports = [./options.nix];
  config = mkMerge [
    (mkIf cfg.theFuck.enable {
      environment.systemPackages = with pkgs; [
        thefuck
      ];

      environment.persistence.${storageLocation} = {
        users.${username} = {
          directories = [
            ".config/thefuck"
          ];
        };
      };
    })
    (mkIf (cfg.shell == "zsh") {
      environment.persistence.${storageLocation} = {
        users.${username} = {
          files = [
            #".zsh_history"
            ".zshrc"
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        lsd
      ];

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases =
          {
            update = "sudo nixos-rebuild switch --no-write-lock-file --flake github:vagahbond/nix-config";
            build = "sudo nixos-rebuild build --no-write-lock-file --flake github:vagahbond/nix-config";
            nix-shell = "nix-shell --command zsh";
            ls = "lsd";
            l = "lsd";
            gc = "git commit";
            gaa = "git add -A";
            gp = "git push";
            c = "clear";
            dc = "docker compose";
          }
          // cfg.shellAliases;

        histSize = 10000;
      };

      programs.starship = {
        enable = true;

        settings = {
          format = "In [󱄅](bold green)$hostname at [](bold green) $directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package\n$character";

          right_format = ''
            $c
            $cmake
            $cobol
            $daml
            $dart
            $deno
            $dotnet
            $elixir
            $elm
            $erlang
            $fennel
            $golang
            $guix_shell
            $haskell
            $haxe
            $helm
            $java
            $julia
            $kotlin
            $gradle
            $lua
            $nim
            $nodejs
            $ocaml
            $opa
            $perl
            $php
            $pulumi
            $purescript
            $python
            $raku
            $rlang
            $red
            $ruby
            $rust
            $scala
            $solidity
            $swift
            $terraform
            $vlang
            $vagrant
            $zig
            $buf
            $nix_shell
            $conda
            $meson
            $spack
            $memory_usage
            $aws
            $gcloud
            $openstack
            $azure
            $env_var
            $crystal
            $custom
            $sudo
            $cmd_duration
            $line_break
            $jobs
            $battery
            $time
            $status
            $os
            $container
            $shell'';

          directory = {
            truncation_symbol = ".../";
            style = "bold green";
          };

          hostname = {
            ssh_only = false;
            format = " [$hostname](bold green)$ssh_symbol";
            disabled = false;
            ssh_symbol = " [via](none) [](bold green)";
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
