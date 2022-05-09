
local get_us_time = minetest.get_us_time
local iterations = 100000
local count = iterations
local start = get_us_time()

while count > 0 do
	get_us_time()
	count = count - 1
end

local diff = get_us_time() - start

print("[monitoring] sampling: " .. iterations .. " calls took " .. diff .. " us")
