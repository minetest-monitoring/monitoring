# Monitoring framework for minetest
Provides a [prometheus](https://prometheus.io) monitoring endpoint (via push-gateway).

## Demo

* [monitoring.minetest.land](https://monitoring.minetest.land/d/YUpouLmWk/overview?tab=visualization&orgId=1&refresh=5s&var-instance=creative1)

## Documentation

* [Custom metrics](./doc/custom.md)
* [Exporters](./doc/exporters.md)
* [Chat commands](./doc/chatcommands.md)
* [Installation of the mod](./doc/install.md)
* [Hosted](./doc/hosted.md)
* [Docker](./doc/docker.md)
* [Installation of the tools (without docker)](./doc/standalone.md)

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

![](./pics/lag.png?raw=true)

![](./pics/craft.png?raw=true)

## License

MIT
