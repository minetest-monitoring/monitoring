local metric = monitoring.counter("tick_count", "number of ticks")

minetest.register_globalstep(function()
	metric.inc()
end)
