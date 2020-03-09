

minetest.register_node("monitoring_digilines:metric_controller", {
	description = "Monitoring metric controller",
	groups = {
    cracky=3
  },

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec","field[channel;Channel;${channel}")
	end,

	tiles = {
		"monitoring_controller_top.png",
		"jeija_microcontroller_bottom.png",
		"jeija_microcontroller_sides.png",
		"jeija_microcontroller_sides.png",
		"jeija_microcontroller_sides.png",
		"jeija_microcontroller_sides.png"
	},

	inventory_image = "monitoring_controller_top.png",
	drawtype = "nodebox",
	selection_box = {
		--From luacontroller
		type = "fixed",
		fixed = { -8/16, -8/16, -8/16, 8/16, -5/16, 8/16 },
	},
	node_box = {
		--From Luacontroller
		type = "fixed",
		fixed = {
			{-8/16, -8/16, -8/16, 8/16, -7/16, 8/16}, -- Bottom slab
			{-5/16, -7/16, -5/16, 5/16, -6/16, 5/16}, -- Circuit board
			{-3/16, -6/16, -3/16, 3/16, -5/16, 3/16}, -- IC
		}
	},

	paramtype = "light",
	sunlight_propagates = true,

	on_receive_fields = function(pos, _, fields, sender)
		local name = sender:get_player_name()
		if minetest.is_protected(pos,name) and not minetest.check_player_privs(name,{protection_bypass=true}) then
			minetest.record_protection_violation(pos,name)
			return
		end
		local meta = minetest.get_meta(pos)
		if fields.channel then meta:set_string("channel",fields.channel) end
	end,

	digiline = {
		receptor = {},
		effector = {
			action = function(pos, _, channel, msg)
					local meta = minetest.get_meta(pos)
					if meta:get_string("channel") ~= channel or type(msg) ~= "string" then
            return
          end

          local value = monitoring.metrics_mapped[msg]

          if value then
            digiline:receptor_send(pos, digiline.rules.default, channel, value)
          end
				end
		}
	}
})
