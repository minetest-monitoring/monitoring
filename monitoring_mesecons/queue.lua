


-- queue size metric
local metric_action_queue_size = monitoring.gauge(
	"mesecons_action_queue_size",
	"size of action queue"
)

local metric_action_queue_size_max = monitoring.gauge(
        "mesecons_action_queue_size_max",
        "max size of action queue",
	{ autoflush=true }
)

minetest.register_globalstep(function(dtime)
	if not mesecon.queue.actions then
		return
	end

	metric_action_queue_size.set(#mesecon.queue.actions)
	metric_action_queue_size_max.setmax(#mesecon.queue.actions)
end)
