local metric_max = monitoring.gauge("player_rtt_max", "player max rtt")
local metric_min = monitoring.gauge("player_rtt_min", "player min rtt")
local metric_avg = monitoring.gauge("player_rtt_avg", "player avg rtt")


local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 5 then return end
	timer=0


	if #minetest.get_connected_players() < 1 then
		-- no value
		metric_max.set(0)
		metric_min.set(0)
		metric_avg.set(0)
		return
	end

	local avg_sum = 0
	local avg_count = 0

	local rtt_min = 5
	local rtt_max = 0

	for _, player in ipairs(minetest.get_connected_players()) do
		local info = minetest.get_player_information(player:get_player_name())
		if info then
			if info.min_rtt < rtt_min then
				rtt_min = info.min_rtt
			end

			if info.max_rtt > rtt_max then
				rtt_max = info.max_rtt
			end

			avg_sum = avg_sum + info.avg_rtt
			avg_count = avg_count + 1
		end

	end

	metric_max.set(rtt_max)
	metric_min.set(rtt_min)
	metric_avg.set(avg_sum / avg_count)

end)
