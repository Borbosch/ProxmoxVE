#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts ORG
# Author: Borbosch
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: [SOURCE_URL e.g. https://github.com/example/app]

source /opt/scripts/install.func

APP="docker-ripper"

header_info "$APP"

msg_info "Updating system"
apt-get update -y
apt-get upgrade -y
msg_ok "System updated"

msg_info "Installing dependencies"
apt-get install -y \
  ca-certificates \
  curl \
  git \
  gnupg \
  lsb-release
msg_ok "Dependencies installed"

msg_info "Installing Docker"
curl -fsSL https://get.docker.com | bash
systemctl enable docker
msg_ok "Docker installed"

msg_info "Installing docker compose plugin"
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
msg_ok "Docker Compose installed"

msg_info "Deploying docker-ripper"
git clone https://github.com/rix1337/docker-ripper.git /opt/docker-ripper
cd /opt/docker-ripper
docker compose up -d
msg_ok "docker-ripper started"

msg_info "Cleaning up"
apt-get autoremove -y
apt-get clean
msg_ok "Cleanup completed"

motd_ssh
customize

msg_ok "Installation completed successfully 🎉"
