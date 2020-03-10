
# Standalone monitoring server setup

Quick instructions to get the monitoring stack running locally (without docker).
For a (proper) docker setup see the `docker-compose.yml` file at https://github.com/minetest-monitoring/monitoring.minetest.land

The monitoring stack:
<img src="./standalone-stack.png"></img>

Responsibilities:
* **monitoring_mod** gathers the data from within minetest and POST's them to the pushgateway
* **Pushgateway** is the "switchboard" application where the minetest-mod pushes and prometheus pulls the data
* **Prometheus** scrapes (pulls) the data from the pushgateway and persists them on-disk for later querying
* **Grafana** Retrieves the data from prometheus and visualizes it

## Prometheus

* Download **prometheus** from: https://prometheus.io/download/
* Extract the archive

Replace the `prometheus.yml` file with the following contents:
```yml
global:
  scrape_interval:     5s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'minetest'
    static_configs:
    - targets: ['localhost:9091']
```

Start prometheus:
```bash
./prometheus
```


## Pushgateway

* Download **pushgateway** from https://prometheus.io/download/
* Extract the archive

Start the pushgateway:
```bash
./pushgateway
```

## Grafana

* Download **grafana** from https://grafana.com/grafana/download
* Extract the archive

Start grafana:
```bash
./bin/grafana-server
```

* Point your browser to http://127.0.0.1:3000/login
* Use `admin` as username and `admin` as initial password to login
* Create a new datasource with URL: http://127.0.0.1:9090

### Import dashboards

Export a dashboard from https://monitoring.minetest.land or download the [overview](./dashboard-overview.json) dashboard.

* Click the "+" Sign on the left
* Choose "Import"
* Paste the above json file and import the dashboard
