local metric = monitoring.counter("find_nodes_in_area_calls", "number of find_nodes_in_area calls")
local metric_time = monitoring.counter("find_nodes_in_area_time", "time usage in microseconds for find_nodes_in_area calls")

minetest.find_path = metric.wrap(metric_time.wrap(minetest.find_nodes_in_area))
