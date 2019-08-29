local metric = monitoring.counter("place_count", "placed nodes counter")

minetest.register_on_placenode(function(pos, newnode, player, oldnode, itemstack)
  metric.inc()
end)
