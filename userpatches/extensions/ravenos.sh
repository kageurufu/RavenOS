#!/bin/bash

# RavenOS core extension
# This handles basic OS configuration, and sets up requirements for the other extensions

enable_extension klipper
enable_extension moonraker
enable_extension fluidd
enable_extension mainsail
enable_extension klipperscreen

function post_family_tweaks_bsp__remove_armbian_firstlogin() {
	display_alert "Extension: ${EXTENSION}: Removing armbian firstlogin"

	run_host_command_logged rm ${destination}/etc/profile.d/armbian-check-first-login-reboot.sh
	run_host_command_logged rm ${destination}/etc/profile.d/armbian-check-first-login.sh
	run_host_command_logged rm ${destination}/usr/lib/armbian/armbian-firstlogin
}

function post_family_tweaks__create_raven_user() {
	display_alert "Extension: ${EXTENSION}: Creating raven user"

	chroot_sdcard groupadd --gid 1000 raven
	chroot_sdcard adduser --quiet --disabled-password --uid 1000 --gid 1000 --shell /bin/bash --home /home/raven --gecos raven raven
	chroot_sdcard '(echo raven; echo raven) | passwd raven'

	chroot_sdcard 'su raven -c "cd /home/raven; mkdir -p printer_data/backup printer_data/certs printer_data/comms printer_data/config printer_data/database printer_data/gcodes printer_data/logs"'

	chroot_sdcard 'echo "nameserver 1.1.1.1" >> /etc/resolv.conf'
}
