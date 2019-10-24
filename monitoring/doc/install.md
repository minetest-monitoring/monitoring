## Install

Either install the grafana/prometheus stack yourself (native or via [docker](./docker.md))
or use the [hosted](./hosted.md) central server for monitoring


An example `minetest.conf` with the pushgateway at port 9091:

```
secure.http_mods = monitoring
monitoring.prometheus_push_url = http://127.0.0.1:9091/metrics/job/minetest/instance/my_server
```

## Verbose monitoring

Enables more metric at a slightly increased cpu-usage:
```
monitoring.verbose = true
```
