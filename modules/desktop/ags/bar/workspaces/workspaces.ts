const hyprland = await Service.import("hyprland");

const activeId = hyprland.active.workspace.bind("name");

const workspaces = hyprland.bind("clients").as((w) => {
  const grouped = w.reduce((prev, curr) => {
    (prev[curr.workspace.name] = prev[curr.workspace.name] || []).push(curr);
    return prev;
  }, {});

  return Object.keys(grouped).map((k) => {
    const mbuttons = grouped[k].map(({ initialClass }) =>
      Widget.Box({
        className: "window",
        margin: 0,
        child: Widget.Icon({ icon: initialClass }),
      }),
    );

    return Widget.Button({
      class_names: activeId.as((i) => [
        i.toString() === k ? "focused" : "",
        "workspace",
      ]),
      on_clicked: () => hyprland.messageAsync(`dispatch workspace ${k}`),
      tooltipText: k,
      child: Widget.Box({
        vertical: true,
        hpack: "center",
        vpack: "center",
        className: "windows-container",

        children: [
          Widget.Label({
            label: k.substring(0, 1),
            hexpand: true,
            justification: "left",
          }),
          ...mbuttons,
        ],
      }),
    });
  });
});

export default Widget.Box({
  vpack: "center",
  vertical: true,
  class_name: "workspaces",
  children: workspaces,
});
