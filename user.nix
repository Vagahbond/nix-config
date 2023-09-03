{
  inputs,
  config,
  ...
}: let
  username = import ./username.nix;
  # inherit (config.modules.impermanence) storageLocation;
in {
  /*
    imports = [
    inputs.impermanence.nixosModule
  ];
  */

  users.users.${username} = {
    isNormalUser = true;
    # Scatter these groups in the conf depending on their purpose.
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    home = "/home/${username}";
    description = "My only user. Ain't no one else using my computer. Fuck you.";
    initialPassword = "${username}";
  };

  /*
     environment.persistence.${storageLocation} = {
    users.${username} = {
      directories = [
        "Projects"
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
        ".local/share"
        ".pki"
      ];

      files = [
        ".gitconfig"
      ];
    };
  };
  */
}
