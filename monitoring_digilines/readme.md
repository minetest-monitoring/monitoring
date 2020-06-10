
Monitoring, digilines component

# Overview

## metric_controller

Usage:

Reading:
```lua
if event.type == "program" then
  -- query metric by its name
  digiline_send("ctrl_channel", "pipeworks_entity_count")
end

if event.type == "digiline" and event.channel == "ctrl_channel" then
  print("Pipeworks entities: " .. event.msg)
end
```

Writing:
```lua
digiline_send("channel", {
	metric = "ingame_lua_tube_mese",
	help = "my mese lua tube count"
	counter = true,
	increment = true,
	value = 20
})
```

# License

* textures/monitoring_controller_top.png
  * CC BY-SA 3.0 https://cheapiesystems.com/git/digistuff
