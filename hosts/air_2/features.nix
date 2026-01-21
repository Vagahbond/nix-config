{
  self,
  pkgs,
  ...
}:
{
  /*
    config = {

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        sshs
        lazygit
        lazysql
        git
        nh
        starship
        self.packages.${stdenv.system}.nvf
      ];

      fonts.packages = [
        pkgs.nerd-fonts.departure-mono
      ];
      security.pam.services.sudo_local.touchIdAuth = true;
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  */
}
