
local stepnum = 1
local override_with_empty_players = false

-- dirty hack to disable the pipeworks visuals
-- the pipeworks mod checks online players and manages the visuals manually
-- providing an empty list in the globalstep tricks it into disabling them
local old_get_connected_players = minetest.get_connected_players
minetest.get_connected_players = function()
  if override_with_empty_players then
    return {}
  else
    return old_get_connected_players()
  end
end


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
      local wrappedFn = metric_globalstep.wraptime(globalstep)

      -- disable player-list
      if not monitoring.pipeworks.enable_visuals then
        override_with_empty_players = true
      end

      -- call the actual mod callback
      wrappedFn(dtime);

      -- enable player-list
      override_with_empty_players = false
    end
		minetest.callback_origins[fn] = info
		minetest.registered_globalsteps[i] = fn

		stepnum = stepnum + 1
	end
end
