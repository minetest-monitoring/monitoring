local metric = monitoring.counter("eat_count", "number of eaten items")

minetest.register_on_item_eat(function()
  metric.inc()
end)
