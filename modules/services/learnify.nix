{config, ...}: {
  age.secrets.learnify = {
    file = ../../secrets/learnify.age;
    mode = "440";
  };

  /*
  services.learnify = {
    enable = true;
    envFile = config.age.secrets.learnify.path;
  };
  */
}
