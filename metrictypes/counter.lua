
local reentry_map = {}

monitoring.counter = function(name, help)
  local metric = {
    name = name,
    help = help,
    type = "counter",
    value = 0
  }

  -- increment counter
  metric.inc = function(value)
    metric.value = metric.value + (value or 1)
  end

  -- set counter manually
  metric.set = function(value)
    metric.value = value
  end

  -- wrap a function and increment counter on every call
  metric.wrap = function(f)
    return function(...)
      metric.value = metric.value + 1
      return f(...)
    end
  end

  -- wrap a function and increment time on every call
  metric.wraptime = function(f)
    return function(...)
      if reentry_map[metric.name] then
        -- already measuring time for this metric
        return f(...)
      end

      local t0 = minetest.get_us_time()

      reentry_map[metric.name] = true
      -- TODO: find out how to do this properly (pack, unpack)
      local r1, r2, r3, r4, r5, r6 = f(...)
      reentry_map[metric.name] = nil

      local t1 = minetest.get_us_time()
      local diff = t1 - t0

      metric.value = metric.value + diff

      return r1, r2, r3, r4, r5, r6
    end
  end

  table.insert(monitoring.metrics, metric)
  monitoring.metrics_mapped[name] = metric

  return metric
end
