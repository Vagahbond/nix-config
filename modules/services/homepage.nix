{pkgs}: let
  website = pkgs.fetchFromGitHub {
    owner = "vagahbond";
    repo = "website";
    rev = "master";
    sha256 = "sha256-x1wyZFkiTRaR0bouHJxHPbCsKkU5sbxNIF9uo9M4lqE=";
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
