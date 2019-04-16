local metric = monitoring.counter("abm_count", "number of abm calls")
local metric_time = monitoring.counter("abm_time", "time usage in microseconds for abm calls")

minetest.register_on_mods_loaded(function()
  for _, abm in ipairs(minetest.registered_abms) do
    local old_action = abm.action
    abm.action = function(pos, node, active_object_count, active_object_count_wider)
      metric.inc()
      local t0 = minetest.get_us_time()
      old_action(pos, node, active_object_count, active_object_count_wider)
      local t1 = minetest.get_us_time()
      metric_time.inc(t1 - t0)
    end
  end
end)
