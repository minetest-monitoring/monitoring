function monitoring.serialize_labels(labels)

    if not labels or type(labels) ~= "table" then
        return ""
    end

    local str = ""

    local label_names = {}
    for k, _ in pairs(labels) do table.insert(label_names, k) end
    table.sort(label_names)

    for _, k in ipairs(label_names) do
        local v = labels[k]
        local vstr = v and tostring(v) or ""
        if v ~= nil and #vstr > 0 then
            str = str .. k .. "=\"" .. vstr .. "\","
        end
    end

	if #str > 0 then
		return "{" .. string.sub(str, 1, #str-1) .. "}"
	else
		return ""
	end
end


 function monitoring.register_metric(metric)

    local metric_family = monitoring.metrics[metric.name]

    if metric_family then
        -- Metric already exists, checks
        if metric_family.type ~= metric.type then
            error("Metric type mismatch for " .. metric.name .. ": " .. metric_family.type .. " vs " .. metric.type)
        end
        if metric_family.help ~= metric.help then
            error("Metric help mismatch for " .. metric.name .. ": " .. metric_family.help .. " vs " .. metric.help)
        end
    else
        metric_family = {
            name = metric.name,
            help = metric.help,
            type = metric.type,
            unit = metric.options and metric.options.unit or nil,
            metrics = {}
        }
        -- Create a new metric family
        monitoring.metrics[metric.name] = metric_family
    end

    local labels = metric.labels or {}
    local labels_str = monitoring.serialize_labels(labels)

    local res_metric = metric_family.metrics[labels_str]
    if not res_metric then
        res_metric =  metric
        metric_family.metrics[labels_str] = metric
    end

    if not monitoring.metrics_mapped[metric.name] then
        monitoring.metrics_mapped[metric.name] = res_metric
    end

    return res_metric

end
