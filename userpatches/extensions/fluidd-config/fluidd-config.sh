#!/bin/bash

function pre_customize_image__install_mainsail_config() {
	display_alert "Extension $EXTENSION: Installing fluidd_config"

	chroot_sdcard 'su raven -c "
		git clone https://github.com/fluidd-core/fluidd-config /home/raven/fluidd-config
		ln -sf ~/fluidd-config/fluidd.cfg ~/printer_data/config/fluidd.cfg
	"'
	run_host_command_logged rsync -aHWXhR --chown 1000:1000 "$EXTENSION_DIR"/src/home/./ "${SDCARD}"/home/raven/

}
