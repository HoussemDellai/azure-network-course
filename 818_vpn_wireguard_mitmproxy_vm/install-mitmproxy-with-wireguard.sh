# install python
sudo apt update
sudo apt upgrade
sudo apt install python3 -y

sudo apt install python3-pip -y

# install pip
pip3 install mitmproxy

# start mitmproxy and wireguard
mitmweb --listen-port 8080 --web-host 0.0.0.0 --web-port 8081 --set block_global=false --mode wireguard -s io-write-flow-file.py