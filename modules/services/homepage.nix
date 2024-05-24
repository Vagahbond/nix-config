{pkgs}: let
  website = pkgs.fetchFromGitHub {
    owner = "vagahbond";
    repo = "website";
    #     rev = "master";
    rev = "5770e14f2767";
    sha256 = "sha256-0mBS+L9wRknLgv3OQ/Vo3fK1e1Uv7EolmsCnKr0znGA=";
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
