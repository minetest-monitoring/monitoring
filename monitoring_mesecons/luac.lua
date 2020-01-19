
local BASENAME = "mesecons_luacontroller:luacontroller"


local metric_count = monitoring.counter(
	"mesecons_luacontroller_nodetimer_count",
	"number of luac nodetimer calls"
);

local metric_time = monitoring.counter(
	"mesecons_luacontroller_nodetimer_time",
	"time of luac nodetimer calls"
);

local metric_time_max = monitoring.gauge(
	"mesecons_luacontroller_nodetimer_time_max",
	"max time of luac nodetimer calls",
	{ autoflush=true }
)

for a = 0, 1 do -- 0 = off  1 = on
for b = 0, 1 do
for c = 0, 1 do
for d = 0, 1 do
	local cid = tostring(d)..tostring(c)..tostring(b)..tostring(a)
	local node_name = BASENAME..cid

	local def = minetest.registered_nodes[node_name]

	local old_on_timer = def.on_timer

	def.on_timer = function(...)
		local t0 = minetest.get_us_time()
		old_on_timer(...)
		local t1 = minetest.get_us_time()
		local diff = t1 -t0

		metric_time_max.setmax(diff)
		metric_time.inc(diff)
		metric_count.inc(1)
	end
end
end
end
end
