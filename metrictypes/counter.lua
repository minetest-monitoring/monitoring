
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
        local t0 = minetest.get_us_time()

        local result = f(...)

        local t1 = minetest.get_us_time()
        local diff = t1 - t0

        metric.value = metric.value + diff

        return result
      end
    end
  }
end
