local metric = monitoring.counter("place_count", "placed nodes counter")

minetest.register_on_placenode(function()
  metric.inc()
end)
