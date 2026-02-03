#!/usr/bin/env bash
set -e

############################
# PacketSDK 自动安装脚本
# OS: Debian / Ubuntu
# GitHub 直链版
############################

APPKEY="mRnmIosJMOdRfldB"
WORKDIR="/root"
ZIP_NAME="packet_sdk.zip"

# GitHub 直链
DOWNLOAD_URL="https://github.com/LSH160981/airdrop/raw/refs/heads/main/packetSDK_Linux_1.0.6.zip"

log_banner() {
  echo
  echo "================================================="
  echo " PacketSDK 一键安装脚本 (GitHub 直链)"
  echo "================================================="
  echo
}

log_banner

echo "[Step 1/5] 更新系统 & 安装基础工具"
apt update -y
apt install -y wget curl ca-certificates

echo "[Step 2/5] 安装 unzip"
apt install -y unzip

echo "[Step 3/5] 下载并解压 SDK"
cd "${WORKDIR}"
rm -f "${ZIP_NAME}"
curl -fL -o "${ZIP_NAME}" "${DOWNLOAD_URL}"

# 检查文件是否为 zip
if ! file "${ZIP_NAME}" | grep -qi zip; then
    echo "❌ 下载失败：返回内容不是 ZIP 文件"
    file "${ZIP_NAME}"
    exit 1
fi

unzip -o "${ZIP_NAME}"

echo "[Step 4/5] 检测系统架构并选择 SDK"
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) SDK_ARCH="x86_64" ;;
  i386|i686) SDK_ARCH="i386" ;;
  aarch64) SDK_ARCH="aarch64" ;;
  armv7l) SDK_ARCH="armv7l" ;;
  armv6l) SDK_ARCH="armv6l" ;;
  armv5l) SDK_ARCH="armv5l" ;;
  mips*) SDK_ARCH="mips_24kc" ;;
  *)
    echo "Error: Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

SDK_PATH=$(find "${WORKDIR}" -type f -path "*/${SDK_ARCH}/packet_sdk" | head -n1)

if [ -z "${SDK_PATH}" ]; then
  echo "Error: packet_sdk binary not found for arch ${SDK_ARCH}"
  exit 1
fi

cd "$(dirname "${SDK_PATH}")"
chmod +x packet_sdk

echo "[Step 5/5] 启动 PacketSDK（后台运行）"
nohup ./packet_sdk -appkey="${APPKEY}" > packet_sdk.log 2>&1 &

echo
echo "---------------------------------------------"
echo " PacketSDK 安装 & 启动 完成"
echo " 检查进程: ps -ef | grep packet_sdk"
echo " 日志: $(pwd)/packet_sdk.log"
echo "---------------------------------------------"
