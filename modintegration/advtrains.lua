local metric_ndb_count = monitoring.gauge("advtrains_ndb_count", "count of advtrains ndb items")

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 60 then return end
	timer=0

  local ndb_nodes = advtrains.ndb.get_nodes()

  local count = 0
  for _, ny in pairs(ndb_nodes) do
    for _, nx in pairs(ny) do
      for _, cid in pairs(nx) do
        count = count + 1
      end
    end
  end

  metric_ndb_count.set(count)
end)
