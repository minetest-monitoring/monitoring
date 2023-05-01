-- chunk-based pipeworks injection limiter

local function get_chunk_pos(pos)
	return vector.floor(vector.divide(pos, 80))
end

-- map of [chunkpos]count
local data = {}

local function increment_and_get_count(pos)
	local chunk_pos = get_chunk_pos(pos)
	local hash = minetest.hash_node_position(chunk_pos)
	local count = data[hash] or 0
	count = count + 1
	data[hash] = count
	return count
end

-- returns true if the limit is exceeded
function monitoring.pipeworks.inject_limiter(pos)
	local count = increment_and_get_count(pos)
	return count > monitoring.pipeworks.max_inject_items
end

-- returns the mapblock pos with the highest injection rate
function monitoring.pipeworks.inject_limiter_max_pos()
	local max_count = 0
	local max_hash
	for hash, count in pairs(data) do
		if count > max_count then
			max_hash = hash
			max_count = count
		end
	end

	if max_hash then
		local pos = minetest.get_position_from_hash(max_hash)
		return pos, max_count
	end
end

-- returns the current count
function monitoring.pipeworks.inject_limiter_count(pos)
	local chunk_pos = get_chunk_pos(pos)
	local hash = minetest.hash_node_position(chunk_pos)
	return data[hash] or 0
end

-- clear cache periodically
local function clear_cache()
	data = {}
	minetest.after(1, clear_cache)
end

minetest.after(1, clear_cache)
