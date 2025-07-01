#!/usr/bin/env bash

source ./utils.sh

readonly PORTS=(
  "53/tcp 53/udp 80/tcp 443/tcp 443/udp 3000/tcp" # AdGuard Home related ports
  "2000/tcp" # ConvertX related port
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

containers=($(docker ps -aq))
for container in "${containers[@]}"; do
  info "Container $container is removing"
  docker container stop $container >/dev/null && docker container rm $container >/dev/null
done

sleep 3

docker network prune

rm -rf /opt/{dockge,stacks,containerd}

if [ "$(detect_firewall)" != "none" ]; then
  info "Removing firewall rules..."

  case "$(detect_firewall)" in
    firewalld)
      for group in "${PORTS[@]}"; do
        for port in $group; do
          firewall-cmd --permanent --remove-port=$port
        done
      done
      firewall-cmd --reload
      ;;
    ufw)
      for group in "${PORTS[@]}"; do
        for port in $group; do
          proto="${port##*/}"
          port_num="${port%%/*}"
          ufw delete allow $port_num/$proto || true
        done
      done
      ufw reload
      ;;
    nftables)
      for group in "${PORTS[@]}"; do
        for port in $group; do
          proto="${port##*/}"
          port_num="${port%%/*}"
          nft delete rule inet filter input $proto dport $port_num accept 2>/dev/null || true
        done
      done
      ;;
    iptables)
      for group in "${PORTS[@]}"; do
        for port in $group; do
          proto="${port##*/}"
          port_num="${port%%/*}"
          iptables -D INPUT -p $proto --dport $port_num -j ACCEPT 2>/dev/null || true
        done
      done
      ;;
    *)
      warn "Firewall detected but not supported."
      ;;
  esac

  success "Firewall rules cleaned up."
fi

success "erffy/dockerfile is successfully stopped and removed"