# install envoy proxy
wget -O- https://apt.envoyproxy.io/signing.key | sudo gpg --dearmor -o /etc/apt/keyrings/envoy-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/envoy-keyring.gpg] https://apt.envoyproxy.io focal main" | sudo tee /etc/apt/sources.list.d/envoy.list
sudo apt-get update
sudo apt-get install envoy
envoy --version

# run envoy
wget https://raw.githubusercontent.com/HoussemDellai/azure-network-course/refs/heads/main/250_proxy_envoy/envoy-proxy-transparent-connect.yml

sudo envoy -c envoy-proxy-transparent-connect.yml --log-level debug --log-path /var/log/envoy.log

