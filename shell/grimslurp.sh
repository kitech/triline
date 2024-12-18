#default same at workdir, *grim.png
geom=`slurp`
grim -g "$geom"
# slurp | grim -g - $(xdg-user-dir PICTURES)/$(date +'screenshot_%Y-%m-%d-%H%M%S.png')
