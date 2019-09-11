unused_args = false
allow_defined_top = true

globals = {
	"monitoring",
	"mesecon",
	"minetest"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump"
}
