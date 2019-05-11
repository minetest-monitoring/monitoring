
monitoring = {
  version_major = 1,
  version_minor = 1,
  metrics = {}, -- {name="", help="", type="", ...}
  settings = {
    prom_push_url = minetest.settings:get("monitoring.prometheus_push_url"),
    prom_push_key = minetest.settings:get("monitoring.prometheus_push_key") or "",
    builtin_disable = minetest.settings:get("monitoring.builtin_disable"),
    csv_enable = minetest.settings:get("monitoring.csv_enable"),
    json_enable = minetest.settings:get("monitoring.json_enable")
  }
}

local http = minetest.request_http_api()
local MP = minetest.get_modpath("monitoring")

dofile(MP.."/metrictypes/gauge.lua")
dofile(MP.."/metrictypes/counter.lua")
dofile(MP.."/metrictypes/histogram.lua")

dofile(MP.."/export/prometheus_push.lua")
dofile(MP.."/export/csv.lua")
dofile(MP.."/export/json.lua")

if not monitoring.settings.builtin_disable then
  print("[monitoring] registering builtin metrics")

  --dofile(MP.."/builtin/mods.lua")
  dofile(MP.."/builtin/version.lua")
  dofile(MP.."/builtin/abm_calls.lua")
  dofile(MP.."/builtin/auth_fail.lua")
  dofile(MP.."/builtin/chat_count.lua")
  dofile(MP.."/builtin/cheat_count.lua")
  dofile(MP.."/builtin/craft_count.lua")
  dofile(MP.."/builtin/dig_count.lua")
  dofile(MP.."/builtin/eat_count.lua")
  dofile(MP.."/builtin/generated.lua")
  dofile(MP.."/builtin/join_count.lua")
  dofile(MP.."/builtin/lag.lua")
  dofile(MP.."/builtin/lbm_calls.lua")
  dofile(MP.."/builtin/place_count.lua")
  dofile(MP.."/builtin/nodetimer_calls.lua")
  dofile(MP.."/builtin/playercount.lua")
  dofile(MP.."/builtin/protection_violation_count.lua")
  dofile(MP.."/builtin/punchplayer.lua")
  dofile(MP.."/builtin/received_fields.lua")
  dofile(MP.."/builtin/registered_count.lua")
  dofile(MP.."/builtin/time.lua")
  dofile(MP.."/builtin/uptime.lua")
end

-- external mod integration
if minetest.get_modpath("advtrains") then
  dofile(MP.."/modintegration/advtrains.lua")
end

if minetest.get_modpath("mesecons") then
  -- dofile(MP.."/modintegration/mesecons.lua")
end

if monitoring.settings.prom_push_url then
  if not http then
    error("prom_push_url defined but http not available!")
  end

  print("[monitoring] enabling prometheus push")
  monitoring.prometheus_push_init(http)
end

if monitoring.settings.csv_enable then
  print("[monitoring] enabling csv export")
  monitoring.csv_init()
end

if monitoring.settings.json_enable then
  print("[monitoring] enabling json export")
  monitoring.json_init()
end
