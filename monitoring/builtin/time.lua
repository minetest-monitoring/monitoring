local metric = monitoring.gauge("ingame_time", "ingame time")


local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 5 then return end
	timer=0

  metric.set( minetest.get_timeofday() * 24000 )
end)
