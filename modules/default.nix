{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./graphics
    ./browser
    ./desktop
    ./dev
    ./editor
    ./input
    ./locales
    ./medias
    ./network
    ./output
    ./productivity
    ./security
    ./social
    ./system
    ./terminal
    ./virtualisation
  ];
}
