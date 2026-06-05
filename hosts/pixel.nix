{
  name = "pixel";

  modules = {
    dev = [
      "git"
      "network"
      "ai"
    ];
    editor = [
      "nvf"
    ];
    network = [
      "ssh"
    ];
    nix = [
      "nix"
    ];
    terminal = [
      "prompt"
      "shell"
      "rss"
    ];
    locales = { };
    system = { };
  };

  configuration = _: {
    # nixpkgs.hostPlatform = "aarch64-linux";
    system.stateVersion = "24.05";
  };
}
