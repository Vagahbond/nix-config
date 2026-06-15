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
      pkgs,
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

      config =
        let
          ttydCommand = config.systemd.services.ttyd.serviceConfig.ExecStart;

        in
        {

          fonts.packages = [ pkgs.nerd-fonts.bigblue-terminal ];

          # Change default user
          avf.defaultUser = username;

          # platform
          nixpkgs.hostPlatform = "aarch64-linux";

          system.stateVersion = "26.05";

          systemd.services.ttyd.serviceConfig.ExecStart = ttydCommand ++ ''
            \
                   -t fontSize=16 -t fontFamily="'BigBlueTerm Nerd Font Mono'"
          '';

        };
    };
}
