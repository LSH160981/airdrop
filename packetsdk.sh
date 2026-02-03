#!/usr/bin/env bash
set -e

############################
# PacketSDK 自动安装脚本
# OS: Debian / Ubuntu
############################

APPKEY="mRnmIosJMOdRfldB"
WORKDIR="/root"
ZIP_NAME="packet_sdk.zip"

DOWNLOAD_URL="https://wetransfer.com/download/local-bartender?id=eyJhcGlCYXNlIjoiL2FwaS92NCIsImRkUHJveHlCYXNlIjoiaHR0cHM6Ly9sb2NhbC1iYXJ0ZW5kZXItZGQtcHJveHkud2V0cmFuc2Zlci5uZXQvYXBpIiwidHJhbnNmZXJJZCI6ImI1ZjNiZmJkNDg2NTRiNzMzNDNhYjJiZjdhNzVmMzRlMjAyNjAyMDIwMTU2MTAiLCJzZWNyZXQiOiI1ZTMxNjgiLCJpbnRlbnQiOiJzaW5nbGVfZmlsZSIsImZpbGVJZHMiOiI1NzE0NjA1OGFlZDBjMTAwZjQyMDg1YjVkZTQ0Y2M5NjIwMjYwMjAyMDE1NjI4IiwicmVjaXBpZW50SWQiOiI2NDgxZGMyY2FlYjBmNDM1MTczZWZjNjIzMGRjZWIwYzIwMjYwMjAyMDE1NjI4IiwiYWNjZXNzVG9rZW4iOiJleUpoYkdjaU9pSlNVekkxTmlJc0luUjVjQ0k2SWtwWFZDSXNJbXRwWkNJNklteERNMEpGVUZST016QmpUbmw1Y1V4SWNUVmZTVjl0Tmw4M1RsQmlaRWxzYkV4b1RsWTNPVVZQTmpBaWZRLmV5SjBiMnRsYmw5MGVYQmxJam9pWVdOalpYTnpYM1J2YTJWdUlpd2ljMk52Y0dVaU9pSnZjR1Z1YVdRZ1pXMWhhV3dnY0hKdlptbHNaU0J2Wm1ac2FXNWxYMkZqWTJWemN5SXNJbUYxWkNJNkltRjFaRG92TDNSeVlXNXpabVZ5TFdGd2FTMXdjbTlrTG5kbGRISmhibk5tWlhJdklpd2laWGh3SWpveE56Y3dNVEV5TnpZM0xDSnBZWFFpT2pFM056QXhNRGt4Tmpjc0ltbHpjeUk2SW1oMGRIQnpPaTh2WVhWMGFDNTNaWFJ5WVc1elptVnlMbU52YlM4aUxDSnFkR2tpT2lJeFpEVXlNekU1WWpGaU5HVXhaamt5TjJFNE9EQTVaRFE0T1RFek5tRmhOR1UxWkRVNU1UUXlaakEyTW1Ka1pHVTFNakprTUdRNE9XWXdOamcyWldVMUlpd2ljM1ZpSWpvaVoyOXZaMnhsTFc5aGRYUm9Nbnd4TVRNM01Ua3hPVEl6TkRZek5URTJOakV3TXpnaWZRLkh4cl83VFdGdG9rMkFmMkhmU0R4MzR5bWp6WkhCWGo4enRXRE5ueXdsRkNqNFV6UGhqbFRRZzhxYjdGMFd4ZUsySVZGWDBMdDVka3B1Qk92Y2RVQ2RobzBGZUxKbEk5bW1EdGl5bk5DY3dLdTdGc3ozRUoxdG5mUE1IeDZoYWpXUy1odDNqcE5zTl9tSG9VYThaU0dHS082b2I5VmpoMnZoU2NiRVk4Tl9tMTFQSVg0cm5UUElDQ05oUFR4eVdadkQ2NXBya0N4RVh5UUN5dXJBUllfRGhURkt6cXd4YVltQk5nVWhWSUF2OGVMY2I5WnlVZnlGLW9sWFpNdGsxdkZRUVk3UEpzZ0hTWW9MSVo4SmlBVGhjZ0dnY3kyLV9PdkhmSGVNZlJRemI1NnBweUhzWlNNNFNCaTE5eVE2dVhBLUUtaW1NbTJUa0Vna285cVFZSThhdyIsImxvY2FsU3RvcmFnZUlkIjoiMWQ0NjEzMDktYzM4YS00OGJiLWEwODItYjk4ZGQzN2M5ZGZkIiwiY3VycmVudFRlYW1JZCI6IlQ1dW5iS0dUYldCRVo2RVFSUkxiIn0%3D"

echo "[1/5] 更新系统并安装基础工具"
apt update -y
apt install -y wget curl ca-certificates

echo "[2/5] 安装 unzip"
apt install -y unzip

echo "[3/5] 进入 /root 下载并解压"
cd ${WORKDIR}
rm -f ${ZIP_NAME}
curl -L -o ${ZIP_NAME} "${DOWNLOAD_URL}"
unzip -o ${ZIP_NAME}

echo "[4/5] 检测 CPU 架构"
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
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

SDK_PATH=$(find ${WORKDIR} -type f -path "*/${SDK_ARCH}/packet_sdk" | head -n1)

if [ -z "$SDK_PATH" ]; then
  echo "packet_sdk not found for architecture: ${SDK_ARCH}"
  exit 1
fi

cd "$(dirname "$SDK_PATH")"
chmod +x packet_sdk

echo "[5/5] 后台运行 PacketSDK"
nohup ./packet_sdk -appkey=${APPKEY} > packet_sdk.log 2>&1 &

echo "--------------------------------------"
echo "PacketSDK 已启动"
echo "进程：$(ps -ef | grep packet_sdk | grep -v grep | awk '{print $2}')"
echo "日志：$(pwd)/packet_sdk.log"
echo "--------------------------------------"
