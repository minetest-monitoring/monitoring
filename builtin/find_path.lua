

minetest.find_path(pos1,pos2,searchdistance,max_jump,max_drop,algorithm)


local metric = monitoring.counter("find_path_calls", "number of find_path calls")
local metric_time = monitoring.counter("find_path_time", "time usage in microseconds for find_path calls")

local old_find_path = minetest.find_path
minetest.find_path = function(...)
  metric.inc()
  local t0 = minetest.get_us_time()
  old_find_path(...)
  local t1 = minetest.get_us_time()
  metric_time.inc(t1 - t0)
end
