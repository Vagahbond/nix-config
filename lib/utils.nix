{
  ifSupported =
    config: pkg: if (builtins.elem config.hostPlatform.system pkg.meta.platforms) then [ pkg ] else [ ];
}
