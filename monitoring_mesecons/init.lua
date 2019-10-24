if not minetest.get_modpath("mesecons") then
        print("[monitoring] mesecons extension not loaded")
        return
else
        print("[monitoring] mesecons extension loaded")
end


local MP = minetest.get_modpath("monitoring_mesecons")

dofile(MP.."/queue.lua")
dofile(MP.."/globals.lua")
dofile(MP.."/globalsteps.lua")

if minetest.settings:get_bool("monitoring.mesecons.verbose") then
  dofile(MP.."/functions.lua")
end

dofile(MP.."/action_on.lua")
