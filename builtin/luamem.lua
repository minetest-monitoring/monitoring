local metric = monitoring.gauge("lua_mem_kb", "lua use memory in kilobytes")


local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 5 then return end
	timer=0

  -- https://www.lua.org/manual/5.1/manual.html
  metric.set( collectgarbage("count") )
end)
