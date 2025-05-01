#!/bin/bash

function post_family_config__moonraker_packages() {
    display_alert "Extension $EXTENSION: Adding packages for moonraker"
    add_packages_to_image \
        python3-pip python3-venv python3-dev \
        libopenjp2-7 \
        libsodium-dev \
        zlib1g-dev \
        libjpeg-dev \
        packagekit \
        curl \
        build-essential

    # Use iw on 24.04 and above
    if [[ $RELEASE == oracular || $RELEASE == plucky || $RELEASE == noble ]]; then
        add_packages_to_image iw
    else
        add_packages_to_image wireless-tools
    fi
}

function pre_customize_image__install_moonraker() {
    display_alert "Extension $EXTENSION: Cloning moonraker"
    chroot_sdcard 'su raven -c "git clone https://github.com/Arksine/moonraker /home/raven/moonraker"'

    display_alert "Extension $EXTENSION: Creating moonraker virtualenv"
    chroot_sdcard 'su raven -l -c "python3 -m venv /home/raven/moonraker-env"'
    chroot_sdcard "su raven -c 'cd /home/raven/moonraker; /home/raven/moonraker-env/bin/pip install -r scripts/moonraker-requirements.txt'"

    run_host_command_logged rsync -aHWXhR "$EXTENSION_DIR"/src/root/./ "${SDCARD}"/
    run_host_command_logged rsync -aHWXhR --chown 1000:1000 "$EXTENSION_DIR"/src/home/./ "${SDCARD}"/home/raven/
}
