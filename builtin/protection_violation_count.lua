local metric = monitoring.counter("protection_violation_count", "number of protection violations")

minetest.register_on_protection_violation(function()
	metric.inc()
end)
