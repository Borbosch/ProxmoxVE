#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2026 community-scripts ORG
# Author: Borbosch
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: [SOURCE_URL e.g. https://github.com/example/app]

# App Default Values
APP="docker-ripper"
var_appname="docker-ripper"
var_install="docker-ripper-install"
var_tags="media;docker"
var_cpu="2"
var_ram="1024"
var_disk="16"
var_os="debian"
var_version="13"
var_unprivileged="1"
var_nesting="1"
var_keyctl="1"
var_onboot="1"

# Optional Features exposed in Advanced mode
var_usb_passthrough="false"
var_sata_passthrough="false"

header_info "$APP"

description <<EOF
<b>$APP</b>

Docker Ripper is a containerized optical disc ripping solution.

Features:
- Automatic Docker installation
- docker-ripper stack deployment
- Optional USB or SATA optical drive passthrough

Default Ports:
- 8080 (Web UI)

Notes:
- USB passthrough is recommended.
- SATA passthrough requires exclusive device access.
EOF

# This function is called automatically by the framework
function app_setup() {
  if [[ "$var_usb_passthrough" == "true" ]]; then
    msg_info "USB passthrough enabled"
    lsusb
    read -rp "Enter USB VendorID:ProductID (e.g. 152d:0578): " USB_ID
    [[ -n "$USB_ID" ]] || msg_error "USB ID cannot be empty"
    USB_DEVICES+=("host=$USB_ID")
  fi

  if [[ "$var_sata_passthrough" == "true" ]]; then
    msg_info "SATA passthrough enabled"
    lsblk -o NAME,SIZE,MODEL,TYPE
    read -rp "Enter block device path (e.g. /dev/sr0): " SATA_DEV
    [[ -b "$SATA_DEV" ]] || msg_error "Invalid block device"
    MOUNT_POINTS+=("$SATA_DEV,mp=/dev/cdrom")
  fi
}

start
build_container
install_app
