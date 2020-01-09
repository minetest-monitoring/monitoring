local metric = monitoring.counter("chat_count", "number of chat messages")

minetest.register_on_chat_message(function()
  metric.inc()
end)
