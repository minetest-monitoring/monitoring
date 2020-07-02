-- engine stats
-- needs patch: https://github.com/pandorabox-io/minetest_docker/blob/master/patches/lua_profiler.patch

-- <engine-metric-name> -> metric
local engine_metrics = {}

engine_metrics["Server::AsyncRunStep() [ms]"] = monitoring.gauge(
	"engine_async_run_step",
	"async run step time average in milliseconds"
)

engine_metrics["Server::SendBlocks(): Send to clients [ms]"] = monitoring.counter(
	"engine_sendblocks",
	"sendblocks time sum in milliseconds"
)

engine_metrics["Server::SendBlocks(): Collect list [ms]"] = monitoring.counter(
	"engine_sendblocks_collect",
	"sendblocks collect time sum in milliseconds"
)

engine_metrics["Server: Process network packet (sum) [ms]"] = monitoring.counter(
	"engine_network_processing",
	"sendblocks time sum in milliseconds"
)

engine_metrics["Server: map saving (sum) [ms]"] = monitoring.counter(
	"engine_map_saving",
	"map saving time sum in milliseconds"
)

engine_metrics["Server: liquid transform [ms]"] = monitoring.counter(
	"engine_liquid_processing",
	"liquid processing time sum in milliseconds"
)

engine_metrics["Server: map timer and unload [ms]"] = monitoring.counter(
	"engine_map_timer_and_unload",
	"map timer and unload time sum in milliseconds"
)

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 1 then return end
	timer=0

	-- read from engine metrics and apply in lua space
	for engine_key, metric in pairs(engine_metrics) do
		local value = minetest.get_profiler_value(engine_key)
		if value then
			metric.set(value)
		end
	end

end)
