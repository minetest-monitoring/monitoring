local metric = monitoring.counter("received_fields", "received client fields count")

minetest.register_on_player_receive_fields(function()
	metric.inc()
end)


local metric_time = monitoring.counter("on_player_receive_fields_time", "time usage in microseconds" ..
	"for on_player_receive_fields calls")
local metric_time_max = monitoring.gauge(
	"on_player_receive_fields_time_max",
	"max time usage in microseconds for on_player_receive_fields calls",
	{ autoflush=true }
)


minetest.register_on_mods_loaded(function()
  for i, fn in ipairs(minetest.registered_on_player_receive_fields) do

		minetest.registered_on_player_receive_fields[i] = function(...)
			local t0 = minetest.get_us_time()
			local result = fn(...)
			local t1 = minetest.get_us_time()

			local diff = t1 - t0
      metric_time.inc(diff)
      metric_time_max.setmax(diff)
			return result
		end

  end
end)
