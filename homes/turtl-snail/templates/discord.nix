{font, ...}: ''

  /**
  * @name Rosé Pine
  * @author blueb
  * @authorId 403390454273409028
  * @version 3.0.9
  * @description All natural pine, faux fur and a bit of soho vibes for the classy minimalist.
  * @source https://github.com/rose-pine/discord
  * @updateUrl https://github.com/rose-pine/discord/blob/rose-pine.theme.css
  */

  * {
    font-family: "${font.name}" !important;
  }

  @import url('https://fonts.googleapis.com/css2?family=Fira+Code:wght@300..700&display=swap');
  :root {
  --Chat-Font-Used: 'Fira Code', monospace ;
  --Chat-Font-Size: 14px;

      --font-primary: var(--Chat-Font-Used);
      --font-display: var(--Chat-Font-Used);
      --font-code: var(--Chat-Font-Used);
  }

  .theme-dark {
      --background-primary: #26233a;
      --background-secondary: #1f1d2e;
      --background-secondary-alt: #26233a;
      --channeltextarea-background: #2c2842;
      --background-tertiary: #191724;
      --background-accent: #ebbcba;
      --text-normal: #dad7fd;
      --text-spotify: #9ccfd8;
      --text-muted: #4f4c58;
      --text-link: #31748f;
      --background-floating: #1f1d2e;
      --header-primary: #e0def4;
      --header-secondary: #9ccfd8;
      --header-spotify: #9ccfd8;
      --interactive-normal: #e0def4;
      --interactive-hover: #c4a7e7;
      --interactive-active: #e0def4;
      --ping: #eb6f92;
      --background-modifier-selected: #26233ab4;
      --scrollbar-thin-thumb: #191724;
      --scrollbar-thin-track: transparent;
      --scrollbar-auto-thumb: #191724;
      --scrollbar-auto-track: transparent;
  }

  .theme-light {
      --background-primary: #faf4ed;
      --background-secondary: #fffaf3;
      --background-secondary-alt: #f2e9de;
      --channeltextarea-background: #f2e9de;
      --background-tertiary: #f2e9de;
      --background-accent: #d7827e;
      --text-normal: #575279;
      --text-spotify: #575279;
      --text-muted: #6e6a86;
      --text-link: #286983;
      --background-floating: #f2e9de;
      --header-primary: #575279;
      --header-secondary: #575279;
      --header-spotify: #56949f;
      --interactive-normal: #575279;
      --interactive-hover: #6e6a86;
      --interactive-active: #575279;
  }
''
