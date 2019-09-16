
if not minetest.get_modpath("digtron") then
        print("[monitoring] digtron extension not loaded")
        return
else
        print("[monitoring] digtron extension loaded")
end


local metric_move_cycle = monitoring.counter(
	"digtron_move_cycle_count",
	"number of digtron move cycles"
)

local metric_dig_cycle = monitoring.counter(
	"digtron_dig_cycle_count",
	"number of digtron dig cycles"
)

local metric_dig_cycle_time = monitoring.counter(
	"digtron_dig_cycle_time",
	"time of digtron dig cycles"
)


local metric_layout_create_time = monitoring.counter(
	"digtron_layout_time",
	"time of DigtronLayout.create calls"
)

local metric_layout_create_calls = monitoring.counter(
	"digtron_layout_calls",
	"numer of DigtronLayout.create calls"
)


digtron.execute_move_cycle = metric_move_cycle.wrap(digtron.execute_move_cycle)
digtron.execute_dig_cycle = metric_dig_cycle.wrap( metric_dig_cycle_time.wraptime(digtron.execute_dig_cycle) )
DigtronLayout.create = metric_layout_create_calls.wrap( metric_layout_create_time.wraptime(DigtronLayout.create) )
