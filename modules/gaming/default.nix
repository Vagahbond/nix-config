{
  pkgs,
  lib,
  config,
  inputs,
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
  imports = [
    ./options.nix
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.steamCompat
  ];

  config = mkMerge [
    (
      mkIf cfg.optimisations.enable
      (let
        path = lib.makeBinPath [
          config.programs.hyprland.package
          pkgs.coreutils
          pkgs.libnotify
        ];

        startscript = pkgs.writeShellScript "gamemode-start" ''
          export PATH=$PATH:${path}
          export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr | tail -1)
          hyprctl --batch 'keyword decoration:blur 0 ; keyword animations:enabled 0 ; keyword misc:vfr 0'

          notify-send "Enjoy gaming !"

        '';

        endscript = pkgs.writeShellScript "gamemode-end" ''
          export PATH=$PATH:${path}
          export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr | tail -1)
          hyprctl --batch 'keyword decoration:blur 1 ; keyword animations:enabled 1 ; keyword misc:vfr 1'

          notify-send "Now back to work! !"
        '';
      in {
        programs.gamemode = {
          enable = true;
          settings = {
            general = {
              softrealtime = "auto";
              renice = 15;
            };
            custom = {
              start = startscript.outPath;
              end = endscript.outPath;
            };
          };
        };

        boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

        services.pipewire = {
          lowLatency = {
            enable = true;
            quantum = 64;
            rate = 48000;
          };
        };

        security.rtkit.enable = true;
      })
    )
    (mkIf cfg.steering-wheel.enable {
      boot = {
        blacklistedKernelModules = ["hid-thrustmaster"];
        extraModulePackages = [config.boot.kernelPackages.hid-tmff2];
        kernelModules = ["hid-tmff2"];
      };
    })
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

        environment.systemPackages = with pkgs; [
          protontricks
        ];

        programs.steam = {
          enable = true;
          remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
          dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server

          extraCompatPackages = with pkgs; [
            steamtinkerlaunch
            gamescope
            inputs.nix-gaming.packages.${pkgs.system}.proton-ge
          ];
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
