{
  targets = [
    "platypute"
  ];

  nixosConfiguration =
    { inputs, pkgs, ... }:
    {
      services.nginx = {
        enable = true;
        virtualHosts."yoni-firroloni.com" = {
          default = true;
          enableACME = true;
          forceSSL = true;
          root = "${inputs.website.packages.${pkgs.stdenv.system}.default}";
          serverAliases = [
            "vagahbond.com"
          ];
        };
      };
    };
}
