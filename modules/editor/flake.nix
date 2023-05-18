{
  description = "Internal flake for passing editors inputs";

  inputs = {
    neovim-flake = {
      url = "github:NotAShelf/neovim-flake";
    };
  };

  outputs = {neovim-flake, ...}: {
    neovim = neovim-flake;
  };
}
