#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts ORG
# Author: Borbosch
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/rix1337/docker-ripper

# Import Functions and Setup
source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

# =============================================================================
# DEPENDENCIES
# =============================================================================
# Only install what's actually needed - base image already contains curl, sudo, mc

msg_info "Installing Dependencies"
$STD apt install -y \
  git
msg_ok "Installed Dependencies"

# =============================================================================
# RUNTIME SETUP
# =============================================================================

msg_info "Installing Docker Engine"
setup_docker
msg_ok "Docker installed"

# =============================================================================
# APPLICATION INSTALLATION
# =============================================================================

APP_NAME="docker-ripper"
APP_DIR="/opt/docker-ripper"

import_local_ip

msg_info "Cloning docker-ripper repository"
git clone https://github.com/rix1337/docker-ripper.git "$APP_DIR"
cd "$APP_DIR"
msg_ok "Repository cloned"

msg_info "Starting docker-ripper stack"
docker compose up -d
msg_ok "docker-ripper started"

# =============================================================================
# FINALIZATION
# =============================================================================

motd_ssh
customize
cleanup_lxc

msg_ok "Docker Ripper installation completed successfully 🎉"
echo -e "${INFO}${YW} Web UI available at:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${LOCAL_IP}:8080${CL}"
