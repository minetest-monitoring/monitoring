local metric = monitoring.counter("player_punch_count", "number of players punched others")

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
  metric.inc()
end)
