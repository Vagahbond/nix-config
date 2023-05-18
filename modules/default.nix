{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
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
    ./virtualization
  ];
}
