local get_us_time = minetest.get_us_time
local metric_callbacks = monitoring.gauge("globalstep_callback_count", "number of globalstep callbacks")
local metric = monitoring.counter("globalstep_count", "number of globalstep calls")
local metric_time = monitoring.counter("globalstep_time", "time usage in microseconds for globalstep calls")
local metric_time_max = monitoring.gauge(
	"globalstep_time_max",
	"max time usage in microseconds for globalstep calls",
	{ autoflush=true }
)

-- <unique-key> -> { strategy = "" }
-- expose config for other mods
monitoring.globalsteps_config = {}

-- globalstep run strategies
local STRATEGY_DISABLED = "DISABLED"
local STRATEGY_SKIP = "SKIP"
local strategies = {
	-- entirely disabled
	[STRATEGY_DISABLED] = function() return false end,
	-- skip calls
	[STRATEGY_SKIP] = function(cfg)
		cfg.count = cfg.count and cfg.count + 1 or 1
		cfg.skip = cfg.skip or 2 -- every 2nd call as default
		if cfg.count >= cfg.skip then
			cfg.count = 0
			return true
		end
		return false
	end
}

local function wrap_globalsteps()
	metric_callbacks.set(#minetest.registered_globalsteps)

	-- info.name => <number>
	local step_name_count = {}

	for i, globalstep in ipairs(minetest.registered_globalsteps) do
		local info = minetest.callback_origins[globalstep]

		-- get unique name for globalstep entry
		local modname = info.mod
		if not modname or modname == "" then
			modname = "unknown"
		end
		local name_count = step_name_count[modname]
		if not name_count then
			name_count = 1
		end
		local globalstep_key = modname .. "_" .. name_count
		name_count = name_count + 1
		step_name_count[modname] = name_count

		local new_callback = function(dtime)
			local cfg = monitoring.globalsteps_config[globalstep_key]
			if not cfg then
				-- set up empty config
				cfg = {}
				monitoring.globalsteps_config[globalstep_key] = cfg
			end
			local strategy_fn = strategies[cfg.strategy]
			if strategy_fn then
				-- call strategy
				local enable = strategy_fn(cfg)
				if not enable then
					return
				end
			end

			metric.inc()
			local t0 = get_us_time()
			globalstep(dtime)
			local t1 = get_us_time()
			local diff = t1 - t0

			metric_time.inc(diff)
			metric_time_max.setmax(diff)

			-- time table
			local tt_entry = cfg.time_us or 0
			tt_entry = tt_entry + diff
			cfg.time_us = tt_entry
		end

		minetest.registered_globalsteps[i] = new_callback

		-- for the profiler
		if minetest.callback_origins then
			minetest.callback_origins[new_callback] = info
		end
	end
end

-- delay globalstep "wrapping" until the mesecons mod did their hack (set to 4 seconds)
-- see: https://github.com/minetest-mods/mesecons/blob/master/mesecons/actionqueue.lua#L118
minetest.register_on_mods_loaded(function()
	minetest.after(5, function()
		print("[monitoring] wrapping globalstep callbacks")
		wrap_globalsteps()
	end)
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
		monitoring.globalsteps_config[param] = { strategy = STRATEGY_DISABLED }
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
		monitoring.globalsteps_config[param] = nil
	end
})

minetest.register_chatcommand("globalsteps_enable", {
	description = "enables all globalsteps",
	privs = {server=true},
	func = function(name)
		minetest.log("warning", "Player " .. name .. " enables all globalsteps")
		monitoring.globalsteps_config = {}
	end
})

minetest.register_chatcommand("globalstep_status", {
	description = "shows the globalstep status",
	func = function()
		local list = "Globalstep status:\n"

		for name, cfg in pairs(monitoring.globalsteps_config) do
			list = list .. "* " .. name .. ", " ..
				"strategy: " .. (cfg.strategy or "DEFAULT") .. ", " ..
				"time: " .. (cfg.time_us or "UNKNOWN") .. " us" ..
				"\n"
		end

		return true, list
	end
})
