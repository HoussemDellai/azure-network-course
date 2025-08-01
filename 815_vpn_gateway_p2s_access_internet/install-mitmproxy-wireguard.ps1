# install python
winget install -e --id Python.Python.3.13

# install with pip on Windows or Linux
pip install mitmproxy

# install with winget on Windows
# winget install -e --id mitmproxy.mitmproxy --accept-package-agreements --accept-source-agreements

# start mitmproxy and wireguard
mitmweb --listen-port 8080 --web-host 0.0.0.0 --web-port 8081 --set block_global=false --mode wireguard