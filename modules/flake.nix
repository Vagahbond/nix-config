{
  description = "Internal flake for passing all inputs";

  inputs = {
    medias.url = "./medias";
    editors.url = "./editor";
  };

  outputs = {
    medias,
    editors,
    ...
  }: {
    medias = medias;
    editors = editors;
  };
}
