local metric_tube_inject_item_calls = monitoring.counter(
	"pipeworks_tube_inject_item_calls",
	"count of pipeworks.tube_inject_item calls"
)

local metric_tube_inject_item_time = monitoring.counter(
	"pipeworks_tube_inject_item_time",
	"time of pipeworks.tube_inject_item calls"
)

local metric_tube_inject_item_limited_calls = monitoring.counter(
	"pipeworks_tube_inject_item_limited_calls",
	"count of pipeworks.tube_inject_item calls that were blocked"
)

local old_inject_item = pipeworks.tube_inject_item

pipeworks.tube_inject_item = function(pos, start_pos, velocity, item, owner)
	if not monitoring.pipeworks.enabled then
		-- only allow call if the mod is in "enabled" state
		return
	end

	local limit_reached = monitoring.pipeworks.inject_limiter(pos)
	if limit_reached then
		-- limit exceeded
		metric_tube_inject_item_limited_calls.inc()
		return
	end

	-- everything ok, let it go into tubes
	old_inject_item(pos, start_pos, velocity, item, owner)
end

-- wrap metrics interceptor around it
pipeworks.tube_inject_item = metric_tube_inject_item_calls.wrap(
	metric_tube_inject_item_time.wraptime(pipeworks.tube_inject_item)
)
