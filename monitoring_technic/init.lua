if not minetest.get_modpath("technic") then
        print("[monitoring] technic extension not loaded")
        return
else
        print("[monitoring] technic extension loaded")
end

local MP = minetest.get_modpath("monitoring_technic")

dofile(MP.."/abm.lua")
dofile(MP.."/quarry.lua")

if minetest.settings:get_bool("monitoring.technic.verbose") then
  dofile(MP.."/technic_run.lua")
end
