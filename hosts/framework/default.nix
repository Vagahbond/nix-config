{
  name = "air";
  platform = "aarch64-darwin";

  configuration = _: {
    imports = [ ./hardware-configuration.nix ];

    rice = "eye-burner-minimal";

    user.password = "$y$j9T$ofYLQRbiSsTERtHKAoi.J1$XW1xU541EsKvdMc3WNMEliNvUn4tVxKl99PbSB5gUg/";

    /*
      ssh = {
        enable = true;
        keys = with keys; [
          builder_access
          platypute_access
          github_access
          dedistonks_access
        ];
      };
    */

    /*
      terminal = {
        shellAliases = {
          rebuild-remote = ''
            f() {  \
                     NIX_SSHOPTS="-i ~/.ssh/$1_access " \
                     nixos-rebuild switch --sudo --ask-sudo-password \
                     --flake .#"$1" --target-host $1 \
                     --build-host $1 --show-trace \
                     }; f\
          '';
        };
      };
    */
  };
}
