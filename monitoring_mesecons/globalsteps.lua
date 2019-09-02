
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
			"timing or the mesecons globalstep #" .. stepnum
		)

		local fn = metric_globalstep.wraptime(globalstep)
		minetest.callback_origins[fn] = info
		minetest.registered_globalsteps[i] = fn

		stepnum = stepnum + 1
	end
end
