helm upgrade --install prometheus prometheus-community/kube-prometheus-stack `
  --namespace monitoring `
  --set prometheus.prometheusSpec.additionalScrapeConfigs="[{\"job_name\":\"node\",\"static_configs\":[{\"targets\":[\"135.225.126.162:9100\"]}]}]"