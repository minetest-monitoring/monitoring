local metric = monitoring.counter("craft_count", "crafted items counter")

minetest.register_on_craft(function(itemstack, player)
	if player and minetest.is_player(player) and not player.is_fake_player then
		metric.inc(itemstack:get_count())
	end
end)
