{
  dev = [
    "db"
    "git"
    "network"
  ];
  editor = [
    "nvf"
    "office"
  ];
  network = [
    "ssh"
    "vpn"
    "wifi"
  ];
  nix = [
    "live"
    "nix"
    "remoteBuild"
  ];
  security = [
    "fingerprint"
    "keyring"
    "secrets"
  ];
  services = [
    "blog"
    "builder"
    "homepage"
    "invoices"
    "metrics"
    "mkReset"
    "nextcloud"
    "notes"
    "office"
    "pdf"
    "postgres"
    "proxy"
    "ssh"
    "vaultwarden"
  ];
  terminal = [
    "prompt"
    "shell"
  ];
  virtualization = [
    "docker"
    "kubernetes"
    "libvirt"
  ];
  impermanence = { };
  locales = { };
  system = { };
  user = { };
}
