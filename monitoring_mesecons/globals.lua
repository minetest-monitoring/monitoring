

monitoring.wrap_global({"mesecon", "queue", "add_action"}, "mesecons_queue_action_add")
local execute_calls_metric = monitoring.wrap_global({"mesecon", "queue", "execute"}, "mesecons_queue_execute")

if monitoring.settings.handle_errors then
  -- enable error handling in mesecons queue
  local old_execute = mesecon.queue.execute
  mesecon.queue.execute = function(action)
    monitoring.protected_call(execute_calls_metric, function()
      old_execute(action)
    end, action.pos)
  end
end

if minetest.settings:get_bool("monitoring.mesecons.verbose") then

  monitoring.wrap_global({"mesecon", "get_node_force"}, "mesecons_get_node_force")
  monitoring.wrap_global({"mesecon", "activate"}, "mesecons_activate")
  monitoring.wrap_global({"mesecon", "deactivate"}, "mesecons_deactivate")
  monitoring.wrap_global({"mesecon", "turnon"}, "mesecons_turnon")
  monitoring.wrap_global({"mesecon", "turnoff"}, "mesecons_turnoff")
  monitoring.wrap_global({"mesecon", "changesignal"}, "mesecons_changesignal")
  monitoring.wrap_global({"mesecon", "swap_node_force"}, "swap_node_force")

  monitoring.wrap_global({"mesecon", "vm_begin"}, "mesecons_vm_begin")
  monitoring.wrap_global({"mesecon", "vm_abort"}, "mesecons_vm_abort")
  monitoring.wrap_global({"mesecon", "vm_commit"}, "mesecons_vm_commit")

end
