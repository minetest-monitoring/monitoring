
minetest.register_on_mods_loaded(function()
  for name, def in pairs(minetest.registered_nodes) do
    if def.technic_run then

      local sanitized_name = string.gsub(name, ":", "_")

      def.technic_run = monitoring
        .counter("technic_machine_" .. sanitized_name .. "_count", "number of machine calls")
        .wrap(def.technic_run)

      def.technic_run = monitoring
        .counter("technic_machine_" .. sanitized_name .. "_time", "time of machine calls")
        .wraptime(def.technic_run)
    end
  end
end)
