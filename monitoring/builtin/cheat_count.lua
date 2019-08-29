local metric = monitoring.counter("cheat_count", "number of on_cheat")

-- TODO: labels for cheat.type:
-- `moved_too_fast` `interacted_too_far` `interacted_while_dead` `finished_unknown_dig` `dug_unbreakable` `dug_too_fast`
minetest.register_on_cheat(function(player, cheat)
  metric.inc()
end)
