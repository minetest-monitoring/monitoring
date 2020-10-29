local metric_time = monitoring.counter("registered_on_joinplayers_time", "time usage in microseconds" ..
	"for registered_on_joinplayers calls")
local metric_time_max = monitoring.gauge(
	"registered_on_joinplayers_time_max",
	"max time usage in microseconds for registered_on_joinplayers calls",
	{ autoflush=true }
)


minetest.register_on_mods_loaded(function()
  for i, fn in ipairs(minetest.registered_on_joinplayers) do

		minetest.registered_on_joinplayers[i] = function(...)
			local t0 = minetest.get_us_time()
			fn(...)
			local t1 = minetest.get_us_time()

			local diff = t1 - t0
      metric_time.inc(diff)
      metric_time_max.setmax(diff)
		end

  end
end)
