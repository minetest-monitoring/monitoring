-- generated blocks (80x80)
local get_us_time = minetest.get_us_time

local metric = monitoring.counter("mapgen_generated_count", "Generated mapgen count")

local metric_time = monitoring.counter("on_generated_time", "time usage in microseconds for on_generated calls")
local metric_time_max = monitoring.gauge(
	"on_generated_time_max",
	"max time usage in microseconds for on_generated calls",
	{ autoflush=true }
)

minetest.register_on_generated(function()
	-- increment chunk count metric
	metric.inc()
end)

minetest.register_on_mods_loaded(function()
	for i, on_generated in ipairs(minetest.registered_on_generateds) do
		minetest.registered_on_generateds[i] = function(...)
			local t0 = get_us_time()
			on_generated(...)
			local t1 = get_us_time()

			local diff = t1 - t0
			metric_time.inc(diff)
			metric_time_max.setmax(diff)
		end
	end
end)
