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
          serverAliases = [
            "vagahbond.com"
          ];
          locations."/" = {
            root = "${inputs.website.packages.${pkgs.stdenv.system}.default}";
            extraConfig = ''
              if ($request_uri ~ ^/(.*)\.html(\?|$)) {
                return 302 /$1;
              }
              try_files $uri $uri.html $uri/ =404;
            '';
          };
        };
      };
    };
}
