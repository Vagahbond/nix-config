{
  targets = [
    "platypute"
  ];

  nixosConfiguration = {inputs, ...}: {
    services.nginx = {
      enable = true;
      virtualHosts."yoni-firroloni.com" = {
        default = true;
        enableACME = true;
        forceSSL = true;
        root = "${inputs.website}/src";
        serverAliases = [
          "vagahbond.com"
        ];
      };
    };
  };
}
