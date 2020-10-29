local metric_time = monitoring.counter("registered_on_prejoinplayers_time", "time usage in microseconds" ..
	"for registered_on_prejoinplayers calls")
local metric_time_max = monitoring.gauge(
	"registered_on_prejoinplayers_time_max",
	"max time usage in microseconds for registered_on_prejoinplayers calls",
	{ autoflush=true }
)


minetest.register_on_mods_loaded(function()
  for i, fn in ipairs(minetest.registered_on_prejoinplayers) do

		minetest.registered_on_prejoinplayers[i] = function(...)
			local t0 = minetest.get_us_time()
			fn(...)
			local t1 = minetest.get_us_time()

			local diff = t1 - t0
      metric_time.inc(diff)
      metric_time_max.setmax(diff)
		end

  end
end)
