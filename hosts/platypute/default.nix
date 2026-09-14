# nh os switch --dry --build-host platypute --target-host platypute --hostname platypute . --show-trace
{
  name = "platypute";

  modules = {
    dev = [
      "git"
    ];
    editor = [
      "nvf"
    ];
    nix = [
      "nix"
      "remoteBuild"
    ];
    security = [
      "keyring"
      "secrets"
    ];
    services = [
      "uptime"
      "budget"
      "blog"
      "automation"
      "git"
      "photos"
      "builder"
      "files"
      "homepage"
      "audio-experiments"
      "invoices"
      "notes"
      "office"
      "postgres"
      "proxy"
      "ssh"
      "vaultwarden"
    ];
    network = [
      "ssh"
    ];
    terminal = [
      "prompt"
      "shell"
    ];
    virtualization = [
      "docker"
    ];
    impermanence = { };
    locales = { };
    system = { };
    user = { };
  };

  configuration =
    { username, pkgs, ... }:
    {
      imports = [
        ./hardware-configuration.nix
      ];

      system.stateVersion = "22.11";

      nixpkgs.hostPlatform = "x86_64-linux";

      # not enough goddamn disk space
      nix.settings = {
        auto-optimise-store = true;
      };

      users.users.${username}.hashedPassword =
        "$y$j9T$wNFGGvQeqSgVUXxTmOHX8.$wd5iVM5t01vuyNKR.bEcwBZIQ.t8qIxhPylDzhRYDC0";

      services.openssh.settings.Banner = toString (
        pkgs.writeText "banner.txt" ''
                __      ____  
           ___,o` `.-'''    ```-._.----. 
          '----..__,,_________,,-..____,'
                  (_\        (_\
          Bienvenue sur Platypute.
          Pour toute demande, contacter vagahbond@pm.me.

        ''
      );

    };
}
