let
  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFusXTBhXLpViUVKjfHRJnjVb6WZFrxYq2/0Kh7MKwN pro@yoni-firroloni.com";
  blade = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBqs31wVEbAxD2MNEy94YDbgkiLpLGdoChLAmqQQHDJA vagahbond@pm.me";
  dedistonks = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAf1czoN5B1iRpQxeAKwgTPLFDkHyb3S118Ka3Djxo89 vagahbond@pm.me";
in {
  # Wifi passwords
  "wifi.age".publicKeys = [framework blade];
  "kubeconfig.age".publicKeys = [framework blade];
  "dedistonks_access.age".publicKeys = [framework blade dedistonks];
  "ssh_config.age".publicKeys = [framework blade];
  "wakatime_config.age".publicKeys = [framework blade dedistonks];
  "nextcloud_admin_pass.age".publicKeys = [dedistonks];
  "nextcloud_client_account.age".publicKeys = [framework];
  # TODO: Remove dedistonks from that, mom I over-engineered again
  "builder_access.age".publicKeys = [dedistonks];
  "builder_access_private.age".publicKeys = [blade framework];
}
