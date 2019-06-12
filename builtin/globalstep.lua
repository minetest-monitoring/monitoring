local metric_callbacks = monitoring.gauge("globalstep_callback_count", "number of globalstep callbacks")
local metric = monitoring.counter("globalstep_count", "number of globalstep calls")
local metric_time = monitoring.counter("globalstep_time", "time usage in microseconds for globalstep calls")

minetest.register_on_mods_loaded(function()
  metric_callbacks.set(#minetest.registered_globalsteps)

  for i, globalstep in ipairs(minetest.registered_globalsteps) do

    local new_callback = function(...)
      metric.inc()
      local t0 = minetest.get_us_time()

      globalstep(...)

      local t1 = minetest.get_us_time()
      metric_time.inc(t1 - t0)

    end

    minetest.registered_globalsteps[i] = new_callback

    -- for the profiler
    if minetest.callback_origins then
      minetest.callback_origins[new_callback] = minetest.callback_origins[globalstep]
    end

  end
end)
