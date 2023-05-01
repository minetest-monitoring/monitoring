
mtt.register("serialize_prometheus_metric", function(callback)
    local m = monitoring.gauge("my_metric", "help stuff")
    assert(monitoring.metrics_mapped["my_metric"] == m)

    local str = monitoring.serialize_prometheus_metric(m)
    assert(str == "")

    m.set(1)
    str = monitoring.serialize_prometheus_metric(m)

    local lines = {}
    for s in str:gmatch("[^\n]+") do
        table.insert(lines, s)
    end

    assert(#lines == 3)
    assert(lines[1] == "# TYPE my_metric gauge")
    assert(lines[2] == "# HELP my_metric help stuff")
    assert(lines[3] == "my_metric 1")

    m = monitoring.gauge("my_metric", "help stuff", {
        labels = { x = "123" }
    })
    assert(monitoring.metrics_mapped["my_metric"] == m)
    m.set(1)

    str = monitoring.serialize_prometheus_metric(m)

    lines = {}
    for s in str:gmatch("[^\n]+") do
        table.insert(lines, s)
    end

    assert(#lines == 3)
    assert(lines[1] == "# TYPE my_metric gauge")
    assert(lines[2] == "# HELP my_metric help stuff")
    assert(lines[3] == "my_metric{x=\"123\"} 1")

    callback()
end)

mtt.register("serialize_prometheus_labels", function(callback)
    local str = monitoring.serialize_prometheus_labels(nil)
    assert(str == "")

    str = monitoring.serialize_prometheus_labels({})
    assert(str == "")

    str = monitoring.serialize_prometheus_labels({x="abc"})
    assert(str == "{x=\"abc\"}")

    str = monitoring.serialize_prometheus_labels({x="abc", y="123"})
    assert(str == "{x=\"abc\",y=\"123\"}" or str == "{y=\"123\",x=\"abc\"}")

    callback()
end)