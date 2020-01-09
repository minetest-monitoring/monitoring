if minetest.register_on_auth_fail then
  local metric = monitoring.counter("auth_fail_count", "number of auth fails")


  minetest.register_on_auth_fail(function()
    metric.inc()
  end)
end
