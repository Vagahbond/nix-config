{pkgs}: let
  website = pkgs.fetchFromGitHub {
    owner = "vagahbond";
    repo = "website";
    rev = "master";
    sha256 = "sha256-U8JEnN4VsEnhp8W3qd9mmUaNY/Lqwyw+IIyvi9aUUwE=";
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
