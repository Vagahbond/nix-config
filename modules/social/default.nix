{
  pkgs,
  super,
  ...
}: let
  username = import ../../username.nix;

  catppuccin-mocha = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "discord";
    rev = "0f2c393b11dd8174002803835ef7640635100ca3";
    hash = "sha256-iUnLLAQVMXFLyoB3wgYqUTx5SafLkvtOXK6C8EHK/nI=";
  };
in {
  environment.systemPackages = with pkgs; [
    whatsapp-for-linux
    teams

    webcord-vencord # webcord with vencord extension installed
  ];

  home-manager.users.${username} = {
    xdg.configFile."WebCord/Themes/mocha" = {
      source = "${catppuccin-mocha}/themes/mocha.theme.css";
    };
  };
}
