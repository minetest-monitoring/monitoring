local metric = monitoring.counter("log_count", "number of log messages")

local old_log = minetest.log

function minetest.log(level, text)
    metric.inc()
    -- The number and order of parameters is important here
    if text ~= nil then
        return old_log(level, text)
    else
        return old_log(level)
    end
end