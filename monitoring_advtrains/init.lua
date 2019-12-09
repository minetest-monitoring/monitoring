
if not minetest.get_modpath("advtrains") then
	print("[monitoring] advtrains extension not loaded")
	return
else
	print("[monitoring] advtrains extension loaded")
end

local MP = minetest.get_modpath("monitoring_advtrains")

dofile(MP.."/metrics.lua")
dofile(MP.."/cleanup.lua")
