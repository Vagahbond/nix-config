{pkgs}: let
  website = pkgs.fetchFromGitHub {
    owner = "vagahbond";
    repo = "website";
    #     rev = "master";
    rev = "1b055917c59a";
    sha256 = "sha256-1rzda5SZQ7YWVpFgRWf8M5xhzF20vd9wLz/fj6pThRI=";
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
