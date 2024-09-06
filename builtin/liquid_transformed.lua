
if not minetest.registered_on_liquid_transformed then
    -- not available
    return
end

local metric_calls = monitoring.counter("liquid_transformed_calls", "count of liquid_transformed calls")
local metric_time = monitoring.counter("liquid_transformed_time", "time of liquid_transformed calls")

minetest.register_on_mods_loaded(function()
    for i, fn in ipairs(minetest.registered_on_liquid_transformed) do
        fn = metric_time.wraptime(fn)
        fn = metric_calls.wrap(fn)
        minetest.registered_on_liquid_transformed[i] = fn
    end
end)