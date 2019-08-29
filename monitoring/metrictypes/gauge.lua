
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
    end,

    setmax = function(value)
      if metric.value then
	      if value > metric.value then
		      -- new value is greater
		      metric.value = value
	      end
      else
	      -- no previous value, set current
	      metric.value = value
      end
    end,

    setmin = function(value)
      if metric.value then
	      if value < metric.value then
		      -- new value is smaller
		      metric.value = value
	      end
      else
	      -- no previous value, set current
	      metric.value = value
      end
    end
  }
end
