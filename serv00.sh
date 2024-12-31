#!/bin/bash

# 脚本用于自动化安装Python及相关环境 
wget -O install-Python.sh https://raw.githubusercontent.com/LSH160981/Linux-Dev-Inti/refs/heads/main/install-Python.sh && chmod +x install-Python.sh && ./install-Python.sh

# 创建项目目录serv00 
mkdir -p serv00 

cd serv00 

# 下载主程序文件main.py
wget https://raw.githubusercontent.com/239144498/Serv00-Auto-Register/refs/heads/main/main.py

# 下载依赖文件requirements.txt
wget https://raw.githubusercontent.com/239144498/Serv00-Auto-Register/refs/heads/main/requirements.txt

# 创建Python虚拟环境
python3 -m venv venv

# 激活虚拟环境
source venv/bin/activate

# 安装项目所需的Python依赖
pip install -r requirements.txt

curl -s ipv4.ip.sb

# 运行主程序
python3 main.py
