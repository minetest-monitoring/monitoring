local metric = monitoring.counter("nodetimer_count", "number of nodetime calls")
local metric_time = monitoring.counter("nodetimer_time", "time usage in microseconds for nodetimer calls")

local metric_time_max = monitoring.gauge(
        "nodetimer_time_max",
        "max time usage in microseconds for nodetimer calls",
	{ autoflush=true }
)


local global_nodetimer_enabled = true

minetest.register_on_mods_loaded(function()
  for _, node in pairs(minetest.registered_nodes) do
    if node.on_timer then
      local old_action = node.on_timer
      node.on_timer = function(pos, elapsed)

        if not global_nodetimer_enabled then
          -- rerun timer again
          return true
        end

        metric.inc()
        local t0 = minetest.get_us_time()
        local result = old_action(pos, elapsed)
        local t1 = minetest.get_us_time()
	local diff = t1 - t0

	metric_time.inc(diff)
	metric_time_max.setmax(diff)

        return result
      end
    end
  end
end)




minetest.register_chatcommand("nodetimer_disable", {
	description = "disables all nodetimers",
	privs = {server=true},
	func = function(name)
		minetest.log("warning", "Player " .. name .. " disables all nodetimers")
		global_nodetimer_enabled = false
	end
})

minetest.register_chatcommand("nodetimer_enable", {
	description = "enables all nodetimers",
	privs = {server=true},
	func = function(name)
		minetest.log("warning", "Player " .. name .. " enables all nodetimers")
		global_nodetimer_enabled = true
	end
})
