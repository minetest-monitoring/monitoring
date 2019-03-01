local metric = monitoring.counter("eat_count", "number of eaten items")

minetest.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user, pointed_thing)
  metric.inc()
end)
