# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = [];
    initrd.kernelModules = [];
    kernelModules = ["virtio-pci"];
    extraModulePackages = [];
    kernelParams = ["boot.shell_on_fail"];

    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # Impermanencing my whole system cause I like to suffer
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      # Set mode to 755 instead of 777 or openssh no worky
      options = ["relatime" "mode=755"];
    };

    "nix" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";

      neededForBoot = true;
    };

    "boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
  };
  swapDevices = [
    # {
    #   device = "/dev/sda3";
    # }
  ];

  # MFW No DHCP
  networking = {
    # usePredictableInterfaceNames = false;
    interfaces.ens18.ipv4.addresses = [
      {
        address = "192.168.0.18";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.0.1";
    useDHCP = false;
    hostName = "dedistonks"; # Define your hostname.
    firewall.allowedTCPPorts = [45];
    nameservers = ["8.8.8.8" "4.4.4.4"];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  systemd.services.nix-daemon = {
    environment = {
      # Where temp files need to go to avoid filling the whole ram
      TMPDIR = "/var/cache/nix";
    };

    serviceConfig = {
      # Create /var/cache/nix on daemon start
      CacheDirectory = "nix";
    };
  };

  # Force even root to use our custom cache folder
  environment.variables.NIX_REMOTE = "daemon";
}
