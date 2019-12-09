if not minetest.get_modpath("pipeworks") then
        print("[monitoring] pipeworks extension not loaded")
        return
else
        print("[monitoring] pipeworks extension loaded")
end


local metric_tube_inject_item_calls = monitoring.counter(
  "pipeworks_tube_inject_item_calls",
  "count of pipeworks.tube_inject_item calls"
)

local metric_tube_inject_item_time = monitoring.counter(
  "pipeworks_tube_inject_item_time",
  "time of pipeworks.tube_inject_item calls"
)


pipeworks.tube_inject_item = metric_tube_inject_item_calls.wrap(
  metric_tube_inject_item_time.wraptime(pipeworks.tube_inject_item)
)


local metric_entity_count = monitoring.gauge("pipeworks_entity_count", "count of pipeworks entities")


local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 5 then return end
	timer=0

	local count = 0
	for id, entity in pairs(pipeworks.luaentity.entities) do
		count = count + 1
	end

	metric_entity_count.set(count)

end)

local stepnum = 1

for i, globalstep in ipairs(minetest.registered_globalsteps) do
	local info = minetest.callback_origins[globalstep]
	if not info then
		break
	end

	local modname = info.mod

	if modname == "pipeworks" then

		local metric_globalstep = monitoring.counter(
			"pipeworks_globalstep_time_" .. stepnum,
			"timing or the pipeworks globalstep #" .. stepnum
		)

		local fn = metric_globalstep.wraptime(globalstep)
		minetest.callback_origins[fn] = info
		minetest.registered_globalsteps[i] = fn

		stepnum = stepnum + 1
	end
end

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

monitoring.wrap_global({"pipeworks", "create_fake_player"}, "pipeworks_create_fake_player")
