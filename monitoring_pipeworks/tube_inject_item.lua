local metric_tube_inject_item_calls = monitoring.counter(
  "pipeworks_tube_inject_item_calls",
  "count of pipeworks.tube_inject_item calls"
)

local metric_tube_inject_item_time = monitoring.counter(
  "pipeworks_tube_inject_item_time",
  "time of pipeworks.tube_inject_item calls"
)


pipeworks.tube_inject_item = metric_tube_inject_item_calls.wrap(
  metric_tube_inject_item_time.wraptime(pipeworks.tube_inject_item)
)
