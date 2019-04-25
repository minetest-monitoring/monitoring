local metric_ndb_count = monitoring.gauge("advtrains_ndb_count", "count of advtrains ndb items")
local metric_train_count = monitoring.gauge("advtrains_train_count", "count of trains")
local metric_wagon_count = monitoring.gauge("advtrains_wagon_count", "count of wagons")

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 60 then return end
	timer=0

  local count = 0
  local ndb_nodes = advtrains.ndb.get_nodes()
  for _, ny in pairs(ndb_nodes) do
    for _, nx in pairs(ny) do
      for _, cid in pairs(nx) do
        count = count + 1
      end
    end
  end
  metric_ndb_count.set(count)

  local traincount = 0
  local wagoncount = 0
  for _, train in pairs(advtrains.trains) do
    count = count + 1

    for _, part in pairs(train.trainparts) do
      wagoncount = wagoncount + 1
    end
  end
  metric_train_count.set(traincount)
  metric_wagon_count.set(wagoncount)

end)
