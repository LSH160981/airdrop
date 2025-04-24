#!/bin/bash

# Packet SDK 下载地址（如有新版可修改）
SDK_URL="https://storage-dl.packetsdk.com/d/packetsdk/linux/packet_sdk_linux-1.0.2.zip?sign=Y0zbf7BKTvhm2SDwnas-zrAch5BGbrkyjZCCHVZmsUE=:0"
APP_KEY="mRnmIosJMOdRfldB"  # TODO: 替换成你自己的 AppKey
INSTALL_DIR="/root/packet_sdk_linux-1.0.2"
SERVICE_NAME="packetsdk"

echo "🚀 开始安装 Packet SDK ..."

# 创建目录并下载
cd /root || exit 1
if [ -d "$INSTALL_DIR" ]; then
    echo "📁 已存在旧版本，先删除旧目录"
    rm -rf "$INSTALL_DIR"
fi

echo "⬇️ 下载 SDK 包..."
wget -O packet_sdk_linux.zip "$SDK_URL"

echo "📦 解压 SDK 包..."
unzip -o packet_sdk_linux.zip

# 检测架构
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        ARCH_DIR="x86_64"
        ;;
    i386|i686)
        ARCH_DIR="i386"
        ;;
    aarch64)
        ARCH_DIR="aarch64"
        ;;
    armv5l)
        ARCH_DIR="armv5l"
        ;;
    armv6*)
        ARCH_DIR="armv6"
        ;;
    armv7l)
        ARCH_DIR="armv7l"
        ;;
    *)
        echo "❌ 不支持的架构: $ARCH"
        exit 1
        ;;
esac

SDK_EXEC="$INSTALL_DIR/$ARCH_DIR/packet_sdk"
echo "🧠 检测到架构: $ARCH -> 使用: $ARCH_DIR"

echo "🔒 添加执行权限..."
chmod +x "$SDK_EXEC"

echo "🔁 如果已有旧服务，尝试停止它..."
systemctl stop "$SERVICE_NAME" 2>/dev/null
systemctl disable "$SERVICE_NAME" 2>/dev/null

echo "⚙️ 创建 systemd 启动服务..."
cat <<EOF > /etc/systemd/system/${SERVICE_NAME}.service
[Unit]
Description=Packet SDK Linux Client
After=network.target

[Service]
Type=simple
ExecStart=${SDK_EXEC} -appKey=${APP_KEY}
Restart=always
RestartSec=5
StandardOutput=append:${INSTALL_DIR}/${ARCH_DIR}/sdk.log
StandardError=append:${INSTALL_DIR}/${ARCH_DIR}/sdk.log

[Install]
WantedBy=multi-user.target
EOF

echo "🔄 重载 systemd 并启用服务..."
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable ${SERVICE_NAME}
systemctl start ${SERVICE_NAME}

echo "✅ 安装完成！你可以使用以下命令查看状态："
echo "   systemctl status ${SERVICE_NAME}"
echo "   tail -f ${INSTALL_DIR}/${ARCH_DIR}/sdk.log"
