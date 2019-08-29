

--[[
monitoring.wrap_global({"minetest", "is_protected"}, "minetest_is_protected")
--]]

monitoring.wrap_global = function(path, prefix)
	local desc = table.concat(path, ".")
	local metric_calls = monitoring.counter(prefix .. "_calls", "count of " .. desc .. " calls")
	local metric_time = monitoring.counter(prefix .. "_time", "time of " .. desc .. " calls")

	local obj = _G
	local field = ""

	for i, part in ipairs(path) do
		if i < #path then
			obj = obj[part]
		else
			field = part
		end
	end

	local wrapped_time = metric_time.wraptime(obj[field])
	local wrapped_count = metric_calls.wrap(wrapped_time)

	obj[field] = wrapped_count
end
