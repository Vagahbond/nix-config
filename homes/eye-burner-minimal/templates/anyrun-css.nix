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
    background: transparent;
  }


  box.main {
    padding: 5px;
    margin: 10px;
    border-radius: ${builtins.toString radius}px;
    border: 2px solid ${colors.accent};
    background-color: ${mkRGB colors.background};
    box-shadow: 0 0 5px black;
  }


  text {
    min-height: 30px;
    padding: 5px;
    border-radius: ${builtins.toString radius}px;
  }


  .matches {
    background-color: rgba(0, 0, 0, 0);
    border-radius: ${builtins.toString radius}px;
  }

  box.plugin:first-child {
    margin-top: 5px;
  }

  box.plugin.info {
    min-width: 200px;
  }

  list.plugin {
    background-color: rgba(0, 0, 0, 0);
  }

  label.match.description {
    font-size: 10px;
  }

  label.plugin.info {
    font-size: 14px;
  }

  .match {
    background: transparent;
  }

  .match:selected {
    border-left: 4px solid ${mkRGB colors.accent};
    background: transparent;
    animation: fade 0.1s linear;
  }

  @keyframes fade {
    0% {
      opacity: 0;
    }

    100% {
      opacity: 1;
    }
  }
''
