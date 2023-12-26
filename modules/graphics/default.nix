{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  username = import ../../username.nix;

  isNvidiaEnabled = lib.lists.any (e: (e == config.modules.graphics.type)) ["nvidia-optimus" "nvidia"];
in {
  imports = [./options.nix];

  config = mkMerge [
    (
      mkIf (config.modules.graphics.type != null) {
        users.users.${username}.extraGroups = ["video"];
      }
    )
    (
      mkIf (config.modules.graphics.type == "nvidia") {
        hardware = {
          nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

          nvidia = {
            # Modesetting is required.
            modesetting.enable = true;

            # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
            powerManagement.enable = false;
            # Fine-grained power management. Turns off GPU when not in use.
            # Experimental and only works on modern Nvidia GPUs (Turing or newer).
            powerManagement.finegrained = false;

            # Use the NVidia open source kernel module (not to be confused with the
            # independent third-party "nouveau" open source driver).
            # Support is limited to the Turing and later architectures. Full list of
            # supported GPUs is at:
            # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
            # Only available from driver 515.43.04+
            # Do not disable this unless your GPU is unsupported or if you have a good reason to.
            open = true;

            # Enable the Nvidia settings menu,
            # accessible via `nvidia-settings`.
            nvidiaSettings = true;
          };

          # Enable OpenGL
          opengl = {
            extraPackages = with pkgs; [vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl];
            extraPackages32 = with pkgs.pkgsi686Linux; [vaapiIntel libvdpau-va-gl vaapiVdpau];
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
          };
        };
        services.xserver.videoDrivers = ["nvidia"];
      }
    )

    (
      mkIf
      (config.modules.graphics.type == "nvidia-optimus") {
        hardware = {
          nvidia = {
            package = config.boot.kernelPackages.nvidiaPackages.beta;

            open = true;
            modesetting.enable = true;

            nvidiaSettings = true; # add nvidia-settings to pkgs, useless on nixos
            #  nvidiaPersistenced = true;
            forceFullCompositionPipeline = true;

            powerManagement = {
              enable = false;
              # finegrained = true;
              # offload.enableOffloadCmd = true;
            };
          };
          # Enable OpenGL
          opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
            # extraPackages = with pkgs; [nvidia-vaapi-driver];
            # extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver];
          };
        };

        assertions = [
          {
            assertion = config.hardware.nvidia.prime.intelBusId != null;
            message = "Please provide intel bus ID in order to use the optimus config!";
          }
          {
            assertion = config.hardware.nvidia.prime.nvidiaBusId != null;
            message = "Please provide nvidia bus ID in order to use the optimus config!";
          }
          {
            assertion = config.modules.graphics.nvidia-path != "";
            message = "Please provide nvidia card path in order to use the optimus config!";
          }
          {
            assertion = config.modules.graphics.intel-path != "";
            message = "Please provide intel card path in order to use the optimus config!";
          }
        ];

        hardware.nvidia.prime.sync.enable = true;

        environment.systemPackages = with pkgs; [
          vulkan-tools
          vulkan-loader
          # vulkan-validation-layers
          libva
          libva-utils
          nvtop
        ];

        services.xserver.videoDrivers = ["nvidia"];

        # specialisation = {
        # on-the-go.configuration = {
        #   system.nixos.tags = ["on-the-go"];
        #   hardware.nvidia = {
        #     prime = {
        #       offload = {
        #         enable = lib.mkForce true;
        #         enableOffloadCmd = lib.mkForce true;
        #       };
        #       sync.enable = lib.mkForce false;
        #     };
        #   };
        # };
        # };
      }
    )
  ];
}
