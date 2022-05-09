local metric = monitoring.counter("minetest_after_count", "number of after() calls")
local metric_time = monitoring.counter("minetest_after_time", "time usage in microseconds for after() calls")

local old_minetest_after = minetest.after

minetest.after = function(delay, callback, ...)
	callback = metric_time.wraptime(callback)
	metric.inc()
	old_minetest_after(delay, callback, ...)
end