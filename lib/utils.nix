{
  ifSupported =
    config: pkg: if (builtins.elem config.nixpkgs.hostPlatform.system pkg.meta.platforms) then [ pkg ] else [ ];
}
