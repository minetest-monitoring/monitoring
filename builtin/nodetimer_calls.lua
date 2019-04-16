local metric = monitoring.counter("nodetimer_count", "number of nodetime calls")

minetest.register_on_mods_loaded(function()
  for _, node in pairs(minetest.registered_nodes) do
    if node.on_timer then
      local old_action = abm.on_timer
      node.on_timer = function(pos, elapsed)
        metric.inc()
        old_action(pos, elapsed)
      end
    end
  end
end)
