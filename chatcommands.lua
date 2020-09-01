
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

-- lag simulation

local lag = 0

minetest.register_chatcommand("lag", {
  privs = { server = true },
  description = "simulate server lag",
  params = "<seconds>",
  func = function(_, param)
    lag = tonumber(param or "0") or 0
    return true, "lag = " .. lag .. " s"
  end
})

minetest.register_globalstep(function()
  if lag < 0.01 then
    -- ignore value
    return
  end

  local start = minetest.get_us_time()
  local stop = start + (lag * 1000 * 1000)

  while minetest.get_us_time() < stop do
    -- no-op
  end
end)
