import Battery from "./battery.ts";

const systemtray = await Service.import("systemtray");

const items = systemtray.bind("items").as((items) =>
  items.map((item) =>
    Widget.Button({
      className: "systemtray-item",
      child: Widget.Icon({ icon: item.bind("icon") }),
      on_primary_click: (_, event) => item.activate(event),
      on_secondary_click: (_, event) => item.openMenu(event),
      tooltip_markup: item.bind("tooltip_markup"),
    }),
  ),
);

export default Widget.Box({
  className: "system",
  vertical: true,
  vpack: "end",
  children: [
    Widget.Box({
      className: "systemtray",
      vertical: true,
      children: items,
    }),
    Battery,
  ],
});
