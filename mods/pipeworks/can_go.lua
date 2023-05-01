
-- all registered metrics
local metrics = {}

local function get_or_create_metric_counter(name, help)
	if not metrics[name] then
		metrics[name] = monitoring.counter(name, help)
	end
	return metrics[name]
end

local function profile_can_go(name, def, prefix)
	if def.tube and def.tube.can_go and type(def.tube.can_go) == "function" then
		-- valid function, intercept can_go function
		print("[pipeworks_monitoring] intercepting can_go call for " .. name)
		local metric_calls = get_or_create_metric_counter(prefix .. "_calls", "calls to " .. prefix)
		local metric_time = get_or_create_metric_counter(prefix .. "_time", " timeing of " .. prefix)

		local wrapped_time = metric_time.wraptime(def.tube.can_go)
		local wrapped_count = metric_calls.wrap(wrapped_time)
		def.tube.can_go = wrapped_count
	end
end

for name, def in pairs(minetest.registered_nodes) do
	if string.find(name, "pipeworks:teleport_tube") then
		profile_can_go(name, def, "pipeworks_teleport_tube")
	end
end
