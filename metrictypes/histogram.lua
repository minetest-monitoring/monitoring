
local get_us_time = minetest.get_us_time

monitoring.histogram = function(name, help, options)
	local buckets = (options and options.buckets) or {0.01, 0.05, 0.1, 0.2, 0.5, 1.0}
	local bucketvalues = {}
	for k in ipairs(buckets) do
		bucketvalues[k] = 0
	end

	local metric = {
		name = name,
		help = help,
		type = "histogram",
		labels = options and options.labels or {},
		buckets = buckets,
		bucketvalues = bucketvalues,
		sum = 0,
		count = 0,
		infcount = 0
	}

	metric = monitoring.register_metric(metric)

	-- adds the value to the buckets
	local add_value = function(seconds)
		local matched = false

		metric.count = metric.count + 1
		metric.sum = metric.sum + seconds

		for k,v in ipairs(buckets) do
			if seconds <= v then
				metric.bucketvalues[k] = metric.bucketvalues[k] + 1
				matched = true
			end
		end

		if not matched then
			metric.infcount = metric.infcount + 1
		end
	end

	-- manual count
	metric.observe = function(seconds)
		add_value(seconds)
	end

	-- timer based count
	metric.timer = function()
		local t0 = minetest.get_us_time()

		return {
			observe = function()
				local t1 = get_us_time()
				local us = t1 - t0
				local seconds = us / 1000000

				add_value(seconds)
			end
		}
	end

	-- wrap a function
	metric.wrap = function(f)
		return function(...)
			local t0 = get_us_time()

			local r1, r2, r3 = f(...)

			local t1 = get_us_time()
			local us = t1 - t0
			local seconds = us / 1000000

			add_value(seconds)

			return r1, r2, r3
		end
	end

	return metric
end
