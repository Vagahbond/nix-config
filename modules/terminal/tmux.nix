{pkgs}: {
  programs.tmux = {
    enable = true;
  };

  modules.terminal.shellAliases = {
    datalok = pkgs.writeShellScript "datalok_tmux.sh" (import ./datalok.sh.nix);
  };
}
