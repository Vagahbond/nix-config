(mkIf (cfg.enable && cfg.dbManager.enable) {

  environment.systemPackages = with pkgs; [
    lazysql
  ];
})
