{
  config,
  inputs,
  pkgs,
  storageLocation,
  username,
}: {
  environment = {
    persistence.${storageLocation} = {
      users.${username} = {
        directories = [
          ".hyprland"
        ];
      };
    };
  };

  systemPackages = with pkgs; [
    # Screenshoting
    hyprshot
    satty

    # QT
    qt6.qtwayland
    libsForQt5.qt5.qtwayland

    # Audio
    wireplumber

    # Clip
    cliphist
    wl-clipboard
  ];

  programs = {
    # Manage brightness
    light.enable = true;

    # Use Xorg old geezer apps on wayland
    xwayland.enable = true;

    # hypring my land
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };

  services = {
    dbus.enable = true;

    # Tell which session to use
    displayManager.defaultSession = "hyprland";
  };

  # Cache for quicker generations
  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  home-manager.users.${username} = {
    gtk = {
      enable = true;
      theme = config.theme.gtkTheme;

      iconTheme = config.theme.icons;

      font = config.theme.font.name;

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      gtk3.extraConfig = {
        gtk-xft-antialias = 1;
        gtk-application-prefer-dark-theme = 1;
      };

      qt = {
        enable = true;
        platformTheme.name = "gtk"; # just an override for QT_QPA_PLATFORMTHEME, takes “gtk”, “gnome”, “qtct” or “kde”
        style = config.theme.qtTheme;
      };

      # TODO: change and put scripts in nix-cooker templates themselves for further flex
      home.file = {
        ".config/hypr/hyprland.conf".text = config.thme.templates.hyprland;
        ".config/hypr/volume.sh".source = ./volume.sh;
        ".config/hypr/brightness.sh".source = ./brightness.sh;
        ".config/hypr/eww_widgets.sh".source = ./eww_widgets.sh;
      };
    };
  };
}
