{
  name = "framework";
  platform = "x86_64-linux";

  configuration = {
    inputs,
    pkgs,
    ...
  }: {
    environment.systemPackages = [
      inputs.disko.packages.${pkgs.system}.default
    ];

    imports = [./hardware-configuration.nix];

    rice = "eye-burner-minimal";

    user.password = "$y$j9T$ofYLQRbiSsTERtHKAoi.J1$XW1xU541EsKvdMc3WNMEliNvUn4tVxKl99PbSB5gUg/";

    terminal = {
      shell = "zsh";
      shellAliases = {
        clone-config = "git clone https://github.com/vagahbond/nix-config";
        format-disks = "f(){ nix run github:nix-community/disko -- --mode disko $1}; f";
        mount-disk = "f(){ sudo mkdir -p /mnt/nix && sudo mount /dev/$1 /mnt}; f";
        install = "f() {nixos-install --flake .#$1}; f";
      };
    };
  };
}
