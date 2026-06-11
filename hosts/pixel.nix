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

      environment.persistence.${config.persistence.storageLocation}.enable = lib.mkForce false;

      # platform
      nixpkgs.hostPlatform = "aarch64-linux";
      
      system.stateVersion = "26.05";


    };
}
