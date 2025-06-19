local http = ...

local get_us_time = minetest.get_us_time
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

function monitoring.serialize_prometheus_metric_family(metric_family)
	local data = ""

	data = data .. "# TYPE " .. metric_family.name .. " " .. metric_family.type .. "\n"
	data = data .. "# HELP " .. metric_family.name .. " " .. metric_family.help .. "\n"
	if metric_family.unit then
		data = data .. "# UNIT " .. metric_family.name .. " " .. metric_family.unit .. "\n"
	end

	for serialized_labels, metric in pairs(metric_family.metrics) do
		data = data .. monitoring.serialize_prometheus_metric(serialized_labels, metric)
	end

	return data
end

function monitoring.serialize_prometheus_metric(serialized_labels, metric)
	local data = ""
	if metric.value or metric.value == 0 then
		if metric.value ~= nil then
		if metric.type == "gauge" or metric.type == "counter" then
			data = data .. metric.name .. serialized_labels .. " " .. metric.value .. "\n"
			if metric.options and metric.options.autoflush then
				-- reset metric value on export
				metric.value = nil
			end
		end
		end

		if metric.type == "histogram" then
			for k, bucket in ipairs(metric.buckets) do
				data = data .. metric.name .. "_bucket{le=\"" .. bucket  .. "\"}".. serialized_labels .. " " .. metric.bucketvalues[k] .. "\n"
			end
			data = data .. metric.name .. "_bucket{le=\"+Inf\"}".. serialized_labels .. " " .. metric.infcount .. "\n"
			data = data .. metric.name .. "_sum".. serialized_labels .. " " .. metric.sum .. "\n"
			data = data .. metric.name .. "_count".. serialized_labels .. " " .. metric.count .. "\n"
		end
	end
	return data
end

local function push_metrics()
	local t0 = minetest.get_us_time()

	local data = ""
	for _, metric_family in ipairs(monitoring.metrics) do
		data = data .. monitoring.serialize_prometheus_metric_family(metric_family)
	end

	local t_collect_us = get_us_time() - t0
	export_metric_collect_time.set(t_collect_us / 1000000)
	t0 = get_us_time()

	export_size.inc(string.len(data))

	-- https://www.nginx.com/blog/deploying-nginx-plus-as-an-api-gateway-part-1/
	http.fetch({
		url = monitoring.settings.prom_push_url,
		extra_headers = { "Content-Type: text/plain" },
		post_data = data,
		timeout = 5
	}, function(res)
			local t_post_us = get_us_time() - t0
			export_metric_post_time.set(t_post_us / 1000000)
			if res.code >= 400 then
				minetest.log("error", "[monitoring] prom-push returned code " .. res.code .. " data: " .. res.data)
			end
	end)
end


function monitoring.prometheus_push_init()
	local timer = 0
	minetest.register_globalstep(function(dtime)
		timer = timer + dtime
		if timer < 5 then return end
		timer=0

		push_metrics()
	end)
end
