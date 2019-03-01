local max_metric = monitoring.gauge("max_lag", "max lag in seconds")
local min_metric = monitoring.gauge("min_lag", "min lag in seconds")

local min_lag
local max_lag

min_lag = 10
max_lag = 0

minetest.register_globalstep(function(dtime)
	if dtime > max_lag then
		max_lag = dtime
	end

	if dtime < min_lag then
		min_lag = dtime
	end
end)

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 5 then return end
	timer=0

  max_metric.set( max_lag )
	min_metric.set( min_lag )

	min_lag = 10
	max_lag = 0
end)
