[
  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
    ];
    conf =
      {
        config,
        username,
        ...
      }:
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
                # IDK how to make it build something else
                # "aarch64-darwin"
                "x86_64-linux"
              ];
              protocol = "ssh-ng";
              # Lowered from 4: platypute is memory-constrained (see hardware-configuration.nix
              # swap + disk-config.nix tmpfs root), and heavy single derivations (e.g. rust/napi
              # builds) stacking concurrently was causing OOM/thrashing mid-build.
              maxJobs = 1;
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
  }
  {
    targets = [ "nixosConfiguration" ];
    conf =
      { config, ... }:
      {
        environment.persistence.${config.persistence.storageLocation} = {
          directories = [ "/root/.ssh" ];
        };
      };
  }
]
