applet.wallpaperPlugin = 'org.kde.color'
applet.writeConfig("wallpaperPlugin", 'org.kde.color')
applet.writeConfig("rotation", "CCW")
applet.currentConfigGroup = ["Wallpaper", "org.kde.color", "General"]
applet.writeConfig("Color", "0,0,0")
applet.reloadConfig()

