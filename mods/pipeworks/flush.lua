function monitoring.pipeworks.flush()
	local count = 0
	for _, entity in pairs(pipeworks.luaentity.entities) do
		entity:remove()
		count = count + 1
	end
	return count
end
