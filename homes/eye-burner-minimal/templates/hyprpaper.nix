{wallpaper, ...}: ''
  ipc = off
  splash = false

  preload=${wallpaper.package}/${wallpaper.name}

  
  wallpaper {
    monitor = 
    path = ${wallpaper.package}/${wallpaper.name} 
    fit_mode = cover
  }
''
