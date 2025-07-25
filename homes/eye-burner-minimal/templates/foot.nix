{
  colors,
  font,
  mkHex,
  mkFontName,
  ...
}: ''

  # -*- conf -*-

  # shell=$SHELL (if set, otherwise user's default shell from /etc/passwd)
  # term=foot (or xterm-256color if built with -Dterminfo=disabled)
  # login-shell=no

  # app-id=foot
  title=foot
  # locked-title=no

  font=${builtins.toString (font.name)}:size=12
  # font-bold=<bold variant of regular font>
  # font-italic=<italic variant of regular font>
  # font-bold-italic=<bold+italic variant of regular font>
  # font-size-adjustment=0
  # line-height=<font metrics>
  # letter-spacing=0
  # horizontal-letter-offset=0
  # vertical-letter-offset=0
  # underline-offset=<font metrics>
  # underline-thickness=<font underline thickness>
  # box-drawings-uses-font-glyphs=no
  # dpi-aware=false

  # initial-window-size-pixels=700x500  # Or,
  # initial-window-size-chars=<COLSxROWS>
  # initial-window-mode=windowed
  pad=10x10                             # optionally append 'center'
  # resize-delay-ms=100

  # notify=notify-send -a \$\{app-id} -i \$\{app-id} \$\{title} \$\{body}

  # bold-text-in-bright=no
  # word-delimiters=,│`|:"'()[]{}<>
  # selection-target=primary
  # workers=<number of logical CPUs>
  # utempter=/usr/lib/utempter/utempter

  [environment]
  # name=value

  [bell]
  # urgent=no
  # notify=no
  # command=
  # command-focused=no

  [scrollback]
  # lines=1000
  # multiplier=3.0
  # indicator-position=relative
  # indicator-format=""

  [url]
  # launch=xdg-open $\{url}
  # label-letters=sadfjklewcmpgh
  # osc8-underline=url-mode
  # protocols=http, https, ftp, ftps, file, gemini, gopher
  # uri-characters=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+="'()[]

  [cursor]
  # style=block
  # blink=no
  # beam-thickness=1.5
  # underline-thickness=<font underline thickness>

  [mouse]
  hide-when-typing=yes
  # alternate-scroll-mode=yes

  [colors]
  alpha=1
  background=${mkHex colors.background}
  foreground=${mkHex colors.text}
  cursor=${mkHex colors.base01} ${mkHex colors.base05}


  regular0=${mkHex colors.base02}  # black (Overlay)
  regular1=${mkHex colors.bad}     # red (Love)
  regular2=${mkHex colors.good}    # green (Pine)
  regular3=${mkHex colors.warning} # yellow (Gold)
  regular4=${mkHex colors.base0B}  # blue (Foam)
  regular5=${mkHex colors.base0A}  # magenta (Iris)
  regular6=${mkHex colors.base0C}  # cyan (Rose)
  regular7=${mkHex colors.text}    # white (Text)

  bright0=${mkHex colors.base02} # bright black (Overlay)
  bright1=${mkHex colors.bad} # bright red (Love)
  bright2=${mkHex colors.good} # bright green (Pine)
  bright3=${mkHex colors.warning} # bright yellow (Gold)
  bright4=${mkHex colors.base0B} # bright blue (Foam)
  bright5=${mkHex colors.base0A} # bright magenta (Iris)
  bright6=${mkHex colors.base0C} # bright cyan (Rose)
  bright7=${mkHex colors.text}   # bright white (Text)

  ## dimmed colors (see foot.ini(5) man page)
  # dim0=<not set>
  # ...
  # dim7=<not-set>

  ## The remaining 256-color palette
  # 16 = <256-color palette #16>
  # ...
  # 255 = <256-color palette #255>

  ## Misc colors
  # selection-foreground=<inverse foreground/background>
  # selection-background=<inverse foreground/background>
  # jump-labels=<regular0> <regular3>          # black-on-yellow
  # scrollback-indicator=<regular0> <bright4>  # black-on-bright-blue
  # search-box-no-match=<regular0> <regular1>  # black-on-red
  # search-box-match=<regular0> <regular3>     # black-on-yellow
  # urls=<regular3>

  [csd]
  # preferred=server
  # size=26
  # font=<primary font>
  # color=<foreground color>
  # hide-when-typing=no
  # border-width=0
  # border-color=<csd.color>
  # button-width=26
  # button-color=<background color>
  # button-minimize-color=<regular4>
  # button-maximize-color=<regular2>
  # button-close-color=<regular1>

  [key-bindings]
  # scrollback-up-page=Shift+Page_Up
  # scrollback-up-half-page=none
  # scrollback-up-line=none
  # scrollback-down-page=Shift+Page_Down
  # scrollback-down-half-page=none
  # scrollback-down-line=none
  # clipboard-copy=Control+Shift+c XF86Copy
  # clipboard-paste=Control+Shift+v XF86Paste
  # primary-paste=Shift+Insert
  # search-start=Control+Shift+r
  # font-increase=Control+plus Control+equal Control+KP_Add
  # font-decrease=Control+minus Control+KP_Subtract
  # font-reset=Control+0 Control+KP_0
  # spawn-terminal=Control+Shift+n
  # minimize=none
  # maximize=none
  # fullscreen=none
  # pipe-visible=[sh -c "xurls | fuzzel | xargs -r firefox"] none
  # pipe-scrollback=[sh -c "xurls | fuzzel | xargs -r firefox"] none
  # pipe-selected=[xargs -r firefox] none
  # show-urls-launch=Control+Shift+u
  # show-urls-copy=none
  # show-urls-persistent=none
  # prompt-prev=Control+Shift+z
  # prompt-next=Control+Shift+x
  # unicode-input=none
  # noop=none

  [search-bindings]
  # cancel=Control+g Control+c Escape
  # commit=Return
  # find-prev=Control+r
  # find-next=Control+s
  # cursor-left=Left Control+b
  # cursor-left-word=Control+Left Mod1+b
  # cursor-right=Right Control+f
  # cursor-right-word=Control+Right Mod1+f
  # cursor-home=Home Control+a
  # cursor-end=End Control+e
  # delete-prev=BackSpace
  # delete-prev-word=Mod1+BackSpace Control+BackSpace
  # delete-next=Delete
  # delete-next-word=Mod1+d Control+Delete
  # extend-to-word-boundary=Control+w
  # extend-to-next-whitespace=Control+Shift+w
  # clipboard-paste=Control+v Control+Shift+v Control+y XF86Paste
  # primary-paste=Shift+Insert
  # unicode-input=none

  [url-bindings]
  # cancel=Control+g Control+c Control+d Escape
  # toggle-url-visible=t

  [text-bindings]
  # \x03=Mod4+c  # Map Super+c -> Ctrl+c

  [mouse-bindings]
  # selection-override-modifiers=Shift
  # primary-paste=BTN_MIDDLE
  # select-begin=BTN_LEFT
  # select-begin-block=Control+BTN_LEFT
  # select-extend=BTN_RIGHT
  # select-extend-character-wise=Control+BTN_RIGHT
  # select-word=BTN_LEFT-2
  # select-word-whitespace=Control+BTN_LEFT-2
  # select-row=BTN_LEFT-3

  # vim: ft=dosini

''
