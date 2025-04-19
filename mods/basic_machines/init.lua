local function register_effector_metric(nodename, metricname, prettyname)
	local nodedef = minetest.registered_nodes[nodename]
	if not nodedef then
		return
	end
	local metric_count = monitoring.counter("basic_machines_" .. metricname .. "_count",
		"number of " .. prettyname .. " executes")
	local metric_time = monitoring.counter("basic_machines_" .. metricname .. "_time",
		"total time of " .. prettyname .. " executes in us")


	if nodedef.effector and nodedef.effector.action_on then
		nodedef.effector.action_on = metric_count.wrap( metric_time.wraptime(nodedef.effector.action_on) )
	end
end

register_effector_metric("basic_machines:autocrafter", "autocrafter", "Autocrafter")
register_effector_metric("basic_machines:ball_spawner", "ball_spawner", "Ball Spawner")
register_effector_metric("basic_machines:mover", "mover", "Mover")
register_effector_metric("basic_machines:keypad", "keypad", "Keypad")
register_effector_metric("basic_machines:detector", "detector", "Detector")
register_effector_metric("basic_machines:distributor", "distributor", "Distributor")
register_effector_metric("basic_machines:light_off", "light_off", "Light off")
register_effector_metric("basic_machines:light_on", "light_on", "Light on")
