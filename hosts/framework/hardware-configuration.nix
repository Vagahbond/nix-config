# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot.kernelParams = ["boot.shell_on_fail"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Impermanencing my whole system cause I like to suffer
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    # Set mode to 755 instead of 777 or openssh no worky
    options = ["relatime" "mode=755"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/27fd7c0c-49ec-4686-be77-c20262cfa3e9";
    fsType = "ext4";

    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FD68-78E8";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/nvme0n1p2";
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "framework"; # Define your hostname.
  networking.firewall.allowedTCPPorts = [57621];

  # networking.interfaces.wlp166s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';
}
