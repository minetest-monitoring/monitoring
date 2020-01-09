if not minetest.get_modpath("replacer") then
        return
else
        print("[monitoring] replacer extension loaded")
end

monitoring.wrap_global({"replacer", "replace"}, "replacer_replace")
