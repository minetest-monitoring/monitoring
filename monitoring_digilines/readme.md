
Monitoring, digilines component

# Overview

## metric_controller

Usage:

```lua
if event.type == "program" then
  -- query metric by its name
  digiline_send("ctrl_channel", "pipeworks_entity_count")
end

if event.type == "digiline" and event.channel == "ctrl_channel" then
  print("Pipeworks entities: " .. event.msg)
end
```

# License

* textures/monitoring_controller_top.png
  * CC BY-SA 3.0 https://cheapiesystems.com/git/digistuff
