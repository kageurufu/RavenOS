#!/bin/bash

# enable_extension nginx

function pre_customize_image__install_fluidd() {
    display_alert "Extension $EXTENSION: Installing fluidd"

    run_host_command_logged curl -lsSLo "${SDCARD}/tmp/fluidd.zip" https://github.com/fluidd-core/fluidd/releases/latest/download/fluidd.zip
    chroot_sdcard 'su raven -c "mkdir /home/raven/fluidd"'
    chroot_sdcard 'su raven -c "unzip /tmp/fluidd.zip -d /home/raven/fluidd"'
    run_host_command_logged rm "${SDCARD}/tmp/fluidd.zip"

    run_host_command_logged rsync -aHWXhR                   "$EXTENSION_DIR"/src/root/./  "${SDCARD}"/
    run_host_command_logged rsync -aHWXhR --chown 1000:1000 "$EXTENSION_DIR"/src/home/./  "${SDCARD}"/home/raven/
}
