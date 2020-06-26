
local iterations = 100000
local count = iterations
local start = minetest.get_us_time()

while count > 0 do
  minetest.get_us_time()
  count = count - 1
end

local diff = minetest.get_us_time() - start

print("[monitoring] sampling: " .. iterations .. " calls took " .. diff .. " us")
