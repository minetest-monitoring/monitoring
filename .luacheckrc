unused_args = false
allow_defined_top = true

globals = {
	"luaentity",
	"minetest",
	"advtrains",
	"digtron",
	"DigtronLayout",
	"pipeworks",
	"mesecon",
	"technic"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump"

}
