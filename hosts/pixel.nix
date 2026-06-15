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
      "tty"
      "shell"
      "rss"
    ];

    dev = [
      "git"
      "network"
      "ai"
    ];
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
      options = {
        environment.persistence = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = ''
            Persistence options. 
            For this host, we want them to be ignored.
          '';
        };
      };

      imports = [
        # include nixos-avf modules
        inputs.avf.nixosModules.avf
      ];

      config = {

        # Change default user
        avf.defaultUser = username;

        # platform
        nixpkgs.hostPlatform = "aarch64-linux";

        system.stateVersion = "26.05";

      };
    };
}
