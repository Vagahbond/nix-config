{
  lib,
  runCommand,
  nixosOptionsDoc,
  ...
}: let
  # evaluate our options
  eval = lib.evalModules {
    # Not needed to add options for native nix lib
    modules = [
      ../modules/desktop/options.nix
      ../modules/graphics/options.nix
      ../modules/browser/options.nix
      ../modules/dev/options.nix
      ../modules/editor/options.nix
      ../modules/input/options.nix
      ../modules/locales/options.nix
      ../modules/medias/options.nix
      ../modules/network/options.nix
      ../modules/output/options.nix
      ../modules/productivity/options.nix
      ../modules/security/options.nix
      ../modules/social/options.nix
      ../modules/system/options.nix
      ../modules/terminal/options.nix
      ../modules/virtualisation/options.nix
      ../modules/gaming/options.nix
      ../modules/services/options.nix
    ];
  };
  # generate our docs
  optionsDoc = nixosOptionsDoc {
    options = eval.options.modules;
    transformOptions = o: o;
  };
in
  runCommand "index.md" {} ''
    cat ${optionsDoc.optionsCommonMark} >> $out
  ''
