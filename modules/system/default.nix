{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    neofetch
    btop
    htop

    ntfs3g
    zip
    unzip
    rar
    tree
  ];
}
