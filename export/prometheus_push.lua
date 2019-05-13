local export_metric_collect_time = monitoring.gauge(
  "prom_export_collect_time",
  "export collect time"
)

local export_metric_post_time = monitoring.gauge(
  "prom_export_post_time",
  "export post time"
)

local export_size = monitoring.counter(
  "prom_export_size_count",
  "byte count of the prometheus export"
)

local http

local push_metrics = function()

  local t0 = minetest.get_us_time()

  local data = ""

  for _, metric in ipairs(monitoring.metrics) do
    data = data .. "# TYPE " .. metric.name .. " " .. metric.type .. "\n"
    data = data .. "# HELP " .. metric.name .. " " .. metric.help .. "\n"

    if metric.value ~= nil then
      if metric.type == "gauge" or metric.type == "counter" then
        data = data .. metric.name .. " " .. metric.value .. "\n"
      end
    end

    if metric.type == "histogram" then
      for k, bucket in ipairs(metric.buckets) do
        data = data .. metric.name .. "_bucket{le=\"" .. bucket  .. "\"} " .. metric.bucketvalues[k] .. "\n"
      end
      data = data .. metric.name .. "_bucket{le=\"+Inf\"} " .. metric.infcount .. "\n"
      data = data .. metric.name .. "_sum " .. metric.sum .. "\n"
      data = data .. metric.name .. "_count " .. metric.count .. "\n"
    end

  end

  local t_collect_us = minetest.get_us_time() - t0
  export_metric_collect_time.set(t_collect_us / 1000000)
  t0 = minetest.get_us_time()


  --print(data)
  export_size.inc(string.len(data))

  -- https://www.nginx.com/blog/deploying-nginx-plus-as-an-api-gateway-part-1/
  http.fetch({
    url = monitoring.settings.prom_push_url,
    extra_headers = { "Content-Type: text/plain", "apikey", monitoring.settings.prom_push_key },
    post_data = data,
    timeout = 1
  }, function(res)
    if res.succeeded and res.code == 200 then
      --OK, no need to do anything... :P

      local t_post_us = minetest.get_us_time() - t0
      export_metric_post_time.set(t_post_us / 1000000)
    end
  end)
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
