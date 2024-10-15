{
  colors,
  radius,
  mkRGB,
  mkRGBA,
  font,
  ...
}: ''
  * {
    font-family: ${font.name};
  }

  window {
    background-color: ${mkRGBA colors.background 0.5};
  }

  #match,
  #entry,
  #plugin,
  #main {
    border-radius: ${builtins.toString radius}px;

  }

  #match.activatable {
  }

  #match.activatable:not(:first-child) {
  }

  #match.activatable #match-title {
  }

  #match.activatable:hover {
  }

  #match-title, #match-desc {
  }

  #match.activatable:hover, #match.activatable:selected {
    border-radius: ${builtins.toString radius}px;
  }

  #match.activatable:selected + #match.activatable, #match.activatable:hover + #match.activatable {
  }

  #match.activatable:selected, #match.activatable:hover:selected {
  }

  #match, #plugin {
    border-radius: ${builtins.toString radius}px;
  }

  #entry {
    background-color: ${mkRGB colors.background};
    margin-bottom: 10px;
  }

  box#main {
  }

  row:first-child {
  }

''
