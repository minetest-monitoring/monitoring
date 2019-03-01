local metric = monitoring.counter("craft_count", "crafted items counter")

minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	if player and player:is_player() then
    metric.inc(itemstack:get_count())
	end
end)
