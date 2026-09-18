{
  description = "Basic NodeJS + PostgreSQL dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-darwin" # Imagine nixing a mac
          ]
          (
            system:
            function (
              import nixpkgs {
                inherit system;
                config.allowUnfree = true;
                config.android_sdk.accept_license = true;
              }
            )
          );
    in
    {

      packages = forAllSystems (pkgs: {
        default = pkgs.callPackage ./nix/package.nix { };
      });

      devShells = forAllSystems (pkgs: {
        default =
          let
            db = import ./nix/database.nix { inherit pkgs; };
          in
          pkgs.mkShell {
            buildInputs = with db; [
              pkgs.nodejs
              pkgs.postgresql
              pgconfigure
              pgstart
              pginit
              pgstop
              pgseed
              pgdump
            ];

            LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";

            shellHook = ''
              # start db if not running
              if ! pgrep -f postgres > /dev/null; then
                pgstart
                echo "Started database.\n"
              else
                echo "Database already running.\n"
              fi

              # seed db if not seeded
              if ! psql -h localhost -p 5432 -d homepage -c "SELECT * FROM users;" > /dev/null; then
                pgseed
                echo "Seeded database.\n"
              else
                echo "Database already seeded.\n"
              fi

              echo "pginit init database"
              echo "pgstart start database"
              echo "pgseed seed database"
              echo "pgconfigure create db and user"
              echo "pgdump to dump db in database.sql"

              echo "\n"
              echo Now developping my homepage!

            '';
          };
      });
    };
}
