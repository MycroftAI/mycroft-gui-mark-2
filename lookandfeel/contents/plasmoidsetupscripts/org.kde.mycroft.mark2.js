applet.wallpaperPlugin = 'org.kde.color'
applet.writeConfig("wallpaperPlugin", 'org.kde.color')
applet.writeConfig("Rotation", "CCW")
applet.currentConfigGroup = ["Wallpaper", "org.kde.color", "General"]
applet.writeConfig("Color", "0,0,0")
applet.reloadConfig()

