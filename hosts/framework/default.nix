{base-options, ...} @ attrs: {
  system = "x86_64-linux";
  modules =
    base-options.modules
    ++ [
      ./hardware-configuration.nix
      ./features.nix
    ];

  specialArgs = base-options.specialArgs;
}
