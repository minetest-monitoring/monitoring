local metric = monitoring.gauge("forceload_blocks_count", "number of forceload blocks")


-- stolen from https://github.com/minetest/minetest/blob/master/builtin/game/forceloading.lua
local wpath = minetest.get_worldpath()
local function read_file(filename)
	local f = io.open(filename, "r")
	if f==nil then return {} end
	local t = f:read("*all")
	f:close()
	if t=="" or t==nil then return {} end
	return minetest.deserialize(t) or {}
end




local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 5 then return end
	timer=0

	local total_forceloaded = 0
	local blocks_forceloaded = read_file(wpath.."/force_loaded.txt")

	for _, __ in pairs(blocks_forceloaded) do
		total_forceloaded = total_forceloaded + 1
	end

	metric.set(total_forceloaded)
end)
