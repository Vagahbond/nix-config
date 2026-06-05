{

  # different option depending on the system
  getHomeDir =
    username: config:
    if (builtins.hasAttr "users" config) then config.users.users.${username}.home else config.user.home;
}
