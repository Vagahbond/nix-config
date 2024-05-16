const battery = await Service.import("battery");

const className = Utils.merge(
  [battery.bind("percent"), battery.bind("charging")],
  (percent, charging) => {
    if (charging) return "battery charging";
    else if (percent < 15) return "battery critical";
    else if (percent < 30) return "battery danger";
    else return "battery";
  },
);

const icon = Utils.merge(
  [battery.bind("percent"), battery.bind("charging")],
  (percent, charging) => {
    let padding = "";
    if (percent < 100) {
      padding = "0";
    } else if (percent < 10) {
      padding = "00";
    }

    return `battery-${padding}${percent - (percent % 20)}${charging ? "-charging" : ""}`;
  },
);

export default Widget.Box({
  vertical: true,
  className,
  visible: battery.bind("available"),
  children: [
    Widget.Icon({
      className: "battery-icon",
      icon: battery.bind("icon_name"),
    }),
    Widget.Label({
      className: "battery-label",
      label: battery.bind("percent").as((p) => `${p}`),
      justification: "center",
    }),
  ],
});
