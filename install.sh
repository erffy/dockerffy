#!/usr/bin/env bash

source ./utils.sh

readonly PORTS=(
  "53/tcp 53/udp 80/tcp 443/tcp 443/udp 3000/tcp" # AdGuard Home related ports
  "2000/tcp" # ConvertX related port
  "4000/tcp" # LibreSpeed related port
  "5432/tcp" # PostgresQL related port
  "6000/tcp 6433/tcp 6433/udp" # Nextcloud related ports
  "7000/tcp" # Pastebin related port
  "8000/tcp" # Slimserve related port
)

if [ "$(is_root)" != "true" ]; then
  abort "This script must be run as root."
fi

if [ "$(is_docker_running)" != "true" ]; then
  abort "Docker is not installed or running. Please install and start Docker before proceeding."
fi

mkdir -p /opt/{dockge,stacks}
cp -rf files/core/dockge /opt/dockge

cd /opt/dockge
docker compose up -d

cd $(get_script_dir)

cp -rf files/core/postgresql /opt/stacks
cp -rf files/apps/* /opt/stacks

info "Checking for ports already in use..."
for group in "${PORTS[@]}"; do
  for port in $group; do
    proto="${port##*/}"
    port_num="${port%%/*}"
    if check_port_in_use "$port_num" "$proto"; then
      warn "Port $port is already in use. You may need to stop the conflicting service or change the port configuration."
    fi
  done
done

if [ "$(detect_firewall)" != "none" ]; then
  info "Configuring firewall rules..."

  case "$(detect_firewall)" in
    firewalld)
      for group in "${PORTS[@]}"; do
        for port in $group; do
          firewall-cmd --permanent --add-port=$port
        done
      done
      firewall-cmd --reload
      ;;
    ufw)
      for group in "${PORTS[@]}"; do
        for port in $group; do
          proto="${port##*/}"
          port_num="${port%%/*}"
          ufw allow $port_num/$proto
        done
      done
      ufw reload
      ;;
    nftables)
      if ! nft list tables | grep -q 'inet filter'; then
        nft add table inet filter
      fi

      if ! nft list chain inet filter input >/dev/null 2>&1; then
        nft add chain inet filter input { type filter hook input priority 0 \; policy drop \; }
        nft add rule inet filter input ct state established,related accept
        nft add rule inet filter input ct state invalid drop
        nft add rule inet filter input iif lo accept
      fi

      for group in "${PORTS[@]}"; do
        for port in $group; do
          proto="${port##*/}"
          port_num="${port%%/*}"
          nft add rule inet filter input $proto dport $port_num accept 2>/dev/null || true
        done
      done
      ;;
    iptables)
      for group in "${PORTS[@]}"; do
        for port in $group; do
          proto="${port##*/}"
          port_num="${port%%/*}"
          iptables -C INPUT -p $proto --dport $port_num -j ACCEPT 2>/dev/null || \
            iptables -A INPUT -p $proto --dport $port_num -j ACCEPT
        done
      done
      ;;
    *)
      warn "Firewall detected but not supported."
      ;;
  esac

  success "Firewall rules applied."
else
  info "No active firewall detected, skipping firewall configuration."
fi

for path in /opt/stacks/*; do
  info "Running $path"

  cd $path

  if [ -f $path/.env.example ]; then
    mv -f .env.example .env
  fi

  docker compose up -d

  sleep 3
done

cd $(get_script_dir)

success "erffy/dockerfile is successfully installed and running"
