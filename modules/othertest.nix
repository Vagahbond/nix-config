{
  pkgs,
  inputs,
  ...
}:
{
  targets = [ "air" ];

  darwinConfiguration = {
    config = {
      environment.systemPackages = with pkgs; [
        asciiquarium
      ];

    };
  };

  nixosConfiguration = { };
  sharedConfiguration = { };
}
