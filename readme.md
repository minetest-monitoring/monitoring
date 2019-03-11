
# Monitoring framework for minetest
Provides a [prometheus](https://prometheus.io) monitoring endpoint (via push-gateway)

**Demo:** see [https://pandorabox.io/grafana](https://pandorabox.io/grafana) -> "Overview"

## References
* Export format: https://github.com/prometheus/docs/blob/master/content/docs/instrumenting/exposition_formats.md

## Features

* Builtin metrics (lag, mapgen, time, uptime, auth, etc)
* Supports the **gauge**, **counter** and **histogram** metrics

## Builtin metrics for mods
If installed, these metrics get exported too:

* Technic (switching station: counter and histogram, quarry digs)

## Usage in mods

### Counter
See: https://prometheus.io/docs/concepts/metric_types/#counter

```lua
local metric = monitoring.counter("cheat_count", "number of on_cheat")

function do_stuff_periodically()
  metric.inc()
end)
```

### Gauge
See: https://prometheus.io/docs/concepts/metric_types/#gauge

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
See: https://prometheus.io/docs/concepts/metric_types/#histogram

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

### Wrapping functions

Histogram and counter metrics can also wrap existing functions:
```lua
local mymetric = monitoring.counter("my_count", "my counter")

function do_global_stuff()
  -- more stuff
end

-- overwrite with wrapped and counted function
do_global_stuff = mymetric.wrap(do_global_stuff)

```

* the `counter` metric will increment the value on every call
* the `histogram` metric adds the timing on every call

### As optional dependency
It is best to depend optionally on the `monitoring` dependency.
For that to work you have to check for its presence when creating metric on top level:

Optional dependency in `depends.txt`:
```
monitoring?
```

Optional metric and setter:
```lua
local has_monitoring = minetest.get_modpath("monitoring")
local metric

if has_monitoring then
  metric = monitoring.counter("cheat_count", "number of on_cheat")
end

-- called periodically
function do_stuff_periodically()
  if metric ~= nil then
    -- only increment if the variable is non-nil
    metric.inc()
  end
end)
```

## Exporters

Currently only the exporter for the prometheus push gateway is implemented

## Install

minetest.conf
```
secure.http_mods = monitoring
monitoring.prometheus_push_url = http://127.0.0.1:9091/metrics/job/minetest/instance/my_server
```

## Docker-compose setup for prometheus/grafana

An example `docker-compose` setup is provided in the **docker** folder
