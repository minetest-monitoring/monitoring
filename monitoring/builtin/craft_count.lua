local metric = monitoring.counter("craft_count", "crafted items counter")

minetest.register_on_craft(function(itemstack, player)
	if player and player:is_player() then
    metric.inc(itemstack:get_count())
	end
end)
