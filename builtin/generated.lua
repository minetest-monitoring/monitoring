-- generated blocks (80x80)

local metric = monitoring.counter("mapgen_generated_count", "Generated mapgen count")

minetest.register_on_generated(function()
	-- increment chunk count metric
	metric.inc()
end)
