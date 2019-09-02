

-- function metrics
local metric_function_change_count = monitoring.counter("mesecons_function_change_count", "number of change function executes")
local metric_function_activate_count = monitoring.counter("mesecons_function_activate_count", "number of activate function executes")
local metric_function_deactivate_count = monitoring.counter("mesecons_function_deactivate_count", "number of deactivate function executes")
local metric_function_receptor_on_count = monitoring.counter("mesecons_function_receptor_on_count", "number of receptor_on function executes")
local metric_function_receptor_off_count = monitoring.counter("mesecons_function_receptor_off_count", "number of receptor_off function executes")
local metric_function_lc_interrupt_count = monitoring.counter("mesecons_function_lc_interrupt_count", "number of lc_interrupt function executes")
local metric_function_lc_digiline_relay_count = monitoring.counter("mesecons_function_lc_digiline_relay_count", "number of lc_digiline_relay function executes")
local metric_function_other = monitoring.counter("mesecons_function_other", "number of other function executes")

local old_execute = mesecon.queue.execute
mesecon.queue.execute = function(self, action)
	if action.func == "change" then
		metric_function_change_count.inc()
	elseif action.func == "lc_interrupt" then
		metric_function_lc_interrupt_count.inc()
	elseif action.func == "lc_digiline_relay" then
		metric_function_lc_digiline_relay_count.inc()
	elseif action.func == "deactivate" then
		metric_function_deactivate_count.inc()
	elseif action.func == "activate" then
		metric_function_activate_count.inc()
	elseif action.func == "receptor_on" then
		metric_function_receptor_on_count.inc()
	elseif action.func == "receptor_off" then
		metric_function_receptor_off_count.inc()
	else
		metric_function_other.inc()
	end

	old_execute(self, action)
end
