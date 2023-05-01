
local stepnum = 1

for i, globalstep in ipairs(minetest.registered_globalsteps) do
	local info = minetest.callback_origins[globalstep]
	if not info then
		break
	end

	local modname = info.mod

	if modname == "pipeworks" then

		local metric_globalstep = monitoring.counter(
		"pipeworks_globalstep_time_" .. stepnum,
		"timing or the pipeworks globalstep #" .. stepnum
	)

	-- local proxy function that manages the override and calls the mod's globalsteps
	local fn = function(dtime)
		if not monitoring.pipeworks.enabled then
			-- pipeworks is disabled, skip this globalstep
			return
		end
		local wrappedFn = metric_globalstep.wraptime(globalstep)

		-- call the actual mod callback
		wrappedFn(dtime);
	end
	minetest.callback_origins[fn] = info
	minetest.registered_globalsteps[i] = fn

	stepnum = stepnum + 1
end
end
