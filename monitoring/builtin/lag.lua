local max_metric = monitoring.gauge("max_lag", "max lag in seconds", { autoflush=true })
local min_metric = monitoring.gauge("min_lag", "min lag in seconds", { autoflush=true })
local avg_metric = monitoring.gauge("avg_lag", "avg lag in seconds")

local lag_histogram = monitoring.histogram("lag", "lag histogram",
  {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0})


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
        local arrayoutput2 = explode("=",arrayoutput[4])
        return arrayoutput2[1]
end

local timer = 0
local last_call_t = minetest.get_us_time()

minetest.register_globalstep(function(dtime)
	-- calculate own delta-time
	local now = minetest.get_us_time()
	local deltat = (now - last_call_t) / 1000000

	-- swap timestamps
	last_call_t = now

	lag_histogram.observe(deltat)

	-- executed on every step
	max_metric.setmax( deltat )
	min_metric.setmin( deltat )

	timer = timer + deltat
	if timer < 5 then return end
	timer=0

	-- executed every few seconds
	avg_metric.set( tonumber(get_max_lag()) )
end)
