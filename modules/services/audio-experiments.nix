{
  targets = [
    "platypute"
  ];

  nixosConfiguration =
    { inputs, pkgs, ... }:
    {
      services.nginx = {
        enable = true;
        virtualHosts."audio-experiments.vagahbond.com" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            root = "${inputs.audio-experiments.packages.${pkgs.stdenv.system}.default}";
          };
        };
      };
    };
}
