{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["ata_piix" "virtio_pci" "virtio_scsi" "sd_mod"];
      kernelModules = ["virtio-pci" "virtio_scsi" "virtio-blk" "virtio-net" "scsi_mod"];
    };
    kernelModules = ["kvm-amd" "virtio-pci" "virtio_scsi" "virtio-blk" "virtio-net"];
    extraModulePackages = [];

    kernelParams = ["boot.shell_on_fail"];

    # Use the systemd-boot EFI boot loader.
    loader.grub = {
      enable = lib.mkDefault true;
      efiInstallAsRemovable = true;
      efiSupport = true;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFusXTBhXLpViUVKjfHRJnjVb6WZFrxYq2/0Kh7MKwN pro@yoni-firroloni.com"
  ];

  networking = {
    useDHCP = lib.mkDefault true;

    hostName = "dedistonks2"; # Define your hostname.
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
