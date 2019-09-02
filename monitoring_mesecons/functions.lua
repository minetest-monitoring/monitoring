

local metrics = {} -- { { count=, time= }, ... }


function register_function(name)
	local entry = {}
	entry.count = monitoring.counter("mesecons_function_" .. name .. "_count",
		"number of " .. name .. " function executes")
	entry.time = monitoring.counter("mesecons_function_" .. name .. "_time",
		"time of " .. name .." function executes")

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

local old_execute = mesecon.queue.execute
mesecon.queue.execute = function(self, action)

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
