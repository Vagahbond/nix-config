{
  description = "Internal flake for passing all inputs";

  inputs = {
    medias.url = "./medias";
    editors.url = "./editor";
    desktop.url = "./desktop";
    browser.url = "./browser";
  };

  outputs = {
    medias,
    editors,
    desktop,
    browser,
    ...
  }: {
    inherit medias editors desktop browser;
  };
}
