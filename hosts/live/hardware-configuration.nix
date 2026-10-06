{
  lib,
  architecture,
  ...
}:
{
  # Root is already a tmpfs provided by the ISO module. The installer module overrides
  # the whole fileSystems option, so extra mounts need the same priority to be kept.
  fileSystems = lib.mkImageMediaOverride {
    "/home" = {
      device = "/dev/disk/by-label/live-persist";
      fsType = "ext4";
      options = [
        "relatime"
        "nofail"
      ];
    };
  };

  networking = {
    useDHCP = lib.mkDefault true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "${architecture}-linux";

}
