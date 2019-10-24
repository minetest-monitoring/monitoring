
local reentry_map = {}

monitoring.counter = function(name, help)
  local metric = {
    name = name,
    help = help,
    type = "counter",
    value = 0
  }

  table.insert(monitoring.metrics, metric)

  return {
    -- increment counter
    inc = function(value)
      metric.value = metric.value + (value or 1)
    end,

    -- wrap a function and increment counter on every call
    wrap = function(f)
      return function(...)
        metric.value = metric.value + 1
        return f(...)
      end
    end,

    -- wrap a function and increment time on every call
    wraptime = function(f)
      return function(...)
        if reentry_map[metric.name] then
          -- already measuring time for this metric
          return f(...)
        end

        local t0 = minetest.get_us_time()

        reentry_map[metric.name] = true
        local result1, result2, result3 = f(...)
        reentry_map[metric.name] = nil

        local t1 = minetest.get_us_time()
        local diff = t1 - t0

        metric.value = metric.value + diff

        return result1, result2, result3
      end
    end
  }
end
