
monitoring.gauge = function(name, help, options)
  local metric = {
    name = name,
    help = help,
    type = "gauge",
    options = options or {}
  }
  table.insert(monitoring.metrics, metric)

  return {
    set = function(value)
      metric.value = value
    end
  }
end
