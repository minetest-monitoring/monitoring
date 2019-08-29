local metric_action_queue_count = monitoring.counter("mesecons_action_queue_count", "number of action queue items")

local metric_action_execute_count = monitoring.counter("mesecons_action_execute_count", "number of action queue executes")
local metric_action_execute_time = monitoring.counter("mesecons_action_execute_time", "total time of action queue executes in us")

local metric_get_node_force_count = monitoring.counter("mesecons_get_node_force_count", "number of get_node_force executes")
local metric_get_node_force_time = monitoring.counter("mesecons_get_node_force_time", "total time of get_node_force executes in us")

local metric_action_queue_size = monitoring.gauge("mesecons_action_queue_size", "size of action queue")

-- metric overrides
mesecon.queue.add_action = metric_action_queue_count.wrap(mesecon.queue.add_action)
mesecon.queue.execute = metric_action_execute_count.wrap( metric_action_execute_time.wraptime(mesecon.queue.execute) )
mesecon.get_node_force = metric_get_node_force_count.wrap( metric_get_node_force_time.wraptime(mesecon.get_node_force) )

mesecon.activate = monitoring.counter("mesecons_activate_count", "mesecon.activate call count")
.wrap(monitoring.counter("mesecons_activate_time", "mesecon.activate time usage").wraptime(mesecon.activate))

mesecon.turnon = monitoring.counter("mesecons_turnon_count", "mesecon.turnon() call count")
.wrap(monitoring.counter("mesecons_turnon_time", "mesecon.turnon() time usage").wraptime(mesecon.turnon))


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

--[[
local old_add_action = mesecon.queue.add_action
mesecon.queue.add_action = function(self, pos, func, params, time, overwritecheck, priority)
  print("add_action: " .. minetest.pos_to_string(pos) .. " function: " .. func)
  if time then
    print(" + time: " .. dump(time))
  end

  if priority then
    print(" + priority: " .. dump(priority))
  end

  if overwritecheck then
    print(" + overwritecheck: " .. dump(overwritecheck))
  end

	old_add_action(self, pos, func, params, time, overwritecheck, priority)
end
--]]

-- queue size metric
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
