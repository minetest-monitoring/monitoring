local metric = monitoring.counter("received_fields", "received client fields count")

minetest.register_on_player_receive_fields(function()
	metric.inc()
end)
