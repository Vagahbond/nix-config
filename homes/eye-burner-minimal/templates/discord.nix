{font, ...}: ''
    /**
   * @name system24 (everforest light)
   * @description a tui-like discord theme.
   * @author refact0r
   * @version 2.0.0
   * @invite nz87hXyvcy
   * @website https://github.com/refact0r/system24
   * @source https://github.com/refact0r/system24/blob/master/theme/system24.theme.css
   * @authorId 508863359777505290
   * @authorLink https://www.refact0r.dev
  */

  /* import theme modules */
  @import url('https://refact0r.github.io/system24/build/system24.css');

  body {
    /* font, change to \'\' for default discord font */
    --font: "${font.name}";

    /* change to \'\' for default discord font */
    --code-font: "${font.name}";

    /* change to \'\' for default discord font */
    font-weight: 300;
    /* text font weight. 300 is light, 400 is normal. DOES NOT AFFECT BOLD TEXT */
    letter-spacing: -0.05ch;
    /* decreases letter spacing for better readability. recommended on monospace fonts.*/

    /* sizes */
    --gap: 12px;
    /* spacing between panels */
    --divider-thickness: 4px;
    /* thickness of unread messages divider and highlighted message borders */
    --border-thickness: 2px;
    /* thickness of borders around main panels. DOES NOT AFFECT OTHER BORDERS */
    --border-hover-transition: 0.2s ease;
    /* transition for borders when hovered */

    /* animation/transition options */
    --animations: on;
    /* off: disable animations/transitions, on: enable animations/transitions */
    --list-item-transition: 0.2s ease;
    /* transition for list items */
    --dms-icon-svg-transition: 0.4s ease;
    /* transition for the dms icon */

    /* top bar options */
    --top-bar-height: var(--gap);
    /* height of the top bar (discord default is 36px, old discord style is 24px, var(--gap) recommended if button position is set to titlebar) */
    --top-bar-button-position: titlebar;
    /* off: default position, hide: hide buttons completely, serverlist: move inbox button to server list, titlebar: move inbox button to channel titlebar (will hide title) */
    --top-bar-title-position: off;
    /* off: default centered position, hide: hide title completely, left: left align title (like old discord) */
    --subtle-top-bar-title: off;
    /* off: default, on: hide the icon and use subtle text color (like old discord) */

    /* window controls */
    --custom-window-controls: off;
    /* off: default window controls, on: custom window controls */
    --window-control-size: 14px;
    /* size of custom window controls */

    /* dms button options */
    --custom-dms-icon: off;
    /* off: use default discord icon, hide: remove icon entirely, custom: use custom icon */
    --dms-icon-svg-url: url(\'\');
    /* icon svg url. MUST BE A SVG. */
    --dms-icon-svg-size: 90%;
    /* size of the svg (css mask-size property) */
    --dms-icon-color-before: var(--icon-secondary);
    /* normal icon color */
    --dms-icon-color-after: var(--white);
    /* icon color when button is hovered/selected */
    --custom-dms-background: off;
    /* off to disable, image to use a background image (must set url variable below), color to use a custom color/gradient */
    --dms-background-image-url: url(\'\');
    /* url of the background image */
    --dms-background-image-size: cover;
    /* size of the background image (css background-size property) */
    --dms-background-color: linear-gradient(70deg, var(--blue-2), var(--purple-2), var(--red-2));
    /* fixed color/gradient (css background property) */

    /* background image options */
    --background-image: off;
    /* off: no background image, on: enable background image (must set url variable below) */
    --background-image-url: url(\'\');
    /* url of the background image */

    /* transparency/blur options */
    /* NOTE: TO USE TRANSPARENCY/BLUR, YOU MUST HAVE TRANSPARENT BG COLORS. FOR EXAMPLE: --bg-4: hsla(220, 15%, 10%, 0.7); */
    --transparency-tweaks: off;
    /* off: no changes, on: remove some elements for better transparency */
    --remove-bg-layer: off;
    /* off: no changes, on: remove the base --bg-3 layer for use with window transparency (WILL OVERRIDE BACKGROUND IMAGE) */
    --panel-blur: off;
    /* off: no changes, on: blur the background of panels */
    --blur-amount: 12px;
    /* amount of blur */
    --bg-floating: var(--bg-3);
    /* set this to a more opaque color if floating panels look too transparent. only applies if panel blur is on  */

    /* other options */
    --small-user-panel: on;
    /* off: default user panel, on: smaller user panel like in old discord */

    /* unrounding options */
    --unrounding: on;
    /* off: default, on: remove rounded corners from panels */

    /* styling options */
    --custom-spotify-bar: on;
    /* off: default, on: custom text-like spotify progress bar */
    --ascii-titles: on;
    /* off: default, on: use ascii font for titles at the start of a channel */
    --ascii-loader: system24;
    /* off: default, system24: use system24 ascii loader, cats: use cats loader */

    /* panel labels */
    --panel-labels: on;
    /* off: default, on: add labels to panels */
    --label-color: var(--text-muted);
    /* color of labels */
    --label-font-weight: 500;
    /* font weight of labels */
  }

  /* color options */
  :root {
    --colors: on;
    /* off: discord default colors, on: everforest custom colors */

    /* text colors */
    --text-0: #fdf6e3;
    /* text on colored elements */
    --text-1: #5c6a72;
    /* other normally white text */
    --text-2: var(--text-1);
    /* headings and important text */
    --text-3: var(--text-1);
    /* normal text */
    --text-4: var(--text-1);
    /* icon buttons and channels */
    --text-5: var(--text-1);
    /* muted channels/chats and timestamps */

    /* background and bright colors */
    --bg-1: #efebd4;
    /* dark buttons when clicked */
    --bg-2: #fdf6e3;
    /* dark buttons */
    --bg-3: var(--bg-1);
    /* spacing, secondary elements */
    --bg-4: var(--bg-1);
    /* main background color */
    --hover: var(--bg-1);
    /* channels and buttons when hovered */
    --active: #e0dcc7;
    /* channels and buttons when clicked or selected */
    --active-2: #e0dcc7;
    /* extra state for transparent buttons */
    --message-hover: var(--hover);
    /* messages when hovered */

    /* accent colors */
    --accent-1: var(--green-1);
    /* links and other accent text */
    --accent-2: var(--green-2);
    /* small accent elements */
    --accent-3: var(--green-3);
    /* accent buttons */
    --accent-4: var(--green-4);
    /* accent buttons when hovered */
    --accent-5: var(--green-5);
    /* accent buttons when clicked */
    --accent-new: var(--red-2);
    /* stuff that's normally red like mute/deafen buttons */
    --mention: linear-gradient(to right, color-mix(in hsl, var(--accent-2), transparent 90%) 40%, transparent);
    /* background of messages that mention you */
    --mention-hover: linear-gradient(to right, color-mix(in hsl, var(--accent-2), transparent 95%) 40%, transparent);
    /* background of messages that mention you when hovered */
    --reply: linear-gradient(to right, color-mix(in hsl, var(--text-3), transparent 90%) 40%, transparent);
    /* background of messages that reply to you */
    --reply-hover: linear-gradient(to right, color-mix(in hsl, var(--text-3), transparent 95%) 40%, transparent);
    /* background of messages that reply to you when hovered */

    /* status indicator colors */
    --online: var(--green-2);
    /* change to #40a258 for default */
    --dnd: var(--red-2);
    /* change to #d83a41 for default */
    --idle: var(--yellow-2);
    /* change to #cc954c for default */
    --streaming: var(--purple-2);
    /* change to ##9147ff for default */
    --offline: var(--text-4);
    /* change to #82838b for default offline color */

    /* border colors */
    --border-light: var(--hover);
    /* general light border color */
    --border: var(--active);
    /* general normal border color */
    --border-hover: var(--accent-2);
    /* border color of panels when hovered */
    --button-border: #5c6a72;
    /* neutral border color of buttons */

    /* base colors */
    --red-1: #f85552;
    --red-2: var(--red-1);
    --red-3: var(--red-1);
    --red-4: #fbe3da;
    --red-5: #fbe3da;

    --green-1: #8da101;
    --green-2: var(--green-1);
    --green-3: var(--green-1);
    --green-4: #EAEDC8;
    --green-5: #EAEDC8;

    --blue-1: #3a94c5;
    --blue-2: var(--blue-1);
    --blue-3: var(--blue-1);
    --blue-4: #E9F0E9;
    --blue-5: #E9F0E9;

    --yellow-1: #ea9d34;
    --yellow-2: var(--yellow-1);
    --yellow-3: var(--yellow-1);
    --yellow-4: #FAEDCD;
    --yellow-5: #FAEDCD;

    --purple-1: #DF69BA;
    --purple-2: var(--purple-1);
    --purple-3: var(--purple-1);
    --purple-4: var(--red-5);
    --purple-5: var(--red-5);
  }


''
