
if minetest.settings:get_bool("monitoring.verbose") then
  monitoring.wrap_global({"minetest", "add_entity"}, "add_entity")
  monitoring.wrap_global({"minetest", "add_item"}, "add_item")
  monitoring.wrap_global({"minetest", "add_node"}, "add_node")

  monitoring.wrap_global({"minetest", "add_particle"}, "add_particle")
  monitoring.wrap_global({"minetest", "add_particlespawner"}, "add_particlespawner")

  monitoring.wrap_global({"minetest", "get_node"}, "get_node")
  monitoring.wrap_global({"minetest", "get_node_or_nil"}, "get_node_or_nil")
  monitoring.wrap_global({"minetest", "get_meta"}, "get_meta")


  monitoring.wrap_global({"minetest", "find_node_near"}, "find_node_near")
  monitoring.wrap_global({"minetest", "find_nodes_in_area"}, "find_nodes_in_area")

  monitoring.wrap_global({"minetest", "swap_node"}, "swap_node")
  monitoring.wrap_global({"minetest", "load_area"}, "load_area")
  monitoring.wrap_global({"minetest", "get_voxel_manip"}, "get_voxel_manip")

  monitoring.wrap_global({"minetest", "get_objects_inside_radius"}, "get_objects_inside_radius")

  monitoring.wrap_global({"minetest", "set_node"}, "set_node")
  monitoring.wrap_global({"minetest", "find_path"}, "find_path")

  monitoring.wrap_global({"minetest", "check_for_falling"}, "check_for_falling")
end
