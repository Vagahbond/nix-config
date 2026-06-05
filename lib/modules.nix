{
  inputs,
  lib,
  globalModules ? [ ],
  extraArgs,
}:
let

  fnNameToConfigType = {
    darwinSystem = "darwinConfiguration";
    nixosSystem = "nixosConfiguration";
    nixOnDroidConfiguration = "androidConfiguration";
  };

  configTypes = builtins.attrValues fnNameToConfigType;

  hostDir = toString ../hosts;

  modulesDir = toString ../modules;

  /**
      Gather hosts and modules into a system's configuration
  */
  getFileOrDir =
    fullPath:
    if (builtins.pathExists "${fullPath}/default.nix") then
      fullPath
    else
      (if (builtins.pathExists "${fullPath}.nix") then "${fullPath}.nix" else null);

  /**
      Import all modules from a configuration
  */
  importModuleFile =
    path: names:
    builtins.map (
      h:
      let
        fullPath = "${path}/${h}";
        file = getFileOrDir fullPath;
      in
      assert lib.assertMsg (
        file != null
      ) "You need to create either `${path}/${h}.nix` or `${path}/${h}/default.nix` !";
      import file
    ) names;

  /**
    Pick the right elements from a module.

    A module is now a list of `{ targets = [ ... ]; conf = ...; }` entries.
    Each entry's `conf` is kept only when the current `configType` is part of
    its `targets` list.
  */
  prepareModules =
    configType: modules:
    assert lib.assertMsg (builtins.elem configType configTypes) "Invalid config type ${configType}";
    assert lib.assertMsg (builtins.isList modules)
      "A module must be a list of `{ targets; conf; }` attribute sets; got: ${builtins.toJSON modules}";
    builtins.concatMap (
      entry:
      let
        hasShape = (builtins.hasAttr "targets" entry) && (builtins.hasAttr "conf" entry);
        validTargets = builtins.all (t: builtins.elem t configTypes) entry.targets;
      in
      assert lib.assertMsg hasShape "Each module entry must have `targets` and `conf` attributes";
      assert lib.assertMsg validTargets
        "Invalid target name; valid targets: ${lib.concatStringsSep ", " configTypes}";
      if (builtins.elem configType entry.targets) then [ entry.conf ] else [ ]
    ) modules;

  /**
    Import a single module
  */
  importModule =
    name: value:
    if (value == { }) then
      importModuleFile modulesDir [ name ]
    else
      importModuleFile "${modulesDir}/${name}" value;

  /**
    Import modules arborescencce
  */
  importModules =
    modules: lib.lists.flatten (lib.attrsets.attrValues (lib.attrsets.mapAttrs importModule modules));

  /**
    Gather hosts and modules into a single system's configuration
  */
  # prepareModules =
  #   modules: configType: lib.lists.flatten (builtins.map (prepareModuleArray configType) modules);

  /**
    Gather hosts and loaded modules into a single system's configuration
  */
  prepareSystem =
    systemLib: fnName: hostName:
    let
      host = import (getFileOrDir "${hostDir}/${hostName}");

      name =
        assert lib.assertMsg (builtins.hasAttr "name" host)
          "You need to specify a name (corresponds to hostname) in your host's config!";
        host.name;

      importedModules = importModules host.modules;

      preparedModules = prepareModules fnNameToConfigType.${fnName} (lib.lists.flatten importedModules);

      fn = systemLib.${fnName};

      baseModules =
        preparedModules
        ++ [
          host.configuration
        ]
        ++ globalModules;

    in
    fn (
      {
        modules = baseModules ++ [
          (_: { networking.hostName = name; })
        ];

      }
      // (
        # Special case for nix-on-droid
        if (fnName == "nixOnDroidConfiguration") then
          {

            modules = baseModules ++ [ (import ./androidCompat.nix) ];

            pkgs = import inputs.nixpkgs {
              system = "aarch64-linux";

              overlays = [
                inputs.nix-on-droid.overlays.default
                # add other overlays
              ];
            };

            extraSpecialArgs = extraArgs;

          }
        else
          {

            specialArgs = extraArgs;
          }
      )
    );

in
{
  mkDarwinHost = path: prepareSystem inputs.nix-darwin.lib "darwinSystem" path;

  mkNixosHost = path: prepareSystem inputs.nixpkgs.lib "nixosSystem" path;

  mkAndroidHost = path: prepareSystem inputs.nix-on-droid.lib "nixOnDroidConfiguration" path;

}
