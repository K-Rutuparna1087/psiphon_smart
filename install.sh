#!/bin/bash

echo "Installing Psiphon Smart Launcher..."

sudo apt update
sudo apt install wget curl netcat-openbsd -y

wget -O ~/psiphon_smart.sh https://raw.githubusercontent.com/K-Rutuparna1087/psiphon_smart/main/psiphon_smart.sh
chmod +x ~/psiphon_smart.sh

echo '#!/bin/bash' | sudo tee /usr/local/bin/psiphon > /dev/null
echo 'bash ~/psiphon_smart.sh' | sudo tee -a /usr/local/bin/psiphon > /dev/null
sudo chmod +x /usr/local/bin/psiphon

echo "Installation complete. Run: psiphon"
