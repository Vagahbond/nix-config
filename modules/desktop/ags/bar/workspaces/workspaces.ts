const hyprland = await Service.import("hyprland");

const activeId = hyprland.active.workspace.bind("name");

const workspaces = hyprland.bind("clients").as((w) => {
  const grouped = w.reduce((prev, curr) => {
    (prev[curr.workspace.name] = prev[curr.workspace.name] || []).push(curr);
    return prev;
  }, {});

  return Object.keys(grouped).map((k) => {
    const windows = grouped[k];

    const mbuttons = windows.map(({ workspace, initialClass }) =>
      Widget.Button({
        on_clicked: () =>
          hyprland.messageAsync(`dispatch workspace ${workspace.name}`),
        child: Widget.Icon({ icon: initialClass }),
      }),
    );

    return Widget.Box({
      class_names: activeId.as((i) => [
        i.toString() === k ? "focused" : "",
        "workspace",
      ]),
      vertical: true,
      children: [Widget.Label({ label: k.substring(0, 1) }), ...mbuttons],
      margin_bottom: 5,
    });
  });
});

const _workspaces = hyprland.bind("workspaces").as((ws) =>
  ws
    .filter(({ name }) => name.split(":")[0] != "special")
    .map(({ id, name }) =>
      Widget.Button({
        on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
        child: Widget.Label({
          label: id.toString(),
        }),
        margin_bottom: 5,
        class_names: activeId.as((i) => [
          i === name ? "focused" : "",
          "workspace",
        ]),
      }),
    ),
);

export default Widget.Box({
  vpack: "center",
  vertical: true,
  class_name: "workspaces",
  children: workspaces,
});
