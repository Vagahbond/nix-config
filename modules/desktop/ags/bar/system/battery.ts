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
