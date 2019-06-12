local metric_callbacks = monitoring.gauge("globalstep_callback_count", "number of globalstep callbacks")
local metric = monitoring.counter("globalstep_count", "number of globalstep calls")
local metric_time = monitoring.counter("globalstep_time", "time usage in microseconds for globalstep calls")

local globalsteps_enabled = true

minetest.register_on_mods_loaded(function()
  metric_callbacks.set(#minetest.registered_globalsteps)

  for i, globalstep in ipairs(minetest.registered_globalsteps) do

    local new_callback = function(...)

      if not globalsteps_enabled then
        return
      end

      metric.inc()
      local t0 = minetest.get_us_time()

      globalstep(...)

      local t1 = minetest.get_us_time()
      metric_time.inc(t1 - t0)

    end

    minetest.registered_globalsteps[i] = new_callback

    -- for the profiler
    if minetest.callback_origins then
      minetest.callback_origins[new_callback] = minetest.callback_origins[globalstep]
    end

  end
end)



minetest.register_chatcommand("globalstep_disable", {
	description = "disables all globalsteps",
	privs = {server=true},
	func = function(name)
		minetest.log("warning", "Player " .. name .. " disables all globalsteps")
		globalsteps_enabled = false
	end
})

minetest.register_chatcommand("globalstep_enable", {
	description = "enables all globalsteps",
	privs = {server=true},
	func = function(name)
		minetest.log("warning", "Player " .. name .. " enables all globalsteps")
		globalsteps_enabled = true
	end
})
