
# Monitoring framework for minetest

## Features

## Usage in mods

### Counter
```lua
local metric = monitoring.counter("cheat_count", "number of on_cheat")

function do_stuff_periodically()
  metric.inc()
end)
```
### Gauge
```lua
local metric = monitoring.gauge("player_count", "number of players")

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 5 then return end
	timer=0

  metric.set( #minetest.get_connected_players() )
end)

```

### Histogram
```lua
-- top level variable
local export_metric = monitoring.histogram("prom_export_latency", "latency of the export",
  {0.001, 0.005, 0.01, 0.02, 0.1})

function do_stuff()
  local timer = export_metric.timer()
  -- do stuff
  timer.observe()
end

```

## Exporters

## Install

minetest.conf
```
secure.http_mods = monitoring
monitoring.prometheus_push_url = http://127.0.0.1:9091/metrics/job/minetest/instance/my_server
```

```bash
sudo docker run -p 9091:9091 prom/pushgateway
```

## Example
