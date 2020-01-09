local metric_join = monitoring.counter("player_join_count", "number of players joined")
local metric_join_new = monitoring.counter("player_join_new_count", "number of new players joined")
local metric_prejoin = monitoring.counter("player_prejoin_count", "number of players prejoined")

minetest.register_on_prejoinplayer(function(name)
	metric_prejoin.inc()

	if not minetest.player_exists(name) then
		metric_join_new.inc()
	end
end)

minetest.register_on_joinplayer(function()
	metric_join.inc()
end)
