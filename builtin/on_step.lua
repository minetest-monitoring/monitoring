local metric = monitoring.counter("entity_on_step_count", "Entity on_step call count")

local metric_time = monitoring.counter("entity_on_step_time", "time usage in microseconds for on_step calls")
local metric_time_max = monitoring.gauge(
	"entity_on_step_time_max",
	"max time usage in microseconds for on_step calls",
	{ autoflush=true }
)


minetest.register_on_mods_loaded(function()
	for _, entity in pairs(minetest.registered_entities) do
		if type(entity.on_step) == "function" then
			local old_on_step = entity.on_step
			entity.on_step = function(...)
				local t0 = minetest.get_us_time()
				local result = old_on_step(...)
				local t1 = minetest.get_us_time()

				local diff = t1 - t0
	      metric_time.inc(diff)
	      metric_time_max.setmax(diff)
				metric.inc()

				return result
			end
		end
	end
end)
