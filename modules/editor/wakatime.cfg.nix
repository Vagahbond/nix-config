{
  config,
  pkgs,
  username,
  ...
}: let
  token_path = config.age.secrets.wakatime-key.path;
in {
  config = {
    age.secrets.wakatime-key = {
      file = ../../secrets/wakatime-key.age;
      owner = username;
      mode = "700";
      group = "users";
    };

    system.activationScripts."wakatime-token" = ''
      secret=$(cat "${token_path}")
      configFile=/home/${username}/.wakatime.cfg
      ${pkgs.gnused}/bin/sed -i "s#@wakatime-api-key@#$secret#" "$configFile"
    '';
  };

  conf = ''
    [settings]
    debug = false
    hidefilenames = false
    ignore =
        COMMIT_EDITMSG$
        PULLREQ_EDITMSG$
        MERGE_MSG$
        TAG_EDITMSG$
    api_key=@wakatime-api-key@
  '';
}
