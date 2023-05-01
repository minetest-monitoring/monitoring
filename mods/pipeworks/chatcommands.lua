minetest.register_chatcommand("pipeworks_flush", {
	description = "flushes the pipeworks tubes",
	privs = {server=true},
	func = function(name)
		minetest.log("warning", "Player " .. name .. " flushes the pipeworks tubes")
		local count = monitoring.pipeworks.flush()
		minetest.log("warning", "Flushed: " .. count .. " items")
		return true, "Flushed: " .. count .. " items"
	end
})

minetest.register_chatcommand("pipeworks_stats", {
	description = "Returns some pipeworks stats",
	privs = {interact=true},
	func = function()
		local count = 0
		for _, _ in pairs(pipeworks.luaentity.entities) do
			count = count + 1
		end
		return true, "Items in tubes: " .. count
	end
})

minetest.register_chatcommand("pipeworks_enable", {
	description = "enables the pipeworks mod",
	privs = {server=true},
	func = function(name)
		monitoring.pipeworks.enabled = true
		minetest.log("warning", "Player " .. name .. " enables the pipeworks mod")
		return true, "Pipeworks enabled"
	end
})

minetest.register_chatcommand("pipeworks_disable", {
	description = "disables the pipeworks mod",
	privs = {server=true},
	func = function(name)
		-- flush pipes and disable
		monitoring.pipeworks.flush()
		monitoring.pipeworks.enabled = false
		minetest.log("warning", "Player " .. name .. " disables the pipeworks mod")
		return true, "Pipeworks disabled"
	end
})

minetest.register_chatcommand("pipeworks_check_limit", {
	description = "checks if the injection limit is reached at the current position",
	func = function(name)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()
		local count = monitoring.pipeworks.inject_limiter_count(pos)
		return true, "Count: " .. count .. " max: " .. monitoring.pipeworks.max_inject_items
	end
})

minetest.register_chatcommand("pipeworks_limit_stats", {
	description = "shows the chunk with the highest injection rate",
	func = function()

		local pos, count = monitoring.pipeworks.inject_limiter_max_pos()
		local msg = "no stats available"
		if pos then
			msg = "Chunk: " .. minetest.pos_to_string(pos) .. " count: " .. count ..
				" max: " .. monitoring.pipeworks.max_inject_items
		end

		return true, msg
	end
})
