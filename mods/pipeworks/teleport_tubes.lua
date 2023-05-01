
if not pipeworks.tptube or not pipeworks.tptube.get_db then
	-- tp-tubes not exposed, skip
	return
end

local metric_tptube_count = monitoring.gauge("pipeworks_tptube_count", "count of teleport tubes in the db")


local function job()
	local db = pipeworks.tptube.get_db()
	local count = 0
	for _ in pairs(db) do
		count = count + 1
	end
	metric_tptube_count.set(count)

	minetest.after(20, job)
end

minetest.after(0, job)
