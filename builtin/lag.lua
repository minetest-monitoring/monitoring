local max_metric = monitoring.gauge("max_lag", "max lag in seconds")
local min_metric = monitoring.gauge("min_lag", "min lag in seconds")
local avg_metric = monitoring.gauge("avg_lag", "avg lag in seconds")

local min_lag
local max_lag

min_lag = 10
max_lag = 0

local function explode(sep, input)
        local t={}
        local i=0
        for k in string.gmatch(input,"([^"..sep.."]+)") do
            t[i]=k
            i=i+1
        end
        return t
end
local function get_max_lag()
        local arrayoutput = explode(", ",minetest.get_server_status())
        local arrayoutput = explode("=",arrayoutput[4])
        return arrayoutput[1]
end

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
	avg_metric.set( tonumber(get_max_lag()) )

	min_lag = 10
	max_lag = 0
end)
