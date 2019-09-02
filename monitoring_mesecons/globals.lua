

monitoring.wrap_global({"mesecon", "queue", "add_action"}, "mesecons_queue_action_add")
monitoring.wrap_global({"mesecon", "queue", "execute"}, "mesecons_queue_execute")
monitoring.wrap_global({"mesecon", "queue", "get_node_force"}, "mesecons_queue_get_node_force")
monitoring.wrap_global({"mesecon", "activate"}, "mesecons_activate")
monitoring.wrap_global({"mesecon", "deactivate"}, "mesecons_deactivate")
monitoring.wrap_global({"mesecon", "turnon"}, "mesecons_turnon")
monitoring.wrap_global({"mesecon", "turnoff"}, "mesecons_turnoff")
monitoring.wrap_global({"mesecon", "changesignal"}, "mesecons_changesignal")

