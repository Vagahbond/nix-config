{...}: let
  username = import ./username.nix;
in {
  users.users.${username} = {
    isNormalUser = true;
    # Scatter these groups in the conf depending on their purpose.
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    home = "/home/${username}";
    description = "My only user. Ain't no one else using my computer. Fuck you.";
    initialPassword = "${username}";
  };
}
