{nixpkgs, ...}: let
  inherit (nixpkgs.legacyPackages."x86_64-linux") callPackage stdenv mkdocs python310Packages;
  options-doc = callPackage ./doc-package.nix {};
in
  stdenv.mkDerivation {
    src = ./.;
    name = "docs";

    buildInput = [options-doc];

    nativeBuildInputs = [
      mkdocs
      python310Packages.mkdocs-material
      python310Packages.pygments
    ];

    buildPhase = ''
      mkdir docs
        ln -s ${options-doc} "./docs/index.md"
            # generate the site
            mkdocs build
    '';

    installPhase = ''
      mv site $out
    '';
  }
