local metric = monitoring.gauge("player_count", "number of players")


local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 5 then return end
	timer=0

  metric.set( #minetest.get_connected_players() )
end)
