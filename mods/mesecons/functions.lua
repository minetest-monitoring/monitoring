

local metrics = {} -- { fn_name = { count=, time= }, ... }


local function register_function(name)
	local entry = {}
	entry.count = monitoring.counter(
		"mesecons_function_" .. name .. "_count",
		"number of " .. name .. " function executes"
	)
	entry.time = monitoring.counter(
		"mesecons_function_" .. name .. "_time",
		"time of " .. name .." function executes"
	)

	metrics[name] = entry
end

register_function("change");
register_function("lc_interrupt");
register_function("lc_digiline_relay");
register_function("deactivate");
register_function("activate");
register_function("receptor_on");
register_function("receptor_off");
register_function("other");

-- enable/disable
local enable_function_monitoring = false
minetest.register_chatcommand("mesecons_verbose_monitoring", {
	privs = { server = true },
	description = "enables/disables the verbose mesecons monitoring",
	params = "[true|false]",
	func = function(_, param)
		enable_function_monitoring = param == "true"
		return true, "Verbose monitoring: " .. (enable_function_monitoring and "enabled" or "disabled")
	end
})

-- action queue override
local old_execute = mesecon.queue.execute
mesecon.queue.execute = function(self, action)
	if not enable_function_monitoring then
		-- not enabled, skip time measuring and just execute the action
		return old_execute(self, action)
	end

	local t0 = minetest.get_us_time()
	old_execute(self, action)
	local t1 = minetest.get_us_time()
	local delta_t = t1 - t0

	local metric = metrics[action.func]
	if not metric then
		metric = metrics["other"]
	end

	metric.count.inc()
	metric.time.inc(delta_t)
end
