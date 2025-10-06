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
sudo envoy -c envoy-proxy-transparent-connect.yml --log-level debug
```

>Debug log level allows to view detailed logs, including DNS resolution steps.

## Resources

Samples for Envoy configurations: https://github.com/envoyproxy/envoy/tree/72cbe0e8d6c398497d5d31e91114d05bda584e27/configs