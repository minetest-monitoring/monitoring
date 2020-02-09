-- engine stats
-- needs patch: https://github.com/pandorabox-io/minetest_docker/blob/master/patches/lua_profiler.patch

local async_run_step = monitoring.gauge("engine_async_run_step", "async run step time average in milliseconds")
local sendblocks = monitoring.counter("engine_sendblocks", "sendblocks time sum in milliseconds")
local network_processing = monitoring.counter("engine_network_processing", "sendblocks time sum in milliseconds")

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 1 then return end
	timer=0

	async_run_step.set(minetest.get_profiler_value("Server::AsyncRunStep() [ms]"))
	sendblocks.set(minetest.get_profiler_value("Server::SendBlocks(): Send to clients [ms]"))
	network_processing.set(minetest.get_profiler_value("Server: Process network packet (sum) [ms]"))
end)
