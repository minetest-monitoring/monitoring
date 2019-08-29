local metric_leave = monitoring.counter("player_leave_count", "number of players that left")
local metric_leave_timeout = monitoring.counter("player_leave_timeout_count", "number of players left due to timeout")


minetest.register_on_leaveplayer(function(player, timed_out)

	metric_leave.inc()

	if timed_out then
		metric_leave_timeout.inc()
	end
end)

