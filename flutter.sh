flutter_install_deploy_to_ios() {
    brew update
    brew install --HEAD usbmuxd
    brew link usbmuxd
    brew install --HEAD libimobiledevice
    brew install ideviceinstaller ios-deploy cocoapods
    pod setup
}

flutter_install_deploy_to_ios