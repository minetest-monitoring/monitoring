if minetest.register_on_auth_fail then
	local metric = monitoring.counter("auth_fail_count", "number of auth fails")
	minetest.register_on_authplayer(function(_, _, is_success)
		if is_success == false then
			metric.inc()
		end
	end)
end
