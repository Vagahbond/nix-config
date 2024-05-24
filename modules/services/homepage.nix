{pkgs}: let
  website = pkgs.fetchFromGitHub {
    owner = "vagahbond";
    repo = "website";
    #     rev = "master";
    rev = "65ad1e3a8ab4";
    sha256 = "";
  };
in {
  services.nginx = {
    enable = true;
    virtualHosts."yoni-firroloni.com" = {
      enableACME = true;
      forceSSL = true;
      root = "${website}/src";
      serverAliases = [
        "vagahbond.com"
      ];
    };
  };
}
