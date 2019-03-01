

monitoring.histogram = function(name, help, buckets)
  buckets = buckets or {0.01, 0.05, 0.1, 0.2, 0.5, 1.0}
  local bucketvalues = {}
  for k,v in ipairs(buckets) do
    bucketvalues[k] = 0
  end

  local metric = {
    name = name,
    help = help,
    type = "gauge",
    buckets = buckets,
    bucketvalues = bucketvalues,
    sum = 0,
    count = 0,
    infcount = 0
  }

  table.insert(monitoring.metrics, metric)

  return {
    timer = function()
      local t0 = minetest.get_us_time()

      return {
        observe = function()
          local t1 = minetest.get_us_time()
          local us = t1 - t0
          local seconds = us / 1000000
          local matched = false

          metric.count = metric.count + 1
          metric.sum = metric.sum + seconds

          for k,v in ipairs(buckets) do
            if seconds <= v then
              metrics.bucketvalues[k] = metrics.bucketvalues[k] + 1
              matched = true
            end
          end

          if not matched then
            metric.infcount = metric.infcount + 1
          end
        end
      }
    end
  }

end
