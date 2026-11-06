{

  modules = {
    dev = [
      "git"
      "network"
      "ai"
    ];
    editor = [
      "nvf"
    ];
    admin = [
      "keys"
    ];
    network = [
      "ssh"
    ];
    nix = [
      "nix"
      "remoteBuild"
    ];
    security = [
      "secrets"
    ];
    terminal = [
      "prompt"
      "shell"
    ];
    desktop = { };
    system = { };
    user = { };
    impermanence = { };
  };

  configuration =
    {
      pkgs,
      config,
      inputs,
      username,
      ...
    }:
    let
      updatePlatyputeScript = pkgs.writeScriptBin "upgrade-platypute" ''
        ssh -t platypute nh os switch "${config.environment.variables.NH_FLAKE}" --refresh;
      '';
    in
    {
      system.stateVersion = "26.11";
      nixpkgs.hostPlatform = "x86_64-linux";

      environment.systemPackages = [
        inputs.disko.packages.${pkgs.stdenv.hostPlatform.system}.default
        updatePlatyputeScript
      ];

      users.users.${username}.hashedPassword =  "$y$j9T$ofYLQRbiSsTERtHKAoi.J1$XW1xU541EsKvdMc3WNMEliNvUn4tVxKl99PbSB5gUg/";

boot = {
kernelModules = ["kvm-intel"];
  initrd = { 
availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  kernelModules = [  "dm-snapshot" "cryptd" ];

  luks.devices.cryptroot.device = "/dev/disk/by-uuid/19c1dd6c-6e10-4993-846b-5b69f2ceeacb";
};


  loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
  };

};
  fileSystems."/" =
    { device = "/dev/disk/by-label/NIXOS-ROOT";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2035-B553";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [
  { device = "/dev/disk/by-uuid/4be76cd9-ab0e-417c-a343-dbbf369df116"; }
 ];




    };
}
