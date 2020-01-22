
local quarry_node = minetest.registered_nodes["technic:quarry"]
if quarry_node ~= nil then
	print("[monitoring] wrapping quarry.technic_run")

	quarry_node.technic_run = monitoring
	.counter("technic_quarry_dig_count", "number of technic quarry digs")
	.wrap(quarry_node.technic_run)
end
