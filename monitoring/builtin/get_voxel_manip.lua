local metric = monitoring.counter("get_voxel_manip_calls", "number of get_voxel_manip calls")
local metric_time = monitoring.counter("get_voxel_manip_time", "time usage in microseconds for get_voxel_manip calls")

minetest.get_voxel_manip = metric.wrap(metric_time.wrap(minetest.get_voxel_manip))
