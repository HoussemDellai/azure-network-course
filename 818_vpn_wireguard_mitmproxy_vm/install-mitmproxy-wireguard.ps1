# install python
winget install -e --id Python.Python.3.13

# install pip
pip install mitmproxy

# start mitmproxy and wireguard
mitmweb --listen-port 8080 --web-host 0.0.0.0 --web-port 8081 --set block_global=false --mode wireguard -s io-write-flow-file.py
# mitmweb --listen-port 8080 --web-host 0.0.0.0 --web-port 8081 --set block_global=false --mode wireguard -w +flows.mitm

# to connect to wireguard you need:
# 1. download wireguard client
# 2. add profile
# 3. install MITMProxy certificate


# Connect to proxy using command line: https://learn.microsoft.com/en-us/windows/win32/winhttp/netsh-exe-commands#set-advproxy
netsh winhttp set advproxy setting-scope=machine settings-file=proxy.json

# view configured proxy
netsh winhttp show advproxy