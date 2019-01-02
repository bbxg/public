#!/bin/sh

#下载并安装ss
cd
apt-get install python-pip
pip install shadowsocks

#下载安装ss-libev

#添加作者ppa
cd
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:max-c-lv/shadowsocks-libev

#repo更新并安装
cd
sudo apt-get update
sudo apt-get install shadowsocks-libev

#下载安装simple-obfs
cd
sudo apt-get install --no-install-recommends build-essential autoconf libtool libssl-dev libpcre3-dev libev-dev asciidoc xmlto automake
git clone https://github.com/shadowsocks/simple-obfs.git
cd
cd simple-obfs
git submodule update --init --recursive
./autogen.sh
./configure && make
sudo make install
cd

#配置ss-libev基础的config和14000端口
cd
cd /etc/shadowsocks-libev
rm config.json

cat>config.json<<EOF
{
    "server":"165.227.27.95",
    "mode":"tcp_and_udp",
    "server_port":14000,
    "local_port":1080,
    "password":"100746",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "plugin":"obfs-server",
    "plugin_opts":"obfs=http"
}
EOF
systemctl start shadowsocks-libev.service
cd

#配置14000端口的simple-obfs
cd
cd simple-obfs/debian

rm config.json

cat>config.json<<EOF
{
    "server":"165.227.27.95",
    "server_port":14000,
    "local_port":1080,
    "password":"100746",
    "timeout":60,
    "method":"aes-256-cfb",
    "mode":"tcp_and_udp",
    "fast_open":true,
    "plugin":"obfs-local",
    "plugin_opts":"obfs=http;failover=165.227.27.95:14000"
}
EOF
ss-local -c /root/simple-obfs/debian/config.json --plugin obfs-local --plugin-opts "obfs=http;obfs-host=www.bing.com"
