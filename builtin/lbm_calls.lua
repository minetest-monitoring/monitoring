local metric = monitoring.counter("lbm_count", "number of lbm calls")
local metric_time = monitoring.counter("lbm_time", "time usage in microseconds for lbm calls")

minetest.register_on_mods_loaded(function()
  for _, lbm in ipairs(minetest.registered_lbms) do
    local old_action = lbm.action
    lbm.action = function(pos, node)
      metric.inc()
      local t0 = minetest.get_us_time()
      old_action(pos, node)
      local t1 = minetest.get_us_time()
      metric_time.inc(t1 - t0)
    end
  end
end)
