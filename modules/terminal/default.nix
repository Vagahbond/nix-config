{
  config,
  pkgs,
  ...
}: let
  user = import ../../username.nix;
in {
  home-manager.users.${user} = {
    xdg.configFile."foot/foot.ini".source = ./foot.ini;
  };

  environment.systemPackages = with pkgs; [
    foot

    thefuck
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        # "zsh-nix-shell"
      ];

      theme = "refined";
    };
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch";
      build = "sudo nixos-rebuild build";
    };
  };

  users.defaultUserShell = pkgs.zsh;
}
