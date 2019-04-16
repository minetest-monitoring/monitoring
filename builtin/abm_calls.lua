local metric = monitoring.counter("abm_count", "number of abm calls")

minetest.register_on_mods_loaded(function()
  for _, abm in ipairs(minetest.registered_abms) do
    local old_action = abm.action
    abm.action = function(pos, node, active_object_count, active_object_count_wider)
      metric.inc()
      old_action(pos, node, active_object_count, active_object_count_wider)
    end
  end
end)
