local metric = monitoring.counter("find_node_near_calls", "number of find_node_near calls")
local metric_time = monitoring.counter("find_node_near_time", "time usage in microseconds for find_node_near calls")

minetest.find_node_near = metric.wrap(metric_time.wrap(minetest.find_node_near))
