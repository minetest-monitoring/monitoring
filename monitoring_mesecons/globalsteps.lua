

local max_time_metric = monitoring.gauge(
        "mesecons_globalstep_time_max",
        "max timing of the mesecons globalsteps",
	{ autoflush=true }
)


local stepnum = 1
-- mesecons globalsteps
for i, globalstep in ipairs(minetest.registered_globalsteps) do
	local info = minetest.callback_origins[globalstep]
	if not info then
		break
	end

	local modname = info.mod

	if modname == "mesecons" then

		local metric_globalstep = monitoring.counter(
			"mesecons_globalstep_time_" .. stepnum,
			"timing of the mesecons globalstep #" .. stepnum
		)

		local fn = metric_globalstep.wraptime(function(...)
			local t0 = minetest.get_us_time()
			globalstep(...)
			local t1 = minetest.get_us_time()
			local diff = t1 - t0
			max_time_metric.setmax(diff)
		end)
		minetest.callback_origins[fn] = info
		minetest.registered_globalsteps[i] = fn

		stepnum = stepnum + 1
	end
end
