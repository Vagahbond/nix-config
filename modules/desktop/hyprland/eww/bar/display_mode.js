const { exec } = require("child_process");

const res = {
    mode: ""
}

exec("hyprctl monitors -j", (error, stdout, stderr) => {
    const focusedWorkspace = JSON.parse(stdout)[0].activeWorkspace.id;

    exec("hyprctl workspaces -j", (error, stdout, stderr) => {
        const nbWindows = JSON.parse(stdout)
            .find(w => w.id == focusedWorkspace)
            .windows

        if (nbWindows == 1) {
            res.mode = "fullscreen"
        } else {
            res.mode = "tiled"
        }

        console.log(JSON.stringify(res))
    })
})



