max_line_length = 240

globals = {
	"monitoring",
	"minetest",
	"technic",
	"mesecon",
	"pipeworks",
	"core" -- until luacheck gets a new release
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump",

	-- optional dependencies
	"QoS", "mtt", "digiline", "advtrains"
}
