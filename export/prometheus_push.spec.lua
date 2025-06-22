
mtt.register("serialize_prometheus_metric_family", function(callback)
    local m = monitoring.gauge("my_metric", "help stuff")
    assert(monitoring.metrics_mapped["my_metric"] == m)

    local str = monitoring.serialize_prometheus_metric("{}", m)
    assert(str == "")

    m.set(1)
    str = monitoring.serialize_prometheus_metric("{}", m)

    local lines = {}
    for s in str:gmatch("[^\n]+") do
        table.insert(lines, s)
    end

    assert(#lines == 1)
    assert(lines[1] == "my_metric{} 1")

    local m2 = monitoring.gauge("my_metric", "help stuff", {
        labels = { x = "123" }
    })
    assert(monitoring.metrics_mapped["my_metric"] == m)
    m.set(1)

    str = monitoring.serialize_prometheus_metric("{x=\"123\"}", m)

    lines = {}
    for s in str:gmatch("[^\n]+") do
        table.insert(lines, s)
    end

    assert(#lines == 1)
    assert(lines[1] == "my_metric{x=\"123\"} 1")

    callback()
end)



mtt.register("serialize_prometheus_metric", function(callback)
    local m = monitoring.gauge("my_metric2", "help stuff")
    assert(monitoring.metrics_mapped["my_metric2"] == m)

    local str = monitoring.serialize_prometheus_metric("{}", m)
    assert(str == "")

    m.set(1)
    str = monitoring.serialize_prometheus_metric("{}", m)

    local lines = {}
    for s in str:gmatch("[^\n]+") do
        table.insert(lines, s)
    end

    assert(#lines == 1)
    assert(lines[1] == "my_metric2{} 1")

    local m2 = monitoring.gauge("my_metric2", "help stuff", {
        labels = { x = "123" }
    })
    assert(monitoring.metrics_mapped["my_metric2"] == m)
    m2.set(1)

    str = monitoring.serialize_prometheus_metric("{x=\"123\"}", m2)

    lines = {}
    for s in str:gmatch("[^\n]+") do
        table.insert(lines, s)
    end

    assert(#lines == 1)
    assert(lines[1] == "my_metric2{x=\"123\"} 1")

    callback()
end)
