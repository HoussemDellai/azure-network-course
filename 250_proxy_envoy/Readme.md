## Install Envoy

```sh
wget -O- https://apt.envoyproxy.io/signing.key | sudo gpg --dearmor -o /etc/apt/keyrings/envoy-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/envoy-keyring.gpg] https://apt.envoyproxy.io focal main" | sudo tee /etc/apt/sources.list.d/envoy.list
sudo apt-get update
sudo apt-get install envoy
envoy --version
```

## Start envoy proxy with config file

```sh
wget https://raw.githubusercontent.com/HoussemDellai/azure-network-course/refs/heads/main/250_proxy_envoy/envoy-proxy-transparent-connect.yml
sudo envoy -c envoy-proxy-transparent-connect.yml --log-level debug
```

>Debug log level allows to view detailed logs, including DNS resolution steps.

>By default Envoy system logs are sent to /dev/stderr. This location be overridden using --log-path.

>Envoy exposes metrics under the admin portal /stats endpoint: <admin_endpoint>/stats.

## Resources

Samples for Envoy configurations: https://github.com/envoyproxy/envoy/tree/72cbe0e8d6c398497d5d31e91114d05bda584e27/configs