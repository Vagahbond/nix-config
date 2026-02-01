{
  name = "air";
  platform = "aarch64-darwin";

  configuration = _: {
    system.stateVersion = 6;
    #  users.users.${username}.hashedPassword =
    #       "$y$j9T$ofYLQRbiSsTERtHKAoi.J1$XW1xU541EsKvdMc3WNMEliNvUn4tVxKl99PbSB5gUg/";

    shell = {
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
  };
}
