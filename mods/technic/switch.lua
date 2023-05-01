assert(type(technic.network_run) == "function")
assert(type(technic.active_networks) == "table")

technic.network_run =
	monitoring.counter("technic_switching_stations_usage", "usage in microseconds cpu time")
	.wraptime(technic.network_run)

local active_switching_stations_metric = monitoring.gauge(
	"technic_active_switching_stations",
	"Number of active switching stations"
)

local function count_stations()
	local count = 0
	for _ in pairs(technic.active_networks) do
		count = count + 1
	end
	active_switching_stations_metric.set(count)
	minetest.after(5, count_stations)
end
count_stations()