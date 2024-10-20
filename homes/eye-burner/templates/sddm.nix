{
  colors,
  font,
  radius,
  mkRGB,
  mkRGBA,
  mkHHex,
  mkHHexA,
  mkFontName,
  ...
}: ''
  ## Please see https://github.com/aczw/sddm-theme-corners/blob/main/CONFIG.md for
  ## more information about these options. Happy configuring!

  [General]

  # BgSource:     string. Path to an image, used as the wallpaper. Can be placed
  #               in the `backgrounds/` folder for convenience (see below!)
  #
  # FontFamily:   string. Name of the font family. You can find this with
  #               something like `fontconfig`, for example.
  #
  # FontSize:     number. This value is used for everything *except* the date/time.
  #
  # Padding:      number. How far away things should be from the edge of your screen.
  #
  # Radius:       number. Corner radius for UI. Set to 0 to disable rounded corners.
  #
  # Scale:        number. Adjusts the size of UI elements. Can be anything, but I
  #               would stick between 1 and 2 (e.g. 1.5).

  BgSource="backgrounds/background.jpg"
  FontFamily="${font.name}"
  FontSize=26
  Padding=50
  Radius=${builtins.toString radius}
  Scale=1

  # UserPictureEnabled:   boolean. By default the user picture is shown. Set to false
  #                       if you dont have/want a user picture, or you dont use the
  #                       user selection functionality.
  #
  # UserBorderWidth:      number. Width of the border around your picture. Set to
  #                       0 to remove.
  #
  # UserBorderColor:      color. Border color around your picture. Useless if border
  #                       width is 0.
  #
  # UserColor:            color. Background color of the default, blank avatar. Only
  #                       visible if you dont have your own picture.

  UserPictureEnabled=false
  UserBorderWidth=5
  UserBorderColor="${mkHHex colors.accent}"
  UserColor="${mkHHex colors.background}"

  # InputColor:           color. Background color of the input fields.
  #
  # InputTextColor:       color. Color of text you enter in the fields.
  #
  # InputBorderWidth:     number. Width of the border around the active field. Set
  #                       to 0 to remove.
  #
  # InputBorderColor:     color. Border color of active field. Useless if border
  #                       width is 0.
  #
  # UserPlaceholderText:  string. Placeholder text shown when user field is empty.
  #
  # PassPlaceholderText:  string. Placeholder text shown when user field is empty.
  #
  # HidePassword:         boolean. Whether to replace your entered password with dots.

  InputColor="${mkHHex colors.background}"
  InputTextColor="${mkHHex colors.text}"
  InputBorderWidth=2
  InputBorderColor="${mkHHex colors.accent}"
  UserPlaceholderText="user"
  PassPlaceholderText="password"
  HidePassword=true

  # LoginButtonTextColor:     color. Text color on the login button.
  #
  # LoginButtonText:          string. Text displayed on the button.
  #
  # LoginButtonColor:         color. Background color of the button.

  LoginButtonTextColor="${mkHHex colors.text}"
  LoginButtonText="Login"
  LoginButtonColor="${mkHHex colors.accent}"

  # PopupColor:               color. Background color of popup window.
  #
  # PopupActiveColor:         color. Color around the currently selected entry.
  #
  # PopupActiveTextColor:     color. Text color of the currently selected entry.
  #                           Mainly provided for potential contrast issues.

  PopupColor="${mkHHex colors.accent}"
  PopupActiveColor="${mkHHex colors.background}"
  PopupActiveTextColor="${mkHHex colors.text}"

  # SessionButtonColor:   color. Session button background color.
  #
  # SessionIconColor:     color. Color of the icon inside the session button.
  #
  # PowerButtonColor:     color. Power button background color.
  #
  # PowerIconColor:       color. Color of the icon inside the power button.

  SessionButtonColor="${mkHHex colors.background}"
  SessionIconColor="${mkHHex colors.base0B}"
  PowerButtonColor="${mkHHex colors.background}"
  PowerIconColor="${mkHHex colors.accent}"

  # DateTimeSpacing:      number. Spacing between the date and time.
  #
  # Date/TimeColor:       color. Date/time text color.
  #
  # Date/TimeSize:        number. Font size for the date/time.
  #
  # Date/TimeIsBold:      boolean. Whether date/time text should be bolded.
  #
  # Date/TimeOpacity:     number. Date/time text opacity.
  #
  # Date/TimeFormat:      string. Change the format of how the date and time is displayed.
  #                       Note that they use different formats.

  DateTimeSpacing=0

  DateColor="${mkHHex colors.base02}"
  DateSize=82
  DateIsBold=false
  DateOpacity=1.0
  DateFormat="dddd MMMM d yyyy"

  TimeColor="${mkHHex colors.accent}"
  TimeSize=96
  TimeIsBold=true
  TimeOpacity=1.0
  TimeFormat="hh:mm:ss AP"

''
