

    (mkIf cfg.enable {
      environment = {
        systemPackages = with pkgs; [
          lazygit
          gh
        ];

      }
      // lib.optionalAttrs config.modules.impermanence.enable {
        persistence.${impermanence.storageLocation} =

          {
            users.${username} = {
              directories = [
                ".config/lazygit"
                ".config/gh"
              ];
            };
          };
      };

    })
      /*
        programs = {
          git = {
            enable = true;
            config = {
              user = {
                name = "Yoni FIRROLONI";
                email = "pro@yoni-firroloni.com";
              };
              init = {
                defaultBranch = "master";
              };
              url = {
                "https://github.com/" = {
                  insteadOf = [
                    "gh:"
                    "github:"
                  ];
                };
              };
            };
          };
        };
      */
