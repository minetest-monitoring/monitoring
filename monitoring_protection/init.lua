
print("[monitoring] protection extension loaded")

local metric_count = monitoring.counter("is_protected_count", "number of is_protected calls")
local metric_time = monitoring.counter("is_protected_time", "time of is_protected calls")

minetest.is_protected = metric_count.wrap( metric_time.wraptime(minetest.is_protected) )



