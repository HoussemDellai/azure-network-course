# install python
winget install -e --id Python.Python.3.13

# install mitmproxy using winget
winget install -e --id mitmproxy.mitmproxy

# install mitm using pip
# pip install mitmproxy


# start mitmproxy and wireguard
mitmweb --listen-port 8080 --web-host 0.0.0.0 --web-port 8081 --set block_global=false --mode wireguard -s ./python/io-write-flow-file.py
# mitmweb --listen-port 8080 --web-host 0.0.0.0 --web-port 8081 --set block_global=false --mode wireguard -w +flows.mitm

# to connect to wireguard you need:
# 1. download wireguard client
# 2. add profile
# 3. install MITMProxy certificate


# Connect to proxy using command line: https://learn.microsoft.com/en-us/windows/win32/winhttp/netsh-exe-commands#set-advproxy
netsh winhttp set advproxy setting-scope=machine settings-file=proxy-on.json

# view configured proxy
netsh winhttp show advproxy

# to disable proxy
netsh winhttp set advproxy setting-scope=machine settings-file=proxy-off.json

# Connect to VPN
rasdial "vnet-hub-swc-vpngw2-fw-std"

# Disconnect from VPN
rasdial "vnet-hub-swc-vpngw2-fw-std" /disconnect