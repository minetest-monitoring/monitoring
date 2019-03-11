
monitoring.counter = function(name, help)
  local metric = {
    name = name,
    help = help,
    type = "gauge",
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
        return call(f, arg)
      end
    end
  }
end
