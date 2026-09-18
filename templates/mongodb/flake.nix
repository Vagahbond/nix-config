{
  description = "NodeJS + MongoDB";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfreePredicate =
            pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
              "mongodb-ce"
            ];
        };
        mongo_DataDir = ".nix-data/mongo";
        mongo_Port = "27017";

        mongo_start = pkgs.writeShellScriptBin "mongo_start" ''
          mkdir -p "$MONGO_DATA_DIR"

          if [ -f "$MONGO_PID_FILE" ] && kill -0 "$(cat "$MONGO_PID_FILE")" 2>/dev/null; then
            echo "mongo already running (pid $(cat "$MONGO_PID_FILE"))"
            return 0
          fi

          ${pkgs.mongodb-ce}/bin/mongod --dbpath "$MONGO_DATA_DIR" \
            --port ${mongo_Port} \
            --logpath "$MONGO_LOG_FILE" \
            --bind_ip 127.0.0.1 \
            > /dev/null 2>&1 &
          echo $! > "$MONGO_PID_FILE"
          echo "mongo started on port ${mongo_Port} (pid $(cat "$MONGO_PID_FILE")), logs: $MONGO_LOG_FILE"
        '';

        mongo_status = pkgs.writeShellScriptBin "mongo_status" ''
          if [ -f "$MONGO_PID_FILE" ] && kill -0 "$(cat "$MONGO_PID_FILE")" 2>/dev/null; then
            echo "mongo running (pid $(cat "$MONGO_PID_FILE"))"
          else
            echo "mongo not running"
          fi
        '';

        mongo_stop = pkgs.writeShellScriptBin "mongo_stop" ''
          if [ -f "$MONGO_PID_FILE" ] && kill -0 "$(cat "$MONGO_PID_FILE")" 2>/dev/null; then
            kill "$(cat "$MONGO_PID_FILE")"
            rm -f "$MONGO_PID_FILE"
            echo "mongo stopped"
          else
            echo "mongo not running"
          fi

        '';

      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nodejs_22
            pkgs.mongodb-ce
            pkgs.mongosh
            mongo_status
            mongo_start
            mongo_stop
          ];

          MONGO_DATA_DIR = mongo_DataDir;
          MONGO_LOG_FILE = "${mongo_DataDir}/mongo.log";
          MONGO_PID_FILE = "${mongo_DataDir}/mongo.pid";

          shellHook = ''

            echo "s1c-platform dev shell"
            echo "  node   $(node --version)"
            echo "  mongo $(mongod --version | head -1)"
            echo ""
            echo "commands: mongo_start | mongo_stop | mongo_status"

            mongo_start

            trap 'mongo_stop' EXIT
          '';
        };
      }
    );
}
