local metric_join = monitoring.counter("player_join_count", "number of players joined")
local metric_prejoin = monitoring.counter("player_prejoin_count", "number of players prejoined")

minetest.register_on_prejoinplayer(function(name, ip)
	metric_prejoin.inc()
end)

minetest.register_on_joinplayer(function(player)
	metric_join.inc()
end)
