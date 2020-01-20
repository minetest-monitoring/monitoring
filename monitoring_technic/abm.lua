
local max_time_metric = monitoring.gauge(
	"technic_switching_station_abm_time_max",
	"max time of technic switch abm calls",
	{ autoflush=true }
)


for _, abm in ipairs(minetest.registered_abms) do

  if abm.label == "Switching Station" then
    print("[monitoring] wrapping switching station abm")

    -- max time peaks for switching stations
    local old_action = abm.action
    abm.action = function(...)

	    local t0 = minetest.get_us_time()
	    old_action(...)
	    local t1 = minetest.get_us_time()
	    local diff = t1 -t0

	    max_time_metric.setmax(diff)
    end

    abm.action = monitoring
      .counter("technic_switching_station_abm_count", "number of technic switch abm calls")
      .wrap(abm.action)

    abm.action = monitoring
      .counter("technic_switching_station_abm_time", "time of technic switch abm calls")
      .wraptime(abm.action)
  end

	if abm.label == "Radiation damage" then
		abm.action = monitoring
      .counter("technic_radiation_abm_count", "number of radiation abm calls")
      .wrap(abm.action)

    abm.action = monitoring
      .counter("technic_radiation_abm_time", "time of radiation abm calls")
      .wraptime(abm.action)
	end


end
