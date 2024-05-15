import Time from "./time/time.ts";
import Workspaces from "./workspaces/workspaces.ts";
import System from "./system/system.ts";

export default (monitor: number) =>
  Widget.Window({
    monitor,
    name: `bar${monitor}`,
    anchor: ["right", "top", "bottom"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      margin: 10,
      vertical: true,
      start_widget: Time,
      center_widget: Workspaces,
      end_widget: System,
    }),
  });
