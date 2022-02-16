-- Register the void chest.
minetest.register_node("void_chest:void_chest", {
	description = "" ..core.colorize("#660099","Void Chest\n") ..core.colorize("#FFFFFF", "Use the power of the void to store your items."),
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

		meta:set_string("infotext", "Void Chest")
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
	-- Particles for the void effect, implemented by MisterE, thanks! 
		for i=1,10 do -- number of particles spawned every on_timer
			local vel_scalar = math.random(0,5)/10 -- multiplied by the particle's velocity vector of 1
			local accel_scalar = math.random(1,5)/10 -- multiplied by the particle's accel vector of 1
			local expir = math.random(1,10) -- number of sec particle will last, if it doesn't hit a node
			local particle_pos = {x=pos.x + ((math.random(-10,10)/10)*(math.random(6,15)/10)), y=pos.y + ((math.random(-10,10)/10)*(math.random(6,15)/10)), z=pos.z+ ((math.random(-10,10)/10)*(math.random(6,15)/10))}
			local part_vel = vector.direction(particle_pos, pos)
			part_vel = {x= vel_scalar*part_vel.x, y= vel_scalar*part_vel.y, z= vel_scalar*part_vel.z}
			local part_accel = vector.direction(particle_pos, pos)
			part_accel = {x= accel_scalar*part_accel.x, y= accel_scalar*part_accel.y, z= accel_scalar*part_accel.z}
			minetest.add_particle({
		    pos = particle_pos,
		    velocity = part_vel,
		    acceleration = part_accel,
		    expirationtime = expir,
		    size = math.random(7,10)/10,
		    collisiondetection = true,
		    collision_removal = true,
		    vertical = false,
		    texture = "void_chest_void_particle.png",
		    glow = 5,
			})
		end


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
			{'default:obsidian_block','default:chest_locked','default:obsidian_block'},
			{'default:steelblock','default:obsidian_block','default:steelblock'}
		}
	})
end
-- Create a detached void chest inventory when players connect.
minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	inv:set_size("void_chest:void_chest", 8*4)
end)
