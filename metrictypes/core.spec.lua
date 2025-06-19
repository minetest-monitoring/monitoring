mtt.register("serialize_labels", function(callback)
    local str = monitoring.serialize_labels(nil)
    assert(str == "")

    str = monitoring.serialize_labels({})
    assert(str == "")

    str = monitoring.serialize_labels({x="abc"})
    assert(str == "{x=\"abc\"}")

    str = monitoring.serialize_labels({x="abc", y="123"})
    assert(str == "{x=\"abc\",y=\"123\"}")

    callback()
end)