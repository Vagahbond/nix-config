const battery = await Service.import("battery");

const class_name = Utils.merge(
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
  vertical: false,
  class_name,
  visible: battery.bind("available"),
  children: [
    Widget.Icon({
      icon,
      size: 25,
    }),
    Widget.Label({
      // Avoid having 100% cuz it makes different width
      label: battery.bind("percent").as((p) => `${p - 1}`),
      justification: "center",
    }),
  ],
});
