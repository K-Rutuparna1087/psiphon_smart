
# Psiphon Linux Smart Launcher Setup

This guide shows how to install Psiphon on Linux and configure a **smart launcher script** that:

- Starts Psiphon automatically
- Waits until the tunnel is ready
- Enables system proxy automatically
- Restores original network settings when Psiphon stops (Ctrl+C)

---

## 1. Install wget (if not installed)

```bash
sudo apt update
sudo apt install wget -y
```
## One-Line Install (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/K-Rutuparna1087/psiphon_smart/main/install.sh |bash
```

After installation, start Psiphon using:
---
```bash
psiphon
```
---
OR
---

## 1. Install Psiphon Linux

```bash
cd ~/Downloads
wget https://raw.githubusercontent.com/SpherionOS/PsiphonLinux/main/plinstaller2
sudo sh plinstaller2
```

After installation, Psiphon can be started using:

```bash
sudo psiphon
```

---

## 2. Create Smart Launcher Script

Create the script:

```bash
nano ~/psiphon_smart.sh
```

Paste:

```bash
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

sudo /usr/bin/psiphon > /dev/null 2>&1 &
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
```

Make executable:

```bash
chmod +x ~/psiphon_smart.sh
```

---

## 3. Create Global Command (Optional)

Create launcher:

```bash
sudo nano /usr/local/bin/psiphon
```

Paste:

```bash
#!/bin/bash
/home/$USER/psiphon_smart.sh
```

Make executable:

```bash
sudo chmod +x /usr/local/bin/psiphon
```

Now Psiphon can be started using:

```bash
psiphon
```

---

## 4. Usage

Start Psiphon:

```bash
psiphon
```

Behavior:

- Automatically connects
- Enables system proxy
- Displays connected country
- Press **Ctrl+C** to stop
- Proxy settings automatically restored

---

## Notes

- Psiphon runs a local proxy at:
  - HTTP/HTTPS → `127.0.0.1:8081`
  - SOCKS → `127.0.0.1:1081`
- System proxy is enabled only after the tunnel becomes active.
- Network settings are automatically restored when the script exits.
