local metric = monitoring.counter("dig_count", "digged nodes counter")

minetest.register_on_dignode(function(pos, oldnode, digger)
  metric.inc()
end)
