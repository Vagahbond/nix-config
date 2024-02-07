{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  username = import ../../username.nix;

  cfg = config.modules.graphics;

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
      (config.modules.graphics.type == "nvidia-passthrough")
      {
        hardware = {
          nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

          nvidia = {
            modesetting.enable = true;
            powerManagement.enable = false;
            powerManagement.finegrained = false;
            open = true;
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
        boot = {
          extraModprobeConfig = ''
            options nvidia-drm modeset=1
          '';
          blacklistedKernelModules = ["nouveau"];

          kernelModules = [
            "vfio_pci"
            "vfio"
            "vfio_iommu_type1"
            # "vfio_virqfd"

            # "nvidia"
            # "nvidia_modeset"
            # "nvidia_uvm"
            # "nvidia_drm"
          ];

          kernelParams = [
            ("vfio-pci.ids=" + lib.concatStringsSep "," cfg.gpuIOMMUIds)
            "intel_iommu=on"
          ];
        };
        assertions = [
          {
            assertion = cfg.gpuIOMMUIds != [];
            message = "Please provide GPU video PCI ID for passthrough to work !";
          }
        ];
      }
    )

    (
      mkIf
      (config.modules.graphics.type == "nvidia-optimus") {
        boot = {
          initrd.kernelModules = [
            "nvidia"
            "nvidia_modeset"
            "nvidia_uvm"
            "nvidia_drm"
          ];

          extraModprobeConfig = ''
            options nvidia-drm modeset=1
          '';
          blacklistedKernelModules = ["nouveau"];
        };

        hardware = {
          nvidia = {
            package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;

            open = true;
            modesetting.enable = true;

            nvidiaSettings = true; # add nvidia-settings to pkgs, useless on nixos
            #  nvidiaPersistenced = true;
            forceFullCompositionPipeline = true;

            powerManagement = {
              enable = false;
            };

            prime = {
              offload = {
                enable = true;
                enableOffloadCmd = true;
              };
              sync.enable = false;
            };
          };

          # Enable OpenGL
          opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
            extraPackages = with pkgs; [nvidia-vaapi-driver libvdpau-va-gl vaapiVdpau];
            extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver libvdpau-va-gl vaapiVdpau];
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

        environment.systemPackages = with pkgs; [
          vulkan-tools
          vulkan-loader
          # vulkan-validation-layers
          libva
          libva-utils
          nvtop
        ];

        services.xserver.videoDrivers = ["nvidia"];
      }
    )
  ];
}
