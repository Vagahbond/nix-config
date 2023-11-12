{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  # TODO: Chain derivations in a cleaner way for tlauncher and dofus
  inherit (config.modules) graphics impermanence;

  username = import ../../username.nix;

  cfg = config.modules.gaming;

  dofus = import ./dofus.nix {inherit pkgs;};

  tlauncher = import ./tlauncher.nix {inherit pkgs;};
in {
  imports = [./options.nix];

  config = mkMerge [
    (mkIf (cfg.dofus.enable
      && (graphics.type != null)) {
      environment.persistence.${impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            ".config/Ankama"
            ".config/Ankama Launcher"
          ];
        };
      };

      environment.systemPackages = [
        dofus
        (
          pkgs.writeTextDir "share/applications/dofus.desktop" ''
            [Desktop Entry]
            Version=2.68
            Type=Application
            Name=Dofus
            Exec=dofus
            StartupWMClass=AppRun
          ''
        )
      ];
    })
    (
      mkIf (cfg.wine.enable && (graphics.type != null)) {
        environment.systemPackages = [
          wine-wayland
        ];
      }
    )
    (
      mkIf (cfg.steam.enable && (graphics.type != null)) {
        environment.persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".steam"
            ];
          };
        };

        programs.steam = {
          enable = true;
          remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
          dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        };
        hardware.opengl.driSupport32Bit = true; # Enables support for 32bit libs that steam uses
      }
    )
    (
      mkIf (cfg.minecraft.enable && (graphics.type != null)) {
        environment.persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".minecraft"
            ];
          };
        };
        environment.systemPackages = [
          pkgs.minecraft
        ];
      }
    )
    (
      mkIf (cfg.tlauncher.enable && (graphics.type != null)) {
        # TODO: Fix the derivation and
        environment.systemPackages = [
          tlauncher
          (
            pkgs.writeTextDir "share/applications/tlauncher.desktop" ''
              [Desktop Entry]
              Version=2.885
              Type=Application
              Name=TLauncher
              Exec=${pkgs.jdk17}/bin/java -jar ${tlauncher}/TLauncher.jar
              StartupWMClass=AppRun
            ''
          )
        ];
      }
    )
  ];
}
