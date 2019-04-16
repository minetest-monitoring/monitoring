local metric = monitoring.counter("lbm_count", "number of lbm calls")

minetest.register_on_mods_loaded(function()
  for _, lbm in ipairs(minetest.registered_lbms) do
    local old_action = lbm.action
    lbm.action = function(pos, node)
      metric.inc()
      old_action(pos, node)
    end
  end
end)
