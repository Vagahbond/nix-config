{pkgs}: let
  website = pkgs.fetchFromGitHub {
    owner = "vagahbond";
    repo = "website";
    #     rev = "master";
    rev = "bf840b6ebb5d";
    sha256 = "sha256-uFfeI0qz6AR8ALS7VbiHByfAIs9Uy3wSqn2xcc4GyaA=";
  };
in {
  services.nginx = {
    enable = true;
    virtualHosts."yoni-firroloni.com" = {
      default = true;
      enableACME = true;
      forceSSL = true;
      root = "${website}/src";
      serverAliases = [
        "vagahbond.com"
      ];
    };
  };
}
