
local export_csv = function()
  -- local data = ""

  for _, metric in ipairs(monitoring.metrics) do
    -- TODO
  end
end


monitoring.csv_init = function()
  local timer = 0
  minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer < 5 then return end
    timer=0

    export_csv()
  end)
end
