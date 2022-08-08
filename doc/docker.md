
## Docker-compose setup for prometheus/grafana

### docker-compose.yml

```yml
version: "2"

services:
 pushgateway:
  image: prom/pushgateway:v1.2.0
  restart: always

 prometheus:
  image: prom/prometheus:v2.18.0
  restart: always
  depends_on:
   - "pushgateway"
  volumes:
   - "./data/prometheus-data:/prometheus"
   - "./prometheus.yml:/etc/prometheus/prometheus.yml"
  command:
   - '--config.file=/etc/prometheus/prometheus.yml'
   - '--storage.tsdb.path=/prometheus'
   - '--storage.tsdb.retention.time=72h'

 grafana:
  image: grafana/grafana:7.0.0
  restart: always
  environment:
   GF_SECURITY_ADMIN_PASSWORD: enter
  depends_on:
   - prometheus
  volumes:
   - "./data/grafana-data:/var/lib/grafana"
   - "./grafana.ini:/etc/grafana/grafana.ini"

 nginx:
  image: nginx:1.18.0
  restart: always
  networks:
   - terminator
   - default
  restart: always
  volumes:
   - "./data/nginx/nginx.conf:/etc/nginx/nginx.conf:ro"
   - "./data/nginx/routes:/routes"
  environment:
   VIRTUAL_PORT: 80
   VIRTUAL_HOST: monitoring.minetest.ch
   LETSENCRYPT_EMAIL: thomas@rudin.io
   LETSENCRYPT_HOST: monitoring.minetest.ch
  depends_on:
   - grafana
   - pushgateway
  logging:
   options:
    max-size: 50m

networks:
 terminator:
  external: true


```

### prometheus.yml

```yml
global:
    scrape_interval: 5s
    external_labels:
     monitor: 'my-monitor'
scrape_configs:
    - job_name: 'minetest'
      honor_labels: true
      static_configs:
       - targets: ['pushgateway:9091']
```
