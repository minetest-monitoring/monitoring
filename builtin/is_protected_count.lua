local metric = monitoring.counter("is_protected_count", "number of is_protected calls")

minetest.is_protected = metric.wrap(minetest.is_protected)
