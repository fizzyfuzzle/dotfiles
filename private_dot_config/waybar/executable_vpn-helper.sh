#!/bin/bash
active=$(nmcli -t -f TYPE,NAME con show --active | grep -E '^(vpn|wireguard):')

if [ -n "$active" ]; then
  name=$(echo "$active" | head -1 | cut -d: -f2)
  echo "{\"text\":\"VPN: $name\",\"alt\":\"connected\",\"class\":\"connected\"}"
else
  echo "{\"text\":\"VPN: disconnected\",\"alt\":\"disconnected\",\"class\":\"disconnected\"}"
fi
