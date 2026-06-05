{
  inputs,
  lib,
  globalModules ? [ ],
  extraArgs,
}:
let

  configTypes = [
    "darwinConfiguration"
    "nixosConfiguration"
    "nixOnDroidConfiguration"
  ];

  fnNameToConfigType = {
    darwinSystem = "darwinConfiguration";
    nixosSystem = "nixosConfiguration";
    nixOnDroidConfiguration = "nixOnDroidConfiguration";
  };

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
    Pick the right elements from a module
  */
  prepareModuleArray =
    configType: module:
    let
      assertConfigType = lib.assertMsg (builtins.elem configType configTypes) "Invalid config type ${configType}";
    in
    [
      (if (builtins.hasAttr "sharedConfiguration" module) then module.sharedConfiguration else _: { })
      (
        if (assertConfigType && (builtins.hasAttr configType module)) then module.${configType} else _: { }
      )
    ];

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
  prepareModules =
    modules: configType: lib.lists.flatten (builtins.map (prepareModuleArray configType) modules);

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

      preparedModules = prepareModules importedModules fnNameToConfigType.${fnName};

      fn = systemLib.${fnName};
    in
    fn {
      modules =
        preparedModules
        ++ [
          host.configuration
          # set hostname
          (_: { networking.hostName = name; })
        ]
        ++ globalModules;
      specialArgs = extraArgs;
    };

in
{
  mkDarwinHost = path: prepareSystem inputs.nix-darwin.lib "darwinSystem" path;

  mkNixosHost = path: prepareSystem inputs.nixpkgs.lib "nixosSystem" path;

  mkAndroidHost = path: prepareSystem inputs.nix-on-droid.lib "nixOnDroidConfiguration" path;

}
