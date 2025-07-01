# Colors
_RED="\e[1;31m"
_YELLOW="\e[1;33m"
_GREEN="\e[1;32m"
_BLUE="\e[1;34m"
_RESET="\e[0m"

is_docker_running() {
    # Check if Docker CLI is available
    if ! command -v docker >/dev/null 2>&1; then
        echo false
        return 1
    fi

    # Check if Docker daemon is accessible
    if docker info >/dev/null 2>&1; then
        echo true
        return 0
    fi

    # Fallbacks for various init systems

    if command -v systemctl >/dev/null 2>&1 && systemctl is-active --quiet docker; then
        echo true
        return 0
    fi

    if command -v rc-service >/dev/null 2>&1 && rc-service docker status 2>/dev/null | grep -q started; then
        echo true
        return 0
    fi

    if command -v sv >/dev/null 2>&1 && sv status docker 2>/dev/null | grep -q '^run'; then
        echo true
        return 0
    fi

    if command -v service >/dev/null 2>&1 && service docker status >/dev/null 2>&1; then
        echo true
        return 0
    fi

    echo false
    return 1
}

detect_firewall() {
    if command -v firewall-cmd >/dev/null 2>&1 && systemctl is-active --quiet firewalld; then
        echo "firewalld"
        return 0
    fi

    if command -v ufw >/dev/null 2>&1 && ufw status | grep -qE "Status: (active|inactive)"; then
        echo "ufw"
        return 0
    fi

    if command -v nft >/dev/null 2>&1 && nft list ruleset >/dev/null 2>&1; then
        echo "nftables"
        return 0
    fi

    if command -v iptables >/dev/null 2>&1 && iptables -L >/dev/null 2>&1; then
        echo "iptables"
        return 0
    fi

    echo "none"
    return 1
}

check_port_in_use() {
  local port_num=$1
  local proto=$2

  if ss -lntu | grep -E "\b$proto\b.*:$port_num\b" >/dev/null; then
    return 0
  elif command -v lsof &>/dev/null && lsof -i "$proto:$port_num" >/dev/null; then
    return 0
  fi

  return 1
}

is_root() {
    [ "$(id -u)" -eq 0 ] && echo true || echo false
}

get_script_path() {
  readlink -f "$0"
}

get_script_dir() {
  dirname "$(get_script_path)"
}

log() {
    local level="$1"; shift
    local color
    case "$level" in
        ERROR) color=$_RED ;;
        WARN)  color=$_YELLOW ;;
        INFO)  color=$_BLUE ;;
        OK)    color=$_GREEN ;;
        *)     color=$_RESET ;;
    esac
    echo -e "${color}${level}: $*${_RESET}"
}

abort() {
    local exit_code=1
    if [[ $1 =~ ^[0-9]+$ ]]; then
        exit_code=$1
        shift
    fi
    log ERROR "$@"
    exit $exit_code
}

warn() {
    log WARN "$@"
}

info() {
    log INFO "$@"
}

success() {
    log OK "$@"
}