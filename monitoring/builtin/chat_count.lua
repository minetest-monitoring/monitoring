local metric = monitoring.counter("chat_count", "number of chat messages")

minetest.register_on_chat_message(function(name, message)
  metric.inc()
end)
