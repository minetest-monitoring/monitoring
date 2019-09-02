


-- queue size metric
local metric_action_queue_size = monitoring.gauge("mesecons_action_queue_size", "size of action queue")

-- count metric + circuit breaker
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 1 then return end
	timer=0

	-- metric for action queue size
	local count = 0
	for i, ac in ipairs(mesecon.queue.actions) do
		count = count + 1
	end

	metric_action_queue_size.set(count)

	if count >= 50000 then
		-- short circuit failsafe
		mesecon.queue.actions = {}
	end
end)
