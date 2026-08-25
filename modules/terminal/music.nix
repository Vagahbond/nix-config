[

  {
    targets = [
      "darwinConfiguration"
    ];
    conf =
      {
        pkgs,
        ...
      }:
      {
        environment.systemPackages = with pkgs; [
          # Play music
          cliamp

          # Manage playlists
          spotifycli
        ];
      };
  }
]
