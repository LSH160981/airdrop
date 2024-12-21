#!/bin/sh

# 默认变量
DEFAULT_CPU_CORE=1          # CPU核心数
DEFAULT_CPU_UTIL="10-20"    # CPU占用百分比范围
DEFAULT_MEM_UTIL=20         # 内存占用百分比
DEFAULT_SPEEDTEST_INTERVAL=120 # Speedtest间隔时间（秒）

# Docker镜像名称
DOCKER_IMAGE="fogforest/lookbusy"

# 安装活跃脚本
install_active_script() {
  echo "安装活跃脚本..."
  echo "CPU占用: $DEFAULT_CPU_UTIL%, 内存占用: $DEFAULT_MEM_UTIL%"

  # 安装Docker
  install_docker
  
  # 运行Docker容器
  docker run -itd --name=lookbusy --restart=always \
    -e TZ=Asia/Shanghai \
    -e CPU_UTIL="$DEFAULT_CPU_UTIL" \
    -e CPU_CORE="$DEFAULT_CPU_CORE" \
    -e MEM_UTIL="$DEFAULT_MEM_UTIL" \
    -e SPEEDTEST_INTERVAL="$DEFAULT_SPEEDTEST_INTERVAL" \
    "$DOCKER_IMAGE"
  
  echo "活跃脚本已安装"
}

# 安装Docker 
install_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "Docker未安装，正在安装..."
    # 这里需要添加实际安装Docker的命令
    apt-get update
    wget -qO- get.docker.com | bash
  else
    echo "Docker已安装"
  fi
}

# 调用安装活跃脚本
install_active_script
