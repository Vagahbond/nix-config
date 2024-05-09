let
  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFusXTBhXLpViUVKjfHRJnjVb6WZFrxYq2/0Kh7MKwN pro@yoni-firroloni.com";
  blade = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBqs31wVEbAxD2MNEy94YDbgkiLpLGdoChLAmqQQHDJA vagahbond@pm.me";
  dedistonks = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAf1czoN5B1iRpQxeAKwgTPLFDkHyb3S118Ka3Djxo89 vagahbond@pm.me";
  dedistonks2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKghmvJ1HIT/4mMSZxqLZjVaYJhChG9C2PEKq6blGWWI vagahbond@dedistonks2";
  platypute = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBaJF2F4uGyvYMnt0t1sgdUdxdU0+eEUzH//hGheZSPd vagahbond@nixos";
in {
  # Wifi passwords
  "wifi.age".publicKeys = [framework blade];
  "kubeconfig.age".publicKeys = [framework blade];
  "ssh_config.age".publicKeys = [framework blade];
  "wakatime_config.age".publicKeys = [framework blade dedistonks dedistonks2 platypute];
  "nextcloud_admin_pass.age".publicKeys = [framework dedistonks dedistonks2 platypute];
  "nextcloud_client_account.age".publicKeys = [framework];
  "builder_access_private.age".publicKeys = [blade framework];
}
