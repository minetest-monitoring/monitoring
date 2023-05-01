# Monitoring framework for minetest
Provides a [prometheus](https://prometheus.io) monitoring endpoint (via push-gateway).

## Demo

* [monitoring.minetest.ch](https://monitoring.minetest.ch/d/YUpouLmWk/lua-server-monitoring-mod?tab=visualization&orgId=1&refresh=5s&var-instance=pandorabox.io)

## Documentation

* [Custom metrics](doc/custom.md)
* [Exporters](doc/exporters.md)
* [Chat commands](doc/chatcommands.md)
* [Installation of the mod](doc/install.md)
* [Hosted](doc/hosted.md)
* [Docker](doc/docker.md)
* [Installation of the tools (without docker)](doc/standalone.md)

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

# Pipeworks Features

* Tubed item management (flushing)
* Enable and disable pipeworks at runtime
* Item expiration (tubed items only stay 10 minutes in the pipes)
* Item injection limit per mapchunk

# Chatcommands

* **/pipeworks_flush** flushes (removes) all items in the tubes
* **/pipeworks_stats** shows the item count
* **/pipeworks_enable** enables the pipeworks mod at runtime
* **/pipeworks_disable** disables the pieworks mod at runtime
* **/pipeworks_check_limit** check the injection limits on the current mapchunk
* **/pipeworks_limit_stats** shows the chunk with the highest injection rate


## Metric controller

Usage:

Reading:
```lua
if event.type == "program" then
  -- query metric by its name
  digiline_send("ctrl_channel", "pipeworks_entity_count")
end

if event.type == "digiline" and event.channel == "ctrl_channel" then
  print("Pipeworks entities: " .. event.msg)
end
```

Writing:
```lua
digiline_send("channel", {
	metric = "ingame_lua_tube_mese",
	help = "my mese lua tube count"
	counter = true,
	increment = true,
	value = 20
})
```

## License

* Code: MIT
* textures/monitoring_controller_top.png
  * CC BY-SA 3.0 https://cheapiesystems.com/git/digistuff
