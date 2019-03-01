
monitoring.gauge = function(name, help)
  local metric = {
    name = name,
    help = help,
    type = "gauge"
  }
  table.insert(monitoring.metrics, metric)

  return {
    set = function(value)
      metric.value = value
    end
  }
end
