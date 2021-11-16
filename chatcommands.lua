
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

minetest.register_chatcommand("forceload", {
  privs = { server = true },
  description = "checks or sets the forceload property of the current mapblock",
  params = "[<on|off>]",
  func = function(name, param)
    local player = minetest.get_player_by_name(name)
    if not player then
      return false, "Player '" .. name .. "' not found"
    end

    local ppos = player:get_pos()
    if param == "on" then
      -- enable
      minetest.forceload_block(ppos, false)
      return true, "Enabled forceloading in current mapblock"
    elseif param == "off" then
      -- disable
      minetest.forceload_free_block(ppos, false)
      return true, "Disabled forceloading in current mapblock"
    else
      -- check
      local fl = monitoring.is_forceloaded(ppos)
      return true, "Current mapblock is " .. (fl and "" or "not ") .. "forceloaded"
    end
  end
})