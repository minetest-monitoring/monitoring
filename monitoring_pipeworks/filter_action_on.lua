


function register_action_on_metric(nodename, metricname, prettyname)
	local nodedef = minetest.registered_nodes[nodename]
	if nodedef and nodedef.mesecons and nodedef.mesecons.effector and nodedef.mesecons.effector.action_on then
		local metric_count = monitoring.counter(
      "pipeworks_" .. metricname .. "_count",
      "number of " .. prettyname .. " executes"
    )

    local metric_time = monitoring.counter(
      "pipeworks_" .. metricname .. "_time",
      "total time of " .. prettyname .. " executes in us"
    )

		nodedef.mesecons.effector.action_on = metric_count.wrap( metric_time.wraptime(nodedef.mesecons.effector.action_on) )

	end
end

register_action_on_metric("pipeworks:mese_filter", "mese_filter", "Mese filter")
register_action_on_metric("pipeworks:filter", "filter", "Filter")

register_action_on_metric("pipeworks:dispenser_off", "dispenser", "Dispenser")
register_action_on_metric("pipeworks:deployer_off", "deployer", "Deployer")
register_action_on_metric("pipeworks:nodebreaker_off", "nodebreaker", "Nodebreaker")
