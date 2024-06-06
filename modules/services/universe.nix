{
  pkgs,
  config,
  inputs,
  ...
}: {
  age.secrets.universe = {
    file = ../../secrets/universe.age;
    mode = "440";
  };

  services.universe = {
    enable = true;
    envFile = config.age.secrets.universe.path;
  };
}
