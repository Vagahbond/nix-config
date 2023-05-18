{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mtpfs
    jmtpfs
    go-mtpfs
    android-tools
    android-file-transfer
    android-backup-extractor

    qgis

    insomnia

    gcc
    rbenv
    nodejs
    nodePackages.npm
    rustc
    cargo
    dotnet-sdk_7
    gnumake
    cmake
    alejandra

    wget
    curlWithGnuTls

    git
    lazygit
    gh
  ];
}
