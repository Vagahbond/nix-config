{
  description = "Internal flake for passing editors inputs";

  inputs = {
    neovim-flake = {
      url = "github:NotAShelf/neovim-flake/release/v0.4";
      # url = "/home/vagahbond/neovim-flake";
    };
  };

  outputs = {neovim-flake, ...}: {
    neovim = neovim-flake;
  };
}
