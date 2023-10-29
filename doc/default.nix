{inputs, ...}: let
  inherit (inputs.nixpkgs.legacyPackages."x86_64-linux") callPackage stdenv python311Packages;
  options-doc = callPackage ./doc-package.nix {};
in
  stdenv.mkDerivation {
    src = ./.;
    name = "docs";

    buildInput = [options-doc];

    nativeBuildInputs = [
      python311Packages.mkdocs
      python311Packages.mkdocs-material
      python311Packages.pygments
      python311Packages.regex
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
