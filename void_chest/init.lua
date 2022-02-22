--Load support MT game translator
local S = minetest.get_translator("void_chest")

-- Register the void chest.
minetest.register_node("void_chest:void_chest", {
	description = S("Void Chest (Ender Chest Minecraft)"),
	tiles = {"void_chest_top.png", "void_chest_top.png", "void_chest_side.png",
		"void_chest_side.png", "void_chest_side.png", "void_chest_front.png"},
	paramtype2 = "facedir",
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2,},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local timer = minetest.get_node_timer(pos)
		timer:start(.1) -- in seconds
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
				"size[8,9]"..
				default.gui_bg ..
				default.gui_bg_img ..
				default.gui_slots ..
				"list[current_player;void_chest:void_chest;0,0.3;8,4;]"..
				"list[current_player;main;0,4.85;8,1;]" ..
				"list[current_player;main;0,6.08;8,3;8]" ..
				"listring[current_player;void_chest:void_chest]" ..
				"listring[current_player;main]" ..
				default.get_hotbar_bg(0,4.85))

		meta:set_string("infotext", S("Void Chest"))
	end,

	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
				minetest.log("action", player:get_player_name()..
				" moves stuff in void chest at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
				minetest.log("action", player:get_player_name()..
				" moves stuff to void chest at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
				minetest.log("action", player:get_player_name()..
				" takes stuff from void chest at "..minetest.pos_to_string(pos))
	end,
	on_timer = function(pos)
	
        return true
    end,

})

-- Register crafting recipes.
-- If the "magic_materials" mod is present we use a more accurate recipe.
if minetest.get_modpath("magic_materials") then
	minetest.register_craft({
		output = 'void_chest:void_chest',
		recipe = {
			{'default:steelblock','magic_materials:void_rune','default:steelblock'},
			{'magic_materials:void_rune','default:chest_locked','magic_materials:void_rune'},
			{'default:steelblock','magic_materials:void_rune','default:steelblock'}
		}
	})
else -- Else we use a recipe using "default" to avoid a hard dependency.
minetest.register_craft({
		output = 'void_chest:void_chest',
		recipe = {
			{'default:steelblock','default:obsidian_block','default:steelblock'},
			{'default:obsidian_block','default:chest','default:obsidian_block'},
			{'default:steelblock','default:obsidian_block','default:steelblock'}
		}
	})
end
-- Create a detached void chest inventory when players connect.
minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	inv:set_size("void_chest:void_chest", 8*4)
end)
