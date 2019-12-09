
local metric_train_count = monitoring.gauge("advtrains_active_train_count", "count of active trains")


-- list of active trains
local active_trains = {}

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime

	-- every 10 seconds
	if timer < 10 then return end
	timer = 0

	for _, train in pairs(advtrains.trains) do
		if train.velocity > 0 then
			-- train moved, mark as active
			active_trains[train.id] = true
		end
	end

  -- update metrics
  local active_train_count = 0
  for _ in pairs(active_trains) do
    active_train_count = active_train_count + 1
  end
  metric_train_count.set(active_train_count)

end)


minetest.register_chatcommand("advtrains_cleanup", {
  description = "cleans up all non-automated trains",
  privs = { server = true },
  func = function(name, param)
	local count = 0
	for _, train in pairs(advtrains.trains) do
		if not active_trains[train.id] then
			advtrains.remove_train(train.id)
			count = count + 1
		end
	end
	return true, "Removed " .. count .. " trains"
  end
})


minetest.register_chatcommand("advtrains_stats", {
  description = "show advtrains stats",
  func = function(name, param)
		local train_count = 0
		local wagon_count = 0
		local active_train_count = 0

		for _ in pairs(active_trains) do
			active_train_count = active_train_count + 1
		end

		for _, train in pairs(advtrains.trains) do
			train_count = train_count + 1
			for _, part in pairs(train.trainparts) do
				local wagon = advtrains.wagons[part]
				if wagon ~= nil then
					wagon_count = wagon_count + 1
				end
			end
		end

		return true, "Trains: " .. train_count .. " Wagons: " .. wagon_count .. " Active trains: " .. active_train_count
  end
})
