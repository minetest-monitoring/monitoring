
if not minetest.get_modpath("advtrains") then
	print("[monitoring] advtrains extension not loaded")
	return
else
	print("[monitoring] advtrains extension loaded")
end

monitoring.wrap_global({"advtrains", "mainloop_trainlogic"}, "advtrains_mainloop_trainlogic")
monitoring.wrap_global({"advtrains", "ndb", "save_data"}, "advtrains_ndb_save_data")
monitoring.wrap_global({"advtrains", "avt_save"}, "advtrains_avt_save")
monitoring.wrap_global({"atlatc", "mainloop_stepcode"}, "advtrains_atlatc_mainloop_stepcode")
monitoring.wrap_global({"atlatc", "interrupt", "mainloop"}, "advtrains_atlatc_interrupt_mainloop")
monitoring.wrap_global({"atlatc", "run_stepcode"}, "advtrains_atlatc_run_stepcode")


local metric_ndb_count = monitoring.gauge("advtrains_ndb_count", "count of advtrains ndb items")
local metric_train_count = monitoring.gauge("advtrains_train_count", "count of trains")
local metric_wagon_count = monitoring.gauge("advtrains_wagon_count", "count of wagons")


local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 60 then return end
	timer=0

  local count = 0
  local ndb_nodes = advtrains.ndb.get_nodes()
  for _, ny in pairs(ndb_nodes) do
    for _, nx in pairs(ny) do
      for _, cid in pairs(nx) do
        count = count + 1
      end
    end
  end
  metric_ndb_count.set(count)

  local traincount = 0
  local wagoncount = 0
  for _, train in pairs(advtrains.trains) do
    traincount = traincount + 1

    for _, part in pairs(train.trainparts) do
      wagoncount = wagoncount + 1
    end
  end
  metric_train_count.set(traincount)
  metric_wagon_count.set(wagoncount)

end)


local stepnum = 1

-- advtrains globalstep
for i, globalstep in ipairs(minetest.registered_globalsteps) do
	local info = minetest.callback_origins[globalstep]
	if not info then
		break
	end

	local modname = info.mod

	if modname == "advtrains" then

		local metric_globalstep = monitoring.counter(
			"advtrains_globalstep_time_" .. stepnum,
			"timing or the advtrains globalstep #" .. stepnum
		)

		local fn = metric_globalstep.wraptime(globalstep)
		minetest.callback_origins[fn] = info
		minetest.registered_globalsteps[i] = fn

		stepnum = stepnum + 1
	end
end

