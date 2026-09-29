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

      projectName = "my_super_project";
    in
    {

      packages = forAllSystems (pkgs: {
        default = pkgs.callPackage ./nix/package.nix { };
      });

      devShells = forAllSystems (pkgs: {
        default =
          let

            db = import ./nix/database.nix {
              inherit pkgs projectName;
            };
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
              echo "pginit init database"
              echo "pgstart start database"
              echo "pgseed seed database"
              echo "pgconfigure create db and user"
              echo "pgdump to dump db in database.sql"

              echo "\n"
              echo Now developping my ${projectName}!

            '';
          };
      });
    };
}
