
local get_us_time = minetest.get_us_time
local reentry_map = {}

monitoring.counter = function(name, help, options)
	local metric = {
		name = name,
		help = help,
		type = "counter",
		labels = options and options.labels or {},
		value = 0,
		options = options or {}
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

			local t0 = get_us_time()

			reentry_map[metric.name] = true
			local results = {f(...)}
			reentry_map[metric.name] = nil

			local t1 = get_us_time()
			local diff = t1 - t0

			metric.value = metric.value + diff

			return unpack(results)
		end
	end

	return monitoring.register_metric(metric)

end
