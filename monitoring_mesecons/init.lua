if not minetest.get_mod_path("mesecons") then
        print("[monitoring] mesecons extension not loaded")
        return
else
        print("[monitoring] mesecons extension loaded")
end


local MP = minetest.get_modpath("monitoring_mesecons")

dofile(MP.."/metrics.lua")
