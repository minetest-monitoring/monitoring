
monitoring.counter = function(name, help)
  local metric = {
    name = name,
    help = help,
    type = "gauge"
    value = 0
  }

  table.insert(monitoring.metrics, metric)

  return {
    inc = function(value)
      metric.value = metric.value + (value or 1)
    end
  }
end
