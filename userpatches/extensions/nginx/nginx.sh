#!/bin/bash

function post_family_config__add_packages() {
    display_alert "Extension $EXTENSION: Adding packages for nginx"

    add_packages_to_image nginx
}

function pre_customize_image__configure_nginx() {
    display_alert "Extension $EXTENSION: Configuring nginx"

    run_host_command_logged rsync -aHWXhR "$EXTENSION_DIR"/src/root/./ "${SDCARD}"/
}

function post_customize_image__enable_nginx() {
    display_alert "Extension $EXTENSION: Enabling nginx"

    chroot_sdcard systemctl enable nginx.service
}
