
minetest.register_chatcommand("metric", {
  params = "<metric_name>",
	description = "shows the current metric value of a gauge or counter",
	func = function(_, param)
    if param == "" or not param then
      return false, "Please specify the metric!"
    end

    local metric = monitoring.metrics_mapped[param]
    if not metric then
      return false, "No such metric: '" .. param .. "'"
    end

    return true, "" .. metric.value or "<unknown>"
  end
})



minetest.register_chatcommand("get_errors", {
  description = "shows all catched errors",
  func = function()
    if not monitoring.settings.handle_errors then
      return false, "Error-handling not enabled!"
    end

    local res = "List of handled errors: \n"
    local count = 0

    for _, metric in ipairs(monitoring.metrics) do
      local pos_msg = ""
      if metric.error_pos then
        pos_msg = " at position " .. minetest.pos_to_string(metric.error_pos)
      end

      if metric.error then
        count = count + 1
        res = res .. metric.name .. ": " .. metric.error .. pos_msg .. "\n"
      end
    end

    if count > 0 then
      return true, res
    else
      return true, "No errors to report"
    end
  end
})


minetest.register_chatcommand("reset_errors", {
  description = "resets all catched errors",
  privs = { server = true },
  func = function()
    if not monitoring.settings.handle_errors then
      return false, "Error-handling not enabled!"
    end

    for _, metric in ipairs(monitoring.metrics) do
      if metric.error then
        metric.error = false
      end
    end

    return true, "Error state reset"
  end
})
