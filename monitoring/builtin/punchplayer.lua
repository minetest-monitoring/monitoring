local metric = monitoring.counter("player_punch_count", "number of players punched others")

minetest.register_on_punchplayer(function()
  metric.inc()
end)
