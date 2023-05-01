
local quarry_def = minetest.registered_nodes["technic:quarry"]
assert(quarry_def)

quarry_def.technic_run =
	monitoring.counter("technic_quarry_dig_count", "number of technic quarry digs")
	.wrap(quarry_def.technic_run)
