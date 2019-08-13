local metric = monitoring.counter("luaentity_add_entity_calls", "number of luaentity.add_entity calls")
local metric_time = monitoring.counter(
	"luaentity_add_entity_time",
	"time usage in microseconds for luaentity.add_entity calls"
)

luaentity.add_entity = metric.wrap(metric_time.wrap(luaentity.add_entity))
