{
  targets = [
  ];

  nixosConfiguration =
    {
      pkgs,
      config,
      username,
      ...
    }:
    {
      age.secrets = {
        kubeconfig = {
          file = ../../secrets/kubeconfig.age;
          path = "${config.users.users.${username}.home}/.kube/kubeconfig.yml";

          mode = "440";
          owner = "vagahbond";
          group = "users";
        };
      };

      environment.persistence.${config.persistence.storageLocation} = {
        users.${username} = {
          directories = [
            ".config/Lens"
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        kubectl
        lens
      ];
    };
}
