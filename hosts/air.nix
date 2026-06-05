{
  name = "air";
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
      "remoteBuild"
    ];
    security = [
      "fingerprint"
      "secrets"
    ];
    terminal = [
      "prompt"
      "shell"
      "rss"
    ];
    system = { };
    user = { };
  };

  configuration = _: {
    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
