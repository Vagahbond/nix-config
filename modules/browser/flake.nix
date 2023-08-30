{
  description = "Internal flake for passing editors inputs";

  inputs = {
    schizofox = {
      url = "github:schizofox/schizofox";
    };
  };

  outputs = {schizofox, ...}: {
    schizofox = schizofox;
  };
}
