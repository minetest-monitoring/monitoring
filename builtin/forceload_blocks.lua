local metric = monitoring.gauge("forceload_blocks_count", "number of forceload blocks")

local blocks_forceloaded = {}

local function update_metric()
	local counter = 0
	for _, _ in pairs(blocks_forceloaded) do
		counter = counter + 1
	end
	metric.set(counter)
end

local function get_blockpos(pos)
	return {
		x = math.floor(pos.x/16),
		y = math.floor(pos.y/16),
		z = math.floor(pos.z/16)}
end

local old_forceload_block = minetest.forceload_block

function minetest.forceload_block(pos, transient, limit)
	local retval = old_forceload_block(pos, transient, limit)

	if retval == true then
		local blockpos = get_blockpos(pos)
		local hash = minetest.hash_node_position(blockpos)
		blocks_forceloaded[hash] = true
		update_metric()
	end

	return retval
end

local old_forceload_free_block = minetest.forceload_free_block

function minetest.forceload_free_block(pos, transient)
	local blockpos = get_blockpos(pos)
	local hash = minetest.hash_node_position(blockpos)
	blocks_forceloaded[hash] = nil -- remove from cache
	update_metric()

	return old_forceload_free_block(pos, transient)
end

-- returns true if the block at the node-position is forceloaded
function monitoring.is_forceloaded(pos)
	local blockpos = get_blockpos(pos)
	local hash = minetest.hash_node_position(blockpos)
	return blocks_forceloaded[hash] == true
end

minetest.register_on_mods_loaded(function()
	update_metric()
end)

-- minetest doesn't call the global api on startup

local wpath = minetest.get_worldpath()

-- stolen from https://github.com/minetest/minetest/blob/master/builtin/game/forceloading.lua
local function read_file(filename)
	local f = io.open(filename, "r")
	if f == nil then return {} end
	local t = f:read("*all")
	f:close()
	if t == "" or t == nil then return {} end

	return minetest.deserialize(t) or {}
end

local forceloadedtxt = read_file(wpath.."/force_loaded.txt")

minetest.after(5, function()
	for hash, _ in pairs(forceloadedtxt) do
		blocks_forceloaded[hash] = true
	end
	update_metric()
end)
