
local metric_entity_count = monitoring.gauge("pipeworks_entity_count", "count of pipeworks entities")


local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 5 then return end
	timer=0

	local count = 0
	for _ in pairs(pipeworks.luaentity.entities) do
		count = count + 1
	end

	metric_entity_count.set(count)

end)
