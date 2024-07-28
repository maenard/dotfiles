#npm
nrd() {
  npm run dev -- --hostname="$1" --port="$2"
}

pas() {
  php artisan serve
}

infosoft-staging() {
  ssh root@159.223.86.244
}

front-up() {
  # Update /etc/hosts file
  ~/./update_host.sh

  # Function to find an unused port
  find_unused_port() {
    local port
    if ! ss -tuln | grep -q ":6969"; then
      echo "6969"
      return
    fi
    while :; do
      port=$(shuf -i 1024-65535 -n 1)
      if ! ss -tuln | grep -q ":$port"; then
        echo "$port"
        return
      fi
    done
  }

  # Get an unused port, prioritizing 6969
  unused_port=$(find_unused_port)

  # Start the frontend
  npm run dev -- --hostname="maenard.local" --port="$unused_port"
}

generate-bonsai() {
  cbonsai --infinite --live --message="Hello World!"
}
