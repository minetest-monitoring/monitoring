if not minetest.get_modpath("digilines") then
        print("[monitoring] digilines extension not loaded")
        return
else
        print("[monitoring] digilines extension loaded")
end



monitoring.wrap_global({"digilines", "receptor_send"}, "digilines_receptor_send")

