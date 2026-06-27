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
    ];
    security = [
      "keyring"
      "secrets"
    ];
    services = [
      "uptime"
      # "analytics"
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
      # "metrics"
      "tournament"
      "mkReset"
      "notes"
      "office"
      # "pdf"
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
    admin = [
      "j_sk8"
    ];
    impermanence = { };
    locales = { };
    system = { };
    user = { };
  };

  configuration =
    { username, ... }:
    {
      imports = [
        ./hardware-configuration.nix
      ];

      system.stateVersion = "22.11"; # Did you read the comment?

      nixpkgs.hostPlatform = "x86_64-linux";

      users.users.${username}.hashedPassword =
        "$y$j9T$wNFGGvQeqSgVUXxTmOHX8.$wd5iVM5t01vuyNKR.bEcwBZIQ.t8qIxhPylDzhRYDC0";

    };
}
