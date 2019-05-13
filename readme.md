
# Monitoring framework for minetest
Provides a [prometheus](https://prometheus.io) monitoring endpoint (via push-gateway)

## Demos

* [Pandorabox](https://pandorabox.io/grafana/d/cACE6ppik/overview?refresh=5s&orgId=1)
* [monitoring.minetest.land](https://monitoring.minetest.land/d/YUpouLmWk/overview?tab=visualization&orgId=1&refresh=5s&var-instance=creative1)

## Documentation

* [Custom metrics](doc/custom.md)
* [Exporters](doc/exporters.md)
* [Installation](doc/install.md)
* [Hosted](doc/hosted.md)
* [Docker](doc/docker.md)

## Features

* Builtin metrics (lag, mapgen, time, uptime, auth, etc)
* Supports the **gauge**, **counter** and **histogram** metrics

## Mod integrations
Those are in separate repositories:

* https://github.com/thomasrudin-mt/monitoring_advtrains
* https://github.com/thomasrudin-mt/monitoring_mesecons

## Screenshots

![](pics/lag.png?raw=true)

![](pics/craft.png?raw=true)

# License

MIT
