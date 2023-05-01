
mtt.register("counter", function(callback)

    local my_fn_callcount = 0
    local my_fn = function(a, b, c)
        my_fn_callcount = my_fn_callcount + 1
        return a+1, b+1, c+1
    end

    local c = monitoring.counter("my_name", "something helpful")
    my_fn = c.wraptime(my_fn)

    local x, y, z = my_fn(1,2,3)
    assert(my_fn_callcount == 1)
    assert(x == 2)
    assert(y == 3)
    assert(z == 4)

    callback()
end)