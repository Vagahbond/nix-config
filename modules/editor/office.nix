
    (mkIf cfg.office {

      environment = {
        systemPackages = with pkgs; [
          libreoffice
        ];
      }
      // lib.optionalAttrs config.modules.impermanence.enable {

        persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".config/libreoffice"
            ];
            files = [
            ];
          };
        };
      };
    })
