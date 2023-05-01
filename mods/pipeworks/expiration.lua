local expired_items_metric

if minetest.get_modpath("monitoring") then
	expired_items_metric = monitoring.counter(
	"pipeworks_expired_items_count",
	"Number of expired items"
)
end

local function cleanup()
	local now = os.time()
	for _, entity in pairs(pipeworks.luaentity.entities) do
		if not entity.ctime then
			-- set creation time if not already set
			entity.ctime = now
		else
			-- check expiration time
			local delta = now - entity.ctime
			if delta > monitoring.pipeworks.item_expiration_seconds then
				-- entity expired, remove
				entity:remove()

				if expired_items_metric then
					expired_items_metric.inc()
				end
			end
		end
	end

	minetest.after(10, cleanup)
end

-- start initial cleanup after 10 minutes
minetest.after(monitoring.pipeworks.item_expiration_seconds, cleanup)
