if not minetest.get_mod_path("technic") then
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
      .histogram("technic_switching_station_abm_latency",
        "latency of the technic switch abm calls",
        {0.001, 0.005, 0.01, 0.02, 0.1, 0.5, 1.0})
      .wrap(abm.action)
  end

  if abm.label == "Machines: timeout check" then
    print("[monitoring] wrapping technic machine timeout check")

    abm.action = monitoring
      .counter("technic_machine_timeout_abm_count", "number of technic machine timeout abm calls")
      .wrap(abm.action)

    abm.action = monitoring
      .histogram("technic_machine_timeout_abm_latency",
        "latency of the technic machine timeout abm calls",
        {0.001, 0.005, 0.01, 0.02, 0.1, 0.5, 1.0})
      .wrap(abm.action)
  end

end


if minetest.get_modpath("technic") then
  local quarry_node = minetest.registered_nodes["technic:quarry"]
  if quarry_node ~= nil then
    print("[monitoring] wrapping quarry.technic_run")

    quarry_node.technic_run = monitoring
      .counter("technic_quarry_dig_count", "number of technic quarry digs")
      .wrap(quarry_node.technic_run)
  end

  print("[monitoring] wrapping technic.get_or_load_node")
  technic.get_or_load_node = monitoring
    .histogram("technic_get_or_load_node_latency",
      "latency of the technic get_or_load_node calls",
      {0.001, 0.005, 0.01, 0.02, 0.1, 0.5, 1.0})
    .wrap(technic.get_or_load_node)
end
