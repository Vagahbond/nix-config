let
  recipients = import ./recipients.nix;
  inherit (recipients)
    framework
    pixel
    platypute
    air
    ;

  # Master key is responsible for re-keying everything
  mk = air;

  addMkToSet = builtins.mapAttrs (
    _: v: {
      publicKeys = if builtins.elem mk v.publicKeys then v.publicKeys else v.publicKeys ++ [ mk ];
    }
  );
in
addMkToSet {
  # Misc secrets
  "wifi.age".publicKeys = [
    air
    framework
  ];

  "nextcloud_admin_pass.age".publicKeys = [
    platypute
  ];

  "nextcloud_s3_secret.age".publicKeys = [
    platypute
  ];

  "ente_s3_secret.age".publicKeys = [
    platypute
  ];

  "ente_enc_key_secret.age".publicKeys = [
    platypute
  ];

  "ente_enc_hash_secret.age".publicKeys = [
    platypute
  ];

  "ente_jwt_secret.age".publicKeys = [
    platypute
  ];

  "ente_ott_secret.age".publicKeys = [
    platypute

  ];

  "nextcloud_mail_password.age".publicKeys = [
    platypute
  ];

  "nextcloud_client_account.age".publicKeys = [ ];

  "glance_secret_key.age".publicKeys = [
    platypute
  ];

  "glance_vagahbond_password.age".publicKeys = [
    platypute
  ];

  "grafana_secret_key.age".publicKeys = [
    platypute
  ];

  "invoiceshelf_env.age".publicKeys = [
    platypute
  ];

  "ghost_env.age".publicKeys = [
    platypute
  ];
  "joan_ghost_env.age".publicKeys = [
    platypute
  ];

  "universe.age".publicKeys = [
    platypute
  ];
  "learnify.age".publicKeys = [
    platypute
  ];

  # "silverbullet_env.age".publicKeys = [mk platypute];
  "affine_env.age".publicKeys = [
    platypute
  ];

  "affine_key.age".publicKeys = [
    platypute
  ];

  "affine_s3_secret.age".publicKeys = [
    platypute
  ];

  "redis_affine_pass_file.age".publicKeys = [
    platypute
  ];

  # SSH Keys
  "ssh_config.age".publicKeys = [
    pixel
    platypute
    air
    framework
  ];

  "builder_access.age".publicKeys = [
    pixel
    air
    framework
  ];

  "builder_2_access.age".publicKeys = [
    pixel
    platypute
    air
    framework
  ];

  "platypute_access.age".publicKeys = [
    pixel
    air
    framework
  ];

  "github_access.age".publicKeys = [
    platypute
    pixel
    air
    framework
  ];

  "aws_ro_access.age".publicKeys = [
    platypute
  ];

  "aws_ro_secret.age".publicKeys = [
    platypute
  ];

  "postgres_backup_s3_access_key.age".publicKeys = [
    platypute
  ];

  "postgres_backup_s3_secret_key.age".publicKeys = [
    platypute
  ];

  "vultr_api_key.age".publicKeys = [
    platypute
  ];

  "nextCloudMonitoringAccessToken.age".publicKeys = [
    platypute
  ];

  "wger_env.age".publicKeys = [
    platypute
  ];

  "mail_user_password.age".publicKeys = [
    platypute
  ];

  "mk_reset_pwd.age".publicKeys = [
    platypute
  ];

  "mk_reset_env.age".publicKeys = [
    platypute
  ];

  "tournament_env.age".publicKeys = [
    platypute
  ];

  "opencloud_env.age".publicKeys = [
    platypute
  ];

  "filestash_secret_key.age".publicKeys = [
    platypute
  ];
  "opencode_conf.age".publicKeys = [
  ];

  "firefly_app_key.age".publicKeys = [
    platypute
  ];

  "n8n_encryption_key.age".publicKeys = [
    platypute
  ];

  "n8n_runners_auth_token.age".publicKeys = [
    platypute
  ];

  "forgejo_admin_pass.age".publicKeys = [
    platypute
  ];

  "forgejo_runner_token.age".publicKeys = [
    platypute
  ];

}
