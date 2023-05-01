globals = {
	"monitoring",
	"minetest",
	"technic"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump",

	-- optional dependencies
	"QoS", "mtt", "digiline"
}
