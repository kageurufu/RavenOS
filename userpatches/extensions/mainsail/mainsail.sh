#!/bin/bash

enable_extension nginx
enable_extension mainsail-config

function pre_customize_image__install_mainsail() {
	display_alert "Extension $EXTENSION: Installing mainsail"

	run_host_command_logged curl -lsSLo "${SDCARD}/tmp/mainsail.zip" https://github.com/mainsail-crew/mainsail/releases/latest/download/mainsail.zip
	chroot_sdcard 'su raven -c "mkdir /home/raven/mainsail"'
	chroot_sdcard 'su raven -c "unzip /tmp/mainsail.zip -d /home/raven/mainsail"'
	run_host_command_logged rm "${SDCARD}/tmp/mainsail.zip"

	run_host_command_logged rsync -aHWXhR "$EXTENSION_DIR"/src/root/./ "${SDCARD}"/
	run_host_command_logged rsync -aHWXhR --chown 1000:1000 "$EXTENSION_DIR"/src/home/./ "${SDCARD}"/home/raven/
}

function post_customize_image__enable_mainsail() {
	if [[ "$KLIPPER_FRONTEND" == "mainsail" ]]; then
		chroot_sdcard ln -sf /etc/nginx/sites-available/mainsail /etc/nginx/sites-available/default
	fi
}
