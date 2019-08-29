local metric = monitoring.counter("load_area_calls", "number of load_area calls")
local metric_time = monitoring.counter("load_area_time", "time usage in microseconds for load_area calls")

minetest.load_area = metric.wrap(metric_time.wraptime(minetest.load_area))
