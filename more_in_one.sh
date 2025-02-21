#!/bin/bash

# tnt3 
wget -O duokai.sh https://raw.githubusercontent.com/LSH160981/Titan-Network/main/duokai.sh && chmod +x duokai.sh && ./duokai.sh -c 5 -g 10

# tm
docker run -d --restart=always --name tm traffmonetizer/cli_v2 start accept --token ENqkbR98gyTlbgllQ0046PrB6mvDufFswDjDGyc58Eo=

# repocket
docker run -d --restart=always --name repocket -e RP_EMAIL=q2326426@gmail.com -e RP_API_KEY=ff00f832-de20-4fc7-9700-ff85e3fc109e repocket/repocket

# web
# docker run -d --name web -it --shm-size=512m -p 6901:6901 -e VNC_PW=Wsh96aGSa156s5 kasmweb/chrome:1.14.0

# earn.fm
docker run -d --restart=always -e EARNFM_TOKEN="f8978872-6d7c-4b84-9ae3-fb71383e5909" --name earnfm earnfm/earnfm-client:latest

# grass
docker run -d --name grassminer -e GRASS_USER=xl00546 -e GRASS_PASS="KR_%p_h2,cJB&%2" -e IS_COMMUNITY=false -e ADMIN_USER=admintian -e ADMIN_PASS=adminzhen -e PROXY_ENABLE=false -p 5001:8080 --restart always aron666/aron.grassminer

