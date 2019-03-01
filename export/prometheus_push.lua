local export_metric = monitoring.histogram("prom_export_latency", "latency of the export",
  {0.001, 0.005, 0.01, 0.02, 0.1})

local http

local push_metrics = function()
  local timer = export_metric.timer()
  local data = ""

  for _, metric in ipairs(monitoring.metrics) do
    data = data + "# TYPE " + metric.name + " " + metric.type + "\n"
    data = data + "# HELP " + metric.name + " " + metric.help + "\n"

    if metric.value ~= nil then
      if metric.type == "gauge" or metric.type == "counter" then
        data = data + metric.name + " " + metric.value + "\n"
      end
    end

    if metric.type = "histogram" then
      for k, bucket in ipairs(metric.buckets) do
        data = data + metric.name + "_bucket{le=\""+ bucket +"\"} " + metric.bucketvalues[k] + "\n"
      end
      data = data + metric.name + "_bucket{le=\"+Inf\"} " + metric.infcount + "\n"
      data = data + metric.name + "_sum " + metric.sum + "\n"
      data = data + metric.name + "_count " + metric.count + "\n"
    end

  end

  http.fetch({
    url = monitoring.settings.prom_push_url,
    extra_headers = { "Content-Type: text/plain" },
    post_data = data,
    timeout = 1
  }, function(res)
    if res.succeeded and res.code == 200 then
      --OK, no need to do anything... :P
    end
  end)

  -- only measure sync time
  timer.fetch()
end


monitoring.prometheus_push_init = function(_http)
  http = _http

  local timer = 0
  minetest.register_globalstep(function(dtime)
  	timer = timer + dtime
  	if timer < 5 then return end
  	timer=0

    push_metrics()
  end)
end
