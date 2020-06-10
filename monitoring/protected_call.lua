

function monitoring.protected_call(metric, fn, pos)
  if not monitoring.settings.handle_errors then
    -- don't handle anything here
    return fn()
  end

  -- handle errors with pcall and avoid further execution of failed functions

  if metric.error then
    -- metric errored previously, don't execute again
    return
  end

  local success, message = pcall(fn)

  if not success then
    -- execution failed, mark as in error
    minetest.log("error", "[monitoring] catched error: " .. (message or "<unknown>"))
    metric.error = message
    metric.error_pos = pos
  end
end
