

local settings = {
	"max_packets_per_iteration",

	-- possibly live-setting when client relogs
	"max_simultaneous_block_sends_per_client",

	"max_users",
	"active_block_range",
	"active_object_send_range_blocks",
	"max_block_send_distance",
	"full_block_send_enable_min_time_from_building"
}

for _, setting in ipairs(settings) do
	local name = setting:gsub("[.]", "_")

	local metric = monitoring.gauge("setting_" .. name, "setting: " .. setting)

	local value = minetest.settings:get(setting)

	if value then
		metric.set(tonumber(value))
	end
end
