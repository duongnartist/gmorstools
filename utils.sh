svgpdf() {
    "/Applications/Inkscape.app/Contents/Resources/bin/Inkscape" "$PWD"/$1 -A="$PWD"/$1.pdf --without-gui
}

svgpng() {
    "/Applications/Inkscape.app/Contents/Resources/bin/Inkscape" "$PWD"/$1 -e "$PWD"/$1.png --without-gui
}
