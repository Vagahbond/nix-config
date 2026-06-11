{
  name = "pixel";

  modules = {
    security = [
      "keyring"
      "secrets"
    ];
    editor = [
      "nvf"
    ];
    network = [
      "ssh"
    ];
    nix = [
      "nix"
      "remoteBuild"
    ];
    terminal = [
      "prompt"
      "shell"
      "rss"
    ];

    dev = [
      "git"
      "network"
      "ai"
    ];
    impermanence = { };
    locales = { };
    system = { };
    user = { };
  };

  configuration =
    {
      username,
      inputs,
      lib,
      config,
      ...
    }:

    {
      imports = [
        # include nixos-avf modules
        inputs.avf.nixosModules.avf
      ];

      # Change default user
      avf.defaultUser = username;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It's perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "26.05"; # Did you read the comment?

      nixpkgs.hostPlatform = "aarch64-linux";

      # On AVF, no tmpfs, no impermanence

      environment.persistence.${config.persistence.storageLocation}.enable = lib.mkForce false;

    };
}
