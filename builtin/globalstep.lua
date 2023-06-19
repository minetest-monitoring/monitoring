local get_us_time = minetest.get_us_time
local metric_callbacks = monitoring.gauge("globalstep_callback_count", "number of globalstep callbacks")
local metric = monitoring.counter("globalstep_count", "number of globalstep calls")
local metric_time = monitoring.counter("globalstep_time", "time usage in microseconds for globalstep calls")
local metric_time_max = monitoring.gauge(
	"globalstep_time_max",
	"max time usage in microseconds for globalstep calls",
	{ autoflush=true }
)

-- per mod/globalstep time table
-- mod-name[n] => time in microseconds
local time_table = {}

-- modname -> bool
local globalsteps_disabled = {}

minetest.register_on_mods_loaded(function()
	metric_callbacks.set(#minetest.registered_globalsteps)

	for i, globalstep in ipairs(minetest.registered_globalsteps) do
		local info = minetest.callback_origins[globalstep]
		local new_callback = function(dtime)
			if globalsteps_disabled[info.mod] then
				return
			end

			metric.inc()
			local t0 = get_us_time()
			globalstep(dtime)
			local t1 = get_us_time()
			local diff = t1 - t0

			metric_time.inc(diff)
			metric_time_max.setmax(diff)

			-- increment globalstep time table entry
			local entr_key = "globalstep_" .. i .. "_" .. (info.mod or "<unknown>")
			local tt_entry = time_table[entr_key] or 0
			tt_entry = tt_entry + diff
			time_table[entr_key] = tt_entry
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
	func = function(name)
		minetest.log("warning", "Player " .. name .. " enables all globalsteps")
		globalsteps_disabled = {}
	end
})

minetest.register_chatcommand("globalstep_status", {
	description = "shows the disabled globalsteps",
	func = function()
		local list = "Disabled globalsteps:"

		for mod in pairs(globalsteps_disabled) do
			list = list .. " " .. mod
		end

		return true, list
	end
})

-- time table commands

minetest.register_chatcommand("globalstep_table_reset", {
	description = "resets the globalstep time table",
	func = function()
		time_table = {}
		return true, "time table reset"
	end
})

minetest.register_chatcommand("globalstep_table_show", {
	description = "shows the globalstep time table",
	func = function()
		local str = ""
		for modname, micros in pairs(time_table) do
			str = str .. "+ " .. modname .. " = " .. micros .. " us\n"
		end
		return true, str
	end
})
