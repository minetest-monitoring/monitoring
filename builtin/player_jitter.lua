local metric_max = monitoring.gauge("player_jitter_max", "player max jitter")
local metric_min = monitoring.gauge("player_jitter_min", "player min jitter")
local metric_avg = monitoring.gauge("player_jitter_avg", "player avg jitter")


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

	local jitter_min = 5
	local jitter_max = 0

	for _, player in ipairs(minetest.get_connected_players()) do
		local info = minetest.get_player_information(player:get_player_name())

		if info then

			if info.min_jitter < jitter_min then
				jitter_min = info.min_jitter
			end

			if info.max_jitter > jitter_max then
				jitter_max = info.max_jitter
			end

			avg_sum = avg_sum + info.avg_jitter
			avg_count = avg_count + 1
		end

	end

	metric_max.set(jitter_max)
	metric_min.set(jitter_min)
	metric_avg.set(avg_sum / avg_count)

end)
