local metric = monitoring.gauge("lua_mem_kb", "lua used memory in kilobytes")
local metric_min = monitoring.gauge("lua_mem_min_kb", "lua min used memory in kilobytes")
local metric_max = monitoring.gauge("lua_mem_max_kb", "lua max used memory in kilobytes")



local timer = 0
minetest.register_globalstep(function(dtime)

	-- https://www.lua.org/manual/5.1/manual.html
	local mem = collectgarbage("count")

	metric_min.setmin(mem)
	metric_max.setmax(mem)

	timer = timer + dtime
	if timer < 5 then return end
	timer=0

	metric.set( collectgarbage("count") )
end)
