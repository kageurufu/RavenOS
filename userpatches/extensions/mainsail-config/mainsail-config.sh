#!/bin/bash

function pre_customize_image__install_mainsail_config() {
	display_alert "Extension $EXTENSION: Installing mainsail_config"

	chroot_sdcard 'su raven -c "git clone https://github.com/mainsail-crew/mainsail-config /home/raven/mainsail-config"'
	run_host_command_logged rsync -aHWXhR --chown 1000:1000 "$EXTENSION_DIR"/src/home/./ "${SDCARD}"/home/raven/
}
