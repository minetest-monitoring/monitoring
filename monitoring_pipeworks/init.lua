if not minetest.get_modpath("pipeworks") then
        print("[monitoring] pipeworks extension not loaded")
        return
else
        print("[monitoring] pipeworks extension loaded")
end

monitoring.pipeworks = {
  -- enable tubed item visuals
  enable_visuals = true
}

local MP = minetest.get_modpath("monitoring_pipeworks")

dofile(MP.."/entity_count.lua")
dofile(MP.."/filter_action_on.lua")
dofile(MP.."/globalsteps.lua")
dofile(MP.."/metics.lua")
dofile(MP.."/tube_inject_item.lua")
dofile(MP.."/chatcommands.lua")
