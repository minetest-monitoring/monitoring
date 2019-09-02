
function register_action_on_metric(nodename, metricname, prettyname)
	local nodedef = minetest.registered_nodes[nodename]
	if nodedef and nodedef.mesecons and nodedef.mesecons.effector and nodedef.mesecons.effector.action_on then
		local metric_count = monitoring.counter("mesecons_" .. metricname .. "_count",
			"number of " .. prettyname .. " executes")
		local metric_time = monitoring.counter("mesecons_" .. metricname .. "_time",
			"total time of " .. prettyname .. " executes in us")

		nodedef.mesecons.effector.action_on = metric_count.wrap( metric_time.wraptime(nodedef.mesecons.effector.action_on) )

	end
end

register_action_on_metric("mesecons_pistons:piston_normal_off", "piston_normal_on", "Piston")
register_action_on_metric("mesecons_pistons:piston_sticky_off", "piston_sticky_on", "Sticky piston")

register_action_on_metric("mesecons_movestones:movestone", "movestone", "Movestone")
register_action_on_metric("mesecons_movestones:sticky_movestone", "sticky_movestone", "Sticky movestone")
register_action_on_metric("mesecons_movestones:movestone_vertical", "movestone_vertical", "Vertical movestone")
register_action_on_metric("mesecons_movestones:sticky_movestone_vertical",
	"sticky_movestone_vertical", "Vertical sticky movestone")
