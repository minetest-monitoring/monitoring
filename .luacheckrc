allow_defined_top = true

globals = {
	"monitoring",
	"luaentity",
	"minetest",
	"advtrains",
	"digtron",
	"DigtronLayout",
	"pipeworks",
	"digiline",
	"mesecon",
	"technic",
	"replacer"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump"

}
