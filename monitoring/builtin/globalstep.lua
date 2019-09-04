local metric_callbacks = monitoring.gauge("globalstep_callback_count", "number of globalstep callbacks")
local metric = monitoring.counter("globalstep_count", "number of globalstep calls")
local metric_time = monitoring.counter("globalstep_time", "time usage in microseconds for globalstep calls")
local metric_time_max = monitoring.gauge(
	"globalstep_time_max",
	"max time usage in microseconds for globalstep calls",
	{ autoflush=true }
)

-- modname -> bool
local globalsteps_disabled = {}

minetest.register_on_mods_loaded(function()
  metric_callbacks.set(#minetest.registered_globalsteps)

  for i, globalstep in ipairs(minetest.registered_globalsteps) do

    local info = minetest.callback_origins[globalstep]

    local new_callback = function(...)

      if globalsteps_disabled[info.mod] then
        return
      end

      metric.inc()
      local t0 = minetest.get_us_time()

      globalstep(...)

      local t1 = minetest.get_us_time()
      local diff = t1 - t0
      metric_time.inc(diff)
      metric_time_max.setmax(diff)

      if diff > 75000 then
        minetest.log("warning", "[monitoring] globalstep took " .. diff .. " us in mod " .. (info.mod or "<unknown>"))
      end

    end

    minetest.registered_globalsteps[i] = new_callback

    -- for the profiler
    if minetest.callback_origins then
      minetest.callback_origins[new_callback] = info
    end

  end
end)



minetest.register_chatcommand("globalstep_disable", {
	description = "disables a globalstep",
	privs = {server=true},
	func = function(name, param)
    if not param then
      minetest.chat_send_player(name, "Usage: globalstep_disable <modname>")
      return false
    end

		minetest.log("warning", "Player " .. name .. " disables globalstep " .. param)
		globalsteps_disabled[param] = true
	end
})

minetest.register_chatcommand("globalstep_enable", {
	description = "enables a globalstep",
	privs = {server=true},
	func = function(name, param)
    if not param then
      minetest.chat_send_player(name, "Usage: globalstep_enable <modname>")
      return false
    end

		minetest.log("warning", "Player " .. name .. " enables globalstep " .. param)
		globalsteps_disabled[param] = nil
	end
})

minetest.register_chatcommand("globalsteps_enable", {
	description = "enables all globalsteps",
	privs = {server=true},
	func = function(name, param)
		minetest.log("warning", "Player " .. name .. " enables all globalsteps")
		globalsteps_disabled = {}
	end
})

minetest.register_chatcommand("globalstep_status", {
	description = "shows the disabled globalsteps",
	func = function(name, param)
    local list = "Disabled globalsteps:"

    for mod in pairs(globalsteps_disabled) do
      list = list .. " " .. mod
    end

    return true, list
	end
})
