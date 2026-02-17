#!/bin/bash

cleanup() {
    echo "Stopping Psiphon..."
    kill $PSIPHON_PID 2>/dev/null
    gsettings set org.gnome.system.proxy mode 'none'
    echo "Network settings restored."
    exit
}

trap cleanup INT TERM

echo "Starting Psiphon..."

sudo psiphon > /dev/null 2>&1 &
PSIPHON_PID=$!

echo "Waiting for Psiphon proxy..."

until nc -z 127.0.0.1 8081; do
    sleep 1
done

COUNTRY=$(curl -s --proxy http://127.0.0.1:8081 https://ipinfo.io/country)

echo "Psiphon connected."
echo "Connected Country: $COUNTRY"
echo "Test page: https://tunneled.me/"

echo "Enabling system proxy..."

gsettings set org.gnome.system.proxy mode 'manual'
gsettings set org.gnome.system.proxy.http host '127.0.0.1'
gsettings set org.gnome.system.proxy.http port 8081
gsettings set org.gnome.system.proxy.https host '127.0.0.1'
gsettings set org.gnome.system.proxy.https port 8081
gsettings set org.gnome.system.proxy.socks host '127.0.0.1'
gsettings set org.gnome.system.proxy.socks port 1081

echo "Press Ctrl+C to stop Psiphon."

wait $PSIPHON_PID
cleanup
