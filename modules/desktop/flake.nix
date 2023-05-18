{
  description = "Internal flake for passing desktops inputs";

  inputs = {
    neovim-flake = {
      url = "github:NotAShelf/neovim-flake";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {neovim-flake, ...}: {
    neovim = neovim-flake;
  };
}
