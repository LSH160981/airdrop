# /bin/bash

sudo apt update

sudo apt install unzip snapd -y

sudo snap install multipass

# 开启 snapd 服务
sudo systemctl start snapd
sudo systemctl enable snapd

# 验证 snapd 和 multipass 是否安装成功
sudo snap --version
sudo multipass --version


# 下载安装包
wget https://pcdn.titannet.io/test4/bin/agent-linux.zip

# 创建安装目录
mkdir -p /opt/titanagent

# 解压安装包 到安装目录
unzip agent-linux.zip -d /opt/titanagent


cd /opt/titanagent

chmod +x agent

storage_path="$PWD/titan_network_4"

mkdir -p "$storage_path"

# 在后台运行 Agent 
# nohup ./agent --working-dir="$storage_path" --server-url=https://test4-api.titannet.io --key=Rr97CDXSesaD > agent.log 2>&1 &

./agent --working-dir="$storage_path" --server-url=https://test4-api.titannet.io --key=Rr97CDXSesaD



