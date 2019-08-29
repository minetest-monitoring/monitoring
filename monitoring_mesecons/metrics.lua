

monitoring.wrap_global({"mesecon", "queue", "add_action"}, "mesecons_queue_action_add")
monitoring.wrap_global({"mesecon", "queue", "execute"}, "mesecons_queue_execute")
monitoring.wrap_global({"mesecon", "queue", "get_node_force"}, "mesecons_queue_get_node_force")
monitoring.wrap_global({"mesecon", "activate"}, "mesecons_activate")
monitoring.wrap_global({"mesecon", "deactivate"}, "mesecons_deactivate")
monitoring.wrap_global({"mesecon", "turnon"}, "mesecons_turnon")
monitoring.wrap_global({"mesecon", "turnoff"}, "mesecons_turnoff")
monitoring.wrap_global({"mesecon", "changesignal"}, "mesecons_changesignal")



-- function metrics
local metric_function_change_count = monitoring.counter("mesecons_function_change_count", "number of change function executes")
local metric_function_activate_count = monitoring.counter("mesecons_function_activate_count", "number of activate function executes")
local metric_function_deactivate_count = monitoring.counter("mesecons_function_deactivate_count", "number of deactivate function executes")
local metric_function_receptor_on_count = monitoring.counter("mesecons_function_receptor_on_count", "number of receptor_on function executes")
local metric_function_receptor_off_count = monitoring.counter("mesecons_function_receptor_off_count", "number of receptor_off function executes")
local metric_function_lc_interrupt_count = monitoring.counter("mesecons_function_lc_interrupt_count", "number of lc_interrupt function executes")
local metric_function_lc_digiline_relay_count = monitoring.counter("mesecons_function_lc_digiline_relay_count", "number of lc_digiline_relay function executes")

local old_execute = mesecon.queue.execute
mesecon.queue.execute = function(self, action)
	if action.func == "change" then
		metric_function_change_count.inc()
	elseif action.func == "lc_interrupt" then
		metric_function_lc_interrupt_count.inc()
	elseif action.func == "lc_digiline_relay" then
		metric_function_lc_digiline_relay_count.inc()
	elseif action.func == "deactivate" then
		metric_function_deactivate_count.inc()
	elseif action.func == "activate" then
		metric_function_activate_count.inc()
	elseif action.func == "receptor_on" then
		metric_function_receptor_on_count.inc()
	elseif action.func == "receptor_off" then
		metric_function_receptor_off_count.inc()
	end

	old_execute(self, action)
end


-- queue size metric
local metric_action_queue_size = monitoring.gauge("mesecons_action_queue_size", "size of action queue")

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
