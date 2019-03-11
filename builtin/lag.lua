local max_metric = monitoring.gauge("max_lag", "max lag in seconds")
local min_metric = monitoring.gauge("min_lag", "min lag in seconds")
local avg_metric = monitoring.gauge("avg_lag", "avg lag in seconds")

local lag_histogram = monitoring.histogram("lag", "lag histogram",
  {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0})


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
	if deltat > max_lag then
		max_lag = deltat
	end

	if deltat < min_lag then
		min_lag = deltat
	end

	timer = timer + deltat
	if timer < 5 then return end
	timer=0

  -- executed every few seconds
  max_metric.set( max_lag )
	min_metric.set( min_lag )
	avg_metric.set( tonumber(get_max_lag()) )

	min_lag = 10
	max_lag = 0
end)
