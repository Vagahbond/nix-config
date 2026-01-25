{
  targets = [
    "air"
    "framework"
  ];

  sharedConfiguration =
    { config, username, ... }:
    {

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
            sshKey = "${config.users.users.${username}.home}/.ssh/builder_access";
            systems = [
              "aarch64-darwin"
              "x86_64-linux"
            ];
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
    };

  nixosConfiguration =
    { config, ... }:
    {

      environment.persistence.${config.modules.impermanence.storageLocation} = {
        directories = [ "/root/.ssh" ];
      };
    };
}
