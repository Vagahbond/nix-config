{
  description = "Internal flake for passing all inputs";

  inputs = {
    medias.url = "./medias";
    editors.url = "./editor";
    desktop.url = "./desktop";
  };

  outputs = {
    medias,
    editors,
    desktop,
    ...
  }: {
    medias = medias;
    editors = editors;
    desktop = desktop;
  };
}
