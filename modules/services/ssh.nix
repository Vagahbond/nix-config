{
  targets = [
    "platypute"
  ];

  nixosConfiguration =
    {
      username,
      config,
    pkgs,
      ...
    }:
    let 
      keys = import ../../secrets/sshKeys.nix {inherit username config pkgs;};
    in
    {
      users.users.${username}.openssh.authorizedKeys.keys = [
        keys."${config.networking.hostName}_access".pub
      ];

      services = {
        fail2ban.enable = true;
        openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = false;
          };
          banner = ''
              ,ggggggggggg,
            dP"""88""""""Y8, ,dPYb,               I8                                         I8
            Yb,  88      `8b IP'`Yb               I8                                         I8
             `"  88      ,8P I8  8I            88888888                                   88888888
                 88aaaad8P"  I8  8'               I8                                         I8
                 88"""""     I8 dP    ,gggg,gg    I8    gg     gg  gg,gggg,    gg      gg    I8     ,ggg,
                 88          I8dP    dP"  "Y8I    I8    I8     8I  I8P"  "Yb   I8      8I    I8    i8" "8i
                 88          I8P    i8'    ,8I   ,I8,   I8,   ,8I  I8'    ,8i  I8,    ,8I   ,I8,   I8, ,8I
                 88         ,d8b,_ ,d8,   ,d8b, ,d88b, ,d8b, ,d8I ,I8 _  ,d8' ,d8b,  ,d8b, ,d88b,  `YbadP'
                 88         8P'"Y88P"Y8888P"`Y888P""Y88P""Y88P"888PI8 YY88888P8P'"Y88P"`Y888P""Y88888P"Y888
                                                             ,d8I' I8
                                                           ,dP'8I  I8
                                                          ,8"  8I  I8
                                                          I8   8I  I8
                                                          `8, ,8I  I8
                                                           `Y8P"   I8

                    This is a private system. Unauthorized access is prohibited.
                    All actions will be logged.
          '';
        };
      };
    };
}
