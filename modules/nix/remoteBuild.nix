
{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration =
    { pkgs, ... }:
    (mkIf cfg.remoteBuild.enable {

      nix = {
        settings.trusted-users = [
          "builder"
        ];

        ###############################################################
        # Setup distributed builds                                    #
        ###############################################################
        buildMachines = [
          {
            hostName = "vagahbond.com";
            sshUser = "builder";
            sshKey = config.age.secrets.builder_access.path;
            system = "x86_64-linux";
            protocol = "ssh";
            maxJobs = 4;
            speedFactor = 2;
            supportedFeatures = [
              "nixos-test"
              "benchmark"
              "big-parallel"
              "kvm"
            ];
          }
        ];

        distributedBuilds = true;
        extraOptions = ''
          builders-use-substitutes = true
        '';
      };
    }
      /*
        // lib.optionalAttrs persistenceCfg.enable {
          persistence.${config.modules.impermanence.storageLocation} = {
            directories = [ "/root/.ssh" ];
          };
        }
      */
    )
    (mkIf (helpers.isDarwin pkgs.stdenv.system) {
      nix = {
        linux-builder = {
          enable = true;
          ephemeral = true;
          maxJobs = 4;
          config = {
            virtualisation = {
              darwin-builder = {
                diskSize = 40 * 1024;
                memorySize = 8 * 1024;
              };
              cores = 6;
            };
          };
        };

        settings.trusted-users = [ "@admin" ];
      };

      system.stateVersion = 6;

    })
  ];
}
