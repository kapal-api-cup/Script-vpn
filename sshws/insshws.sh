#!/bin/bash
# Proxy For Edukasi & Imclass
file_path="/etc/handeling"

# Cek apakah file ada
if [ ! -f "$file_path" ]; then
    # Jika file tidak ada, buat file dan isi dengan dua baris
    echo -e "UltrasonicVPN\nBlue" | sudo tee "$file_path" > /dev/null
    echo "File '$file_path' berhasil dibuat."
else
    # Jika file ada, cek apakah isinya kosong
    if [ ! -s "$file_path" ]; then
        # Jika file ada tetapi kosong, isi dengan dua baris
        echo -e "UltrasonicVPN\nBlue" | sudo tee "$file_path" > /dev/null
        echo "File '$file_path' kosong dan telah diisi."
    else
        # Jika file ada dan berisi data, tidak lakukan apapun
        echo "File '$file_path' sudah ada dan berisi data."
    fi
fi
# Link Hosting Kalian
sudo apt install python3

wget -O /usr/bin/ws "https://raw.githubusercontent.com/kapal-api-cup/Script-vpn/main/sshws/ws"
wget -O /usr/bin/tun.conf "https://raw.githubusercontent.com/kapal-api-cup/Script-vpn/main/sshws/tun.conf"
chmod +x /usr/bin/ws

# Installing Service
cat > /etc/systemd/system/ws.service << END
[Unit]
Description=Proxy Mod By Newbie Store 
Documentation=https://t.me/newbie_store24
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/ws -f /usr/bin/tun.conf
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable ws.service
systemctl start ws.service
systemctl restart ws.service