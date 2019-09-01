# Monitoring framework for minetest
Provides a [prometheus](https://prometheus.io) monitoring endpoint (via push-gateway).

## Demo

* [monitoring.minetest.land](https://monitoring.minetest.land/d/YUpouLmWk/overview?tab=visualization&orgId=1&refresh=5s&var-instance=creative1)

## Documentation

* [Custom metrics](monitoring/doc/custom.md).
* [Exporters](monitoring/doc/exporters.md).
* [Chat commands](monitoring/doc/chatcommands.md).
* [Installation](monitoring/doc/install.md).
* [Hosted](monitoring/doc/hosted.md).
* [Docker](monitoring/doc/docker.md).

## Features

* Builtin metrics (lag, mapgen, time, uptime, auth, etc.).
* Supports the **gauge**, **counter** and **histogram** metrics.

## Mod integrations

* advtrains
* technic
* mesecons
* digtron
* protector

## Screenshots

![](monitoring/pics/lag.png?raw=true)

![](monitoring/pics/craft.png?raw=true)

## License

MIT
