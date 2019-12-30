-- generated blocks (80x80)

local metric = monitoring.counter("mapgen_generated_count", "Generated mapgen count")
local metric_total = monitoring.gauge("mapgen_generated_count_total", "Generated mapgen total count")

local total_mapblocks = monitoring.storage:get_int("generated_mapblocks")

minetest.register_on_generated(function(minp, maxp, seed)
	-- increment chunk count metric
	metric.inc()

	-- assume 5 mapblock chunk length here
	total_mapblocks = total_mapblocks + 125
	metric_total.set(total_mapblocks)

	-- persist mapblock count
	monitoring.storage:set_int("generated_mapblocks", total_mapblocks)
end)

minetest.register_chatcommand("monitoring_set_generated_count", {
  description = "Sets the generated mapblock count",
  privs = { server = true },
  func = function(name, param)
		local count = tonumber(param)

		if count and count >= 0 then
			total_mapblocks = count
			metric_total.set(total_mapblocks)
			monitoring.storage:set_int("generated_mapblocks", total_mapblocks)
		end
  end
})
