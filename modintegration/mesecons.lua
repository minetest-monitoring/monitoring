local metric_action_queue_count = monitoring.counter("mesecons_action_queue_count",
 	"number of action queue items")


local old_add_action = mesecon.queue:add_action

function mesecon.queue:add_action(pos, func, params, time, overwritecheck, priority)
  metric_action_queue_count.inc()
  old_add_action(pos, func, params, time, overwritecheck, priority)
end
