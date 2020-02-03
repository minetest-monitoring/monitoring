if not minetest.get_modpath("technic") then
        print("[monitoring] technic extension not loaded")
        return
else
        print("[monitoring] technic extension loaded")
end

local MP = minetest.get_modpath("monitoring_technic")

-- globals
monitoring.wrap_global({"technic", "handle_machine_pipeworks"}, "technic_handle_machine_pipeworks")

-- abm stuff
dofile(MP.."/abm.lua")

-- quarry
dofile(MP.."/quarry.lua")

if minetest.settings:get_bool("monitoring.technic.verbose") then
  -- intercept *all* machines (may be slow!)
  dofile(MP.."/technic_run.lua")
end
