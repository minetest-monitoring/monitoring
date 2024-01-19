local metric = monitoring.counter("log_count", "number of log messages")

local old_log = minetest.log

function minetest.log(...)
	metric.inc()
	return old_log(...)
end