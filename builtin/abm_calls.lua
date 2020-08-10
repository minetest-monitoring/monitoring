local metric = monitoring.counter("abm_count", "number of abm calls")
local metric_time = monitoring.counter("abm_time", "time usage in microseconds for abm calls")

local metric_time_max = monitoring.gauge(
        "abm_time_max",
        "max time usage in microseconds for abm calls",
	{ autoflush=true }
)


local global_abms_enabled = true

minetest.register_on_mods_loaded(function()
  for _, abm in ipairs(minetest.registered_abms) do
    local old_action = abm.action
    abm.action = function(pos, node, active_object_count, active_object_count_wider)

      if not global_abms_enabled then
        return
      end

      metric.inc()
      local t0 = minetest.get_us_time()
      old_action(pos, node, active_object_count, active_object_count_wider)
      local t1 = minetest.get_us_time()
      local diff = t1 - t0
      metric_time.inc(diff)
      metric_time_max.setmax(diff)
    end
  end
end)


minetest.register_chatcommand("abm_disable", {
	description = "disables all abm's",
	privs = {server=true},
	func = function(name)
		minetest.log("warning", "Player " .. name .. " disables all abm's")
		global_abms_enabled = false
	end
})

minetest.register_chatcommand("abm_enable", {
	description = "enables all abm's",
	privs = {server=true},
	func = function(name)
		minetest.log("warning", "Player " .. name .. " enables all abm's")
		global_abms_enabled = true
	end
})
