let
  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFusXTBhXLpViUVKjfHRJnjVb6WZFrxYq2/0Kh7MKwN pro@yoni-firroloni.com";
  dedistonks = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAf1czoN5B1iRpQxeAKwgTPLFDkHyb3S118Ka3Djxo89 vagahbond@pm.me";
  platypute = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBaJF2F4uGyvYMnt0t1sgdUdxdU0+eEUzH//hGheZSPd vagahbond@nixos";

  # Master key is responsible for re-keying everything
  mk = framework;
in {
  # Misc secrets
  "wifi.age".publicKeys = [mk];
  "kubeconfig.age".publicKeys = [mk];
  "wakatime_config.age".publicKeys = [mk dedistonks platypute];

  "nextcloud_admin_pass.age".publicKeys = [mk dedistonks platypute];
  "nextcloud_client_account.age".publicKeys = [mk];

  # SSH Keys
  "ssh_config.age".publicKeys = [mk];

  "builder_access.age".publicKeys = [mk dedistonks];

  "platypute_access.age".publicKeys = [mk];

  "github_access.age".publicKeys = [mk];

  "dedistonks_access.age".publicKeys = [mk];
}
