(mkIf (cfg.enable && cfg.enableNetwork) {
  environment.systemPackages = with pkgs; [
    wget
    curlWithGnuTls
  ];
})
  (
    mkIf (cfg.enable && cfg.enableNetwork && graphics != null) {
      environment = {
        systemPackages = with pkgs; [
          slumber
        ];

      }
      // lib.optionalAttrs config.modules.impermanence.enable {
        persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".config/slumber/"
              ".local/share/slumber/"
            ];
          };
        };

      };
    }
  )
