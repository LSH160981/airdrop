#!/bin/bash

# 这个脚本的主要功能是自动化设置两项任务：
#   1.每天定时重启所有 Docker 容器
#   2.在服务器启动时自动重启所有 Docker 容器

# 添加每天 0 点重启 docker 容器的计划任务
echo "0 0 * * * root /usr/bin/docker restart \$(docker ps -q)" > /etc/cron.d/docker_daily_restart
chmod 644 /etc/cron.d/docker_daily_restart

# 添加开机自启的 systemd 服务
cat <<EOF > /etc/systemd/system/docker-restart-onboot.service
[Unit]
Description=Restart all Docker containers at boot
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
ExecStart=/usr/bin/docker restart \$(docker ps -q)

[Install]
WantedBy=multi-user.target
EOF

# 启用并启动 systemd 服务
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable docker-restart-onboot.service
systemctl start docker-restart-onboot.service
