#!/bin/bash

function extension_prepare_config__select_klipper_variant() {
	declare -A variants=(
		[klipper]="https://github.com/Klipper3D/Klipper"
		[kalico]="https://github.com/KalicoCrew/kalico"
	)

	declare -g klipper_variant="${KLIPPER_VARIANT:-klipper}"
	declare -g klipper_git_repo="${variants[$klipper_variant]}"

	display_alert "Extension $EXTENSION: Using $klipper_variant"
}

function post_family_config__add_klipper_packages() {
	display_alert "Extension $EXTENSION: Adding packages for $klipper_variant"

	add_packages_to_image virtualenv python3 python3-pip python3-venv python3-dev libffi-dev build-essential
	# kconfig requirements
	add_packages_to_image libncurses-dev
	# hub-ctrl
	add_packages_to_image libusb-dev
	# AVR chip installation and building
	add_packages_to_image avrdude gcc-avr binutils-avr avr-libc
	# ARM chip installation and building
	add_packages_to_image stm32flash libnewlib-arm-none-eabi \
		gcc-arm-none-eabi binutils-arm-none-eabi libusb-1.0 pkg-config
}

function pre_customize_image__install_klipper() {
	display_alert "Extension $EXTENSION: Cloning $klipper_variant"
	chroot_sdcard "su $USERNAME -c 'git clone $klipper_git_repo /home/$USERNAME/klipper'"

	display_alert "Extension $EXTENSION: Cloning klipper virtualenv"
	chroot_sdcard "su $USERNAME -l -c 'python3 -m venv /home/$USERNAME/klippy-env'"
	chroot_sdcard "su $USERNAME -c '/home/$USERNAME/klippy-env/bin/pip install -r /home/$USERNAME/klipper/scripts/klippy-requirements.txt'"

	run_host_command_logged rsync -aHWXhR "$EXTENSION_DIR"/src/root/./ "${SDCARD}"/
}

function post_customize_image__enable_klipper() {
	display_alert "Extension $EXTENSION: Enabling $klipper_variant"

	chroot_sdcard systemctl enable klipper.service
}
