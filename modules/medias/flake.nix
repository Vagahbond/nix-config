{
  description = "Internal flake for passing medias inputs";

  inputs = {
    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };

  outputs = {spicetify-nix, ...}: {
    spotify = {
      module = spicetify-nix.homeManagerModule;
      inherit (spicetify-nix) packages;
    };
  };
}
