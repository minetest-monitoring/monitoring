
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
