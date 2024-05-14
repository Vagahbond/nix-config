{
  username,
  hostname,
  keys,
}: {
  users.users.${username}.openssh.authorizedKeys.keys = [
    keys."${hostname}_access".pub
  ];
  services = {
    fail2ban.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
      banner = ''
         ██████╗████████╗███████╗ ██████╗
        ██╔════╝╚══██╔══╝██╔════╝██╔═══██╗
        ██║  ███╗  ██║   █████╗  ██║   ██║
        ██║   ██║  ██║   ██╔══╝  ██║   ██║
        ╚██████╔╝  ██║   ██║     ╚██████╔╝
         ╚═════╝   ╚═╝   ╚═╝      ╚═════╝


        This is a private system. Unauthorized access is prohibited.
        All actions will be logged.
        Seriously get the fuck out.
      '';
    };
  };
}
