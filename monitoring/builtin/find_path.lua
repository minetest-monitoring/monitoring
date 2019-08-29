local metric = monitoring.counter("find_path_calls", "number of find_path calls")
local metric_time = monitoring.counter("find_path_time", "time usage in microseconds for find_path calls")

minetest.find_path = metric.wrap(metric_time.wrap(minetest.find_path))
