local metric_nodes = monitoring.gauge("registered_node_count", "number of registered nodes")
local metric_items = monitoring.gauge("registered_items_count", "number of registered items")
local metric_entities = monitoring.gauge("registered_entities_count", "number of registered entities")
local metric_abm = monitoring.gauge("registered_abm_count", "number of registered abm's")

-- https://stackoverflow.com/questions/2705793/how-to-get-number-of-entries-in-a-lua-table
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


minetest.after(5, function()
  metric_nodes.set( tablelength(minetest.registered_nodes) )
  metric_items.set( tablelength(minetest.registered_items) )
  metric_entities.set( tablelength(minetest.registered_entities) )
  metric_abm.set( tablelength(minetest.registered_abms) )
end)
