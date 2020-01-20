if not minetest.get_modpath("technic") then
        print("[monitoring] technic extension not loaded")
        return
else
        print("[monitoring] technic extension loaded")
end

local MP = minetest.get_modpath("monitoring_technic")

dofile(MP.."/abm.lua")
dofile(MP.."/technic_run.lua")
