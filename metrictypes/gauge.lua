
monitoring.gauge = function(name, help, options)
	local metric = {
		name = name,
		help = help,
		type = "gauge",
		labels = options and options.labels or {},
		options = options or {}
	}

	metric.set = function(value)
		metric.value = value
	end

	metric.setmax = function(value)
		if metric.value then
			if value > metric.value then
				-- new value is greater
				metric.value = value
			end
		else
			-- no previous value, set current
			metric.value = value
		end
	end

	metric.setmin = function(value)
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

	return monitoring.register_metric(metric)
end
