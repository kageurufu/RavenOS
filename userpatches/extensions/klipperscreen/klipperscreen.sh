#!/bin/bash

function post_family_config__klipperscreen_packages() {
    display_alert "Extension $EXTENSION: Adding packages for KlipperScreen"

    add_packages_to_image \
        xinit xinput x11-xserver-utils xserver-xorg-input-evdev xserver-xorg-input-libinput xserver-xorg-legacy xserver-xorg-video-fbdev \
        libgirepository1.0-dev gcc libcairo2-dev pkg-config python3-dev gir1.2-gtk-3.0 \
        librsvg2-common libopenjp2-7 libdbus-glib-1-dev autoconf python3-venv \
        fonts-nanum fonts-ipafont libmpv-dev
}

function pre_customize_image__install_klipperscreen() {
    display_alert "Extension $EXTENSION: Cloning KlipperScreen"
    chroot_sdcard 'su raven -c "git clone https://github.com/KlipperScreen/KlipperScreen /home/raven/KlipperScreen"'

    display_alert "Extension $EXTENSION: Creating KlipperScreen virtualenv"
    chroot_sdcard 'su raven -l -c "python3 -m venv /home/raven/.KlipperScreen-env"'
    chroot_sdcard "su raven -c '/home/raven/.KlipperScreen-env/bin/pip install -r /home/raven/KlipperScreen/scripts/KlipperScreen-requirements.txt'"

    run_host_command_logged rsync -aHWXhR "$EXTENSION_DIR"/src/root/./ "${SDCARD}"/
    run_host_command_logged rsync -aHWXhR --chown 1000:1000 "$EXTENSION_DIR"/src/home/./ "${SDCARD}"/home/raven/
}
