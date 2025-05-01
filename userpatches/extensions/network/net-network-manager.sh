#
# Extension to manage network interfaces with NetworkManager
#
function extension_prepare_config__install_network_manager() {
	# Sanity check
	if [[ "${NETWORKING_STACK}" != "network-manager" ]]; then
		exit_with_error "Extension: ${EXTENSION}: requires NETWORKING_STACK='network-manager', currently set to '${NETWORKING_STACK}'"
	fi

	display_alert "Extension: ${EXTENSION}: Adding extra packages to image" "network-manager" "info"
	add_packages_to_image network-manager

	if [[ "${BUILD_DESKTOP}" == "yes" ]]; then
		display_alert "Extension: ${EXTENSION}: Adding extra packages for desktop to image" "network-manager-gnome network-manager-ssh network-manager-vpnc" "info"
		add_packages_to_image network-manager-gnome network-manager-ssh network-manager-vpnc
	fi

	if [[ "${DISTRIBUTION}" == "Ubuntu" ]]; then
		display_alert "Extension: ${EXTENSION}: Adding extra packages for Ubuntu to image" "network-manager-config-connectivity-ubuntu" "info"
		add_packages_to_image network-manager-config-connectivity-ubuntu
	fi
}

function pre_install_kernel_debs__configure_network_manager() {
	display_alert "Extension: ${EXTENSION}: Enabling Network-Manager" "" "info"

	# Enable resolved
	# Very likely not needed to enable manually since resolved is enabled by default
	# NetworkManager can use systemd-resolved as a DNS resolver and cache.
	# systemd-resolved will be used automatically if /etc/resolv.conf is a symlink to /run/systemd/resolve/stub-resolv.conf (source: https://wiki.archlinux.org/title/NetworkManager)
	chroot_sdcard systemctl enable systemd-resolved.service || display_alert "Failed to enable systemd-resolved.service" "" "wrn"

	# Most likely we don't need to wait for nm to get online
	chroot_sdcard systemctl disable NetworkManager-wait-online.service

	# Copy network config files into the appropriate folders
	display_alert "Configuring" "NetworkManager" "info"
	local network_manager_config_src_folder="${EXTENSION_DIR}/config-nm/NetworkManager/"
	local network_manager_config_dst_folder="${SDCARD}/etc/NetworkManager/conf.d/"

	run_host_command_logged cp -v "${network_manager_config_src_folder}"* "${network_manager_config_dst_folder}"
}
