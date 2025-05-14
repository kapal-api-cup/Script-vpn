#!/bin/bash
apt install rclone
printf "q\n" | rclone config
wget -qO /root/.config/rclone/rclone.conf "${REPO}install/rclone.conf"
cd
rm -rf wondershaper
wget -q ${REPO}install/limit.sh && chmod +x limit.sh && ./limit.sh
rm -f /root/set-br.sh
rm -f /root/limit.sh
