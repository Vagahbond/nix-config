let

  starshipConfiguration = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "In [󱄅](bold red)$hostname at [](bold green) $directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package\n$character";

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
        format = " [$hostname](bold red)$ssh_symbol";
        disabled = false;
        ssh_symbol = " [via](none) [](bold red)";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };
in
{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  darwinConfiguration =
    { username, ... }:
    {

      home-manager.users.${username} = {
        programs.starship = starshipConfiguration;
      };
    };

  nixosConfiguration = _: {
    programs.starship = starshipConfiguration;
  };

}
