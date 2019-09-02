if not minetest.get_modpath("technic") then
        print("[monitoring] technic extension not loaded")
        return
else
        print("[monitoring] technic extension loaded")
end


for _, abm in ipairs(minetest.registered_abms) do

  if abm.label == "Switching Station" then
    print("[monitoring] wrapping switching station abm")

    abm.action = monitoring
      .counter("technic_switching_station_abm_count", "number of technic switch abm calls")
      .wrap(abm.action)

    abm.action = monitoring
      .counter("technic_switching_station_abm_time", "time of technic switch abm calls")
      .wraptime(abm.action)
  end


end



local quarry_node = minetest.registered_nodes["technic:quarry"]
if quarry_node ~= nil then
	print("[monitoring] wrapping quarry.technic_run")

	quarry_node.technic_run = monitoring
	.counter("technic_quarry_dig_count", "number of technic quarry digs")
	.wrap(quarry_node.technic_run)
end

