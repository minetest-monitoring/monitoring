
monitoring.error_count_metric = monitoring.counter("error_count", "number of catched errors")

-- state can be a metric or empty object {}
function monitoring.protected_call(state, fn, pos)
  if not monitoring.settings.handle_errors then
    -- don't handle anything here
    return fn()
  end

  -- handle errors with pcall and avoid further execution of failed functions

  if state.error then
    -- metric errored previously, don't execute again
    return
  end

  local success, message = pcall(fn)

  if not success then
    -- execution failed, mark as in error
    minetest.log("error", "[monitoring] catched error: " .. (message or "<unknown>"))
    state.error = message
    state.error_pos = pos
    monitoring.error_count_metric.inc()
  end
end
