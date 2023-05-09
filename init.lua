
monitoring = {
  version_major = 1,
  version_minor = 6,
  metrics = {}, -- {name="", help="", type="", ...}
  metrics_mapped = {}, -- metrics mapped by name as key
	storage = minetest.get_mod_storage(),
  settings = {
    prom_push_url = minetest.settings:get("monitoring.prometheus_push_url"),
    builtin_disable = minetest.settings:get_bool("monitoring.builtin_disable"),
    csv_enable = minetest.settings:get_bool("monitoring.csv_enable"),
    json_enable = minetest.settings:get_bool("monitoring.json_enable")
  }
}

local http = minetest.get_modpath("qos") and QoS and QoS(minetest.request_http_api(), 2) or minetest.request_http_api()
local MP = minetest.get_modpath("monitoring")

dofile(MP.."/metrictypes/gauge.lua")
dofile(MP.."/metrictypes/counter.lua")
dofile(MP.."/metrictypes/histogram.lua")

dofile(MP.."/chatcommands.lua")
dofile(MP.."/register.lua")
dofile(MP.."/sampling.lua")

loadfile(MP.."/export/prometheus_push.lua")(http)
dofile(MP.."/export/csv.lua")
dofile(MP.."/export/json.lua")

if not monitoring.settings.builtin_disable then
  print("[monitoring] registering builtin metrics")

  dofile(MP.."/builtin/version.lua")
  dofile(MP.."/builtin/abm_calls.lua")
  dofile(MP.."/builtin/api.lua")
  dofile(MP.."/builtin/auth_fail.lua")
  dofile(MP.."/builtin/chat_count.lua")
  dofile(MP.."/builtin/cheat_count.lua")
  dofile(MP.."/builtin/craft_count.lua")
  dofile(MP.."/builtin/dig_count.lua")
	dofile(MP.."/builtin/eat_count.lua")
  dofile(MP.."/builtin/forceload_blocks.lua")
  dofile(MP.."/builtin/after.lua")
  dofile(MP.."/builtin/generated.lua")
  dofile(MP.."/builtin/globalstep.lua")
  dofile(MP.."/builtin/jit.lua")
  dofile(MP.."/builtin/join_count.lua")
  dofile(MP.."/builtin/lag.lua")
  dofile(MP.."/builtin/lbm_calls.lua")
  dofile(MP.."/builtin/leave_count.lua")
  dofile(MP.."/builtin/luamem.lua")
  dofile(MP.."/builtin/place_count.lua")
  dofile(MP.."/builtin/nodetimer_calls.lua")
  dofile(MP.."/builtin/on_joinplayer.lua")
  dofile(MP.."/builtin/on_prejoinplayer.lua")
  dofile(MP.."/builtin/on_step.lua")
  dofile(MP.."/builtin/playercount.lua")
  dofile(MP.."/builtin/protection_violation_count.lua")
  dofile(MP.."/builtin/protection.lua")
  dofile(MP.."/builtin/punchplayer.lua")
  dofile(MP.."/builtin/received_fields.lua")
  dofile(MP.."/builtin/registered_count.lua")
  dofile(MP.."/builtin/ticks.lua")
  dofile(MP.."/builtin/time.lua")
  dofile(MP.."/builtin/uptime.lua")
  dofile(MP.."/builtin/settings.lua")
end

if minetest.get_modpath("technic") then
  print("[monitoring] enabling technic integrations")
  dofile(MP.."/mods/technic/abm.lua")
  dofile(MP.."/mods/technic/quarry.lua")
  dofile(MP.."/mods/technic/switch.lua")
  dofile(MP.."/mods/technic/technic_run.lua")
end

if minetest.get_modpath("basic_machines") then
  print("[monitoring] enabling basic_machines integrations")
  dofile(MP.."/mods/basic_machines/init.lua")
end

if minetest.get_modpath("digilines") then
  print("[monitoring] enabling digilines integrations")
  dofile(MP.."/mods/digilines/init.lua")
  dofile(MP.."/mods/digilines/metric_controller.lua")
end

if minetest.get_modpath("mesecons") then
  print("[monitoring] enabling mesecons integrations")
  dofile(MP.."/mods/mesecons/action_on.lua")
  dofile(MP.."/mods/mesecons/functions.lua")
  dofile(MP.."/mods/mesecons/globals.lua")
  dofile(MP.."/mods/mesecons/luac.lua")
  dofile(MP.."/mods/mesecons/queue.lua")
end

if minetest.get_modpath("pipeworks") then
  print("[monitoring] enabling pipeworks integrations")
  dofile(MP.."/mods/pipeworks/init.lua")
  dofile(MP.."/mods/pipeworks/entity_count.lua")
  dofile(MP.."/mods/pipeworks/expiration.lua")
  dofile(MP.."/mods/pipeworks/flush.lua")
  dofile(MP.."/mods/pipeworks/filter_action_on.lua")
  dofile(MP.."/mods/pipeworks/globalsteps.lua")
  dofile(MP.."/mods/pipeworks/metrics.lua")
  dofile(MP.."/mods/pipeworks/can_go.lua")
  dofile(MP.."/mods/pipeworks/teleport_tubes.lua")
  dofile(MP.."/mods/pipeworks/tube_inject_item.lua")
  dofile(MP.."/mods/pipeworks/inject_limiter.lua")
  dofile(MP.."/mods/pipeworks/chatcommands.lua")
end

if monitoring.settings.prom_push_url then
  if not http then
    error("prom_push_url defined but http not available!")
  end

  print("[monitoring] enabling prometheus push")
  monitoring.prometheus_push_init()
end

if monitoring.settings.csv_enable then
  print("[monitoring] enabling csv export")
  monitoring.csv_init()
end

if monitoring.settings.json_enable then
  print("[monitoring] enabling json export")
  monitoring.json_init()
end

if minetest.get_modpath("mtt") and mtt.enabled then
  -- test utils
  dofile(MP.."/init.spec.lua")
  dofile(MP.."/metrictypes/counter.spec.lua")
  dofile(MP.."/export/prometheus_push.spec.lua")
end