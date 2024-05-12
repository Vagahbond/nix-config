{lib, ...}:
with lib; {
  options.modules.nix = {
    remoteBuild.enable = mkEnableOption "Remote building";
  };
}
