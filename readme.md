
# Monitoring framework for minetest

## Features

## Usage in mods

## Exporters

## Install

minetest.conf
```
secure.http_mods = monitoring
monitoring.prometheus_push_url = http://127.0.0.1:9091/metrics/job/some_job/instance/some_instance
```

```bash
sudo docker run -p 9091:9091 prom/pushgateway
```

## Example
