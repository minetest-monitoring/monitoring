local metric = monitoring.counter("log_count", "number of log messages")

local old_log = minetest.log

function minetest.log(level, text)
    metric.inc()
    return old_log(level, text)
end