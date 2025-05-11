#!/bin/bash

# 更新包索引并安装 cron（只适用于 Debian/Ubuntu）
if ! command -v cron >/dev/null 2>&1; then
  apt update && apt install -y cron
fi

# 确保 cron 服务已启用并运行
systemctl enable cron
systemctl start cron

# 添加定时任务
(crontab -l 2>/dev/null; \
echo "0 3 * * * /usr/bin/env bash -c 'command -v docker >/dev/null 2>&1 && docker ps -q | xargs -r docker restart'"; \
echo "@reboot /usr/bin/env bash -c 'sleep 60 && command -v docker >/dev/null 2>&1 && docker ps -q | xargs -r docker restart'") | crontab -
