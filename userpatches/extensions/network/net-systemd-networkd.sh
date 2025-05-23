#
# Extension to manage network interfaces with systemd-networkd
#

function extension_prepare_config__install_systemd_networkd() {
	# Sanity check
	if [[ "${NETWORKING_STACK}" != "systemd-networkd" ]]; then
		exit_with_error "Extension: ${EXTENSION}: requires NETWORKING_STACK='systemd-networkd', currently set to '${NETWORKING_STACK}'"
	fi
}

function pre_install_kernel_debs__configure_systemd_networkd() {
	display_alert "Extension: ${EXTENSION}: Enabling systemd-networkd" "" "info"

	# Enable networkd and resolved
	# Very likely not needed to enable manually since these services are enabled by default
	chroot_sdcard systemctl enable systemd-networkd.service || display_alert "Failed to enable systemd-networkd.service" "" "wrn"
	chroot_sdcard systemctl enable systemd-resolved.service || display_alert "Failed to enable systemd-resolved.service" "" "wrn"

	# Copy network config files into the appropriate folders
	display_alert "Extension: ${EXTENSION}: Configuring" "systemd-networkd" "info"

	local networkd_config_src_folder="${EXTENSION_DIR}/config-networkd/systemd/network/"
	local networkd_config_dst_folder="${SDCARD}/etc/systemd/network/"

	run_host_command_logged cp -v "${networkd_config_src_folder}"* "${networkd_config_dst_folder}"

	local networkd_conf_d_config_src_folder="${EXTENSION_DIR}/config-networkd/systemd/networkd.conf.d/"
	local networkd_conf_d_config_dst_folder="${SDCARD}/etc/systemd/networkd.conf.d/"

	mkdir -p "${networkd_conf_d_config_dst_folder}" # This doesn't exist by default, create it
	run_host_command_logged cp -v "${networkd_conf_d_config_src_folder}"* "${networkd_conf_d_config_dst_folder}"

}
