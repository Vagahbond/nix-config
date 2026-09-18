{
  pkgs,
  buildNpmPackage,
}:
let
  db = import ./database.nix { inherit pkgs; };

in
buildNpmPackage {
  name = "simple project";
  src = ../.;
  # Does not matter as Payload is only ran durign build

  nativeBuildInputs = with db; [
    pkgs.postgresql
    pgconfigure
    pgstart
    pginit
    pgstop
    pgseed
  ];

  packageJSON = ../package.json;
  packageLock = ../package-lock.json;
  npmDepsHash = "sha256-PmxRZerXwW1aT2JpvrnaJRexd/qF9hgxnFunKHN1Q+Q=";
}
