-- commandblockmod (commandblock 1.0.0.0 mod)

-- Definitions made by this mod that other mods can use too
commandblockmod = {}

-- Load other files
--dofile(minetest.get_modpath("commandblocks").."/functions.lua")

local command_block_formspec = "size[8,3]"..
	"textarea[0,0;10,1;command_input;command_input;]"..
	"textarea[0,1;10,1;command_output;command_output;]"..
	"button[0,2;3,1;button_done;button_done]"..
	"button_exit[5,2;3,1;button_cancel;button_cancel]"
local elements = {"command_input", "command_output", "button_cancel", "button_done"}

-- Set a noticeable inventory formspec for players
minetest.register_on_joinplayer(function(player)
	local cb = function(player)
		minetest.chat_send_player(player:get_player_name(), "Command Block mod made by: jtrent238")
	end
	minetest.after(2.0, cb, player)
end)

minetest.register_node("commandblocks:BlockCommandBlock", {
	description = "Command Block",
	tiles = {"BlockCommandBlock.png"},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	--sounds = default.node_sound_wood_defaults(),

on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", command_block_formspec)
		meta:set_string("infotext", "Command Block")
		local inv = meta:get_inventory()
		for _, element in pairs(elements) do
			inv:set_size("armor_"..element, 1)
		end
	end,
	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		for _, element in pairs(elements) do
			if not inv:is_empty("armor_"..element) then
				return false
			end
		end
		return true
	end,
	after_place_node = function(pos)
		minetest.add_entity(pos, "3d_armor_stand:armor_entity")
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack)
		local def = stack:get_definition() or {}
		local groups = def.groups or {}
		if groups[listname] then
			return 1
		end
		return 0
	end,
	allow_metadata_inventory_move = function(pos)
		return 0
	end,
	on_blast = function(pos)
		local object = get_stand_object(pos)
		if object then
			object:remove()
		end
		minetest.after(1, function(pos)
			update_entity(pos)
		end, pos)
	end,
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		--if has_locked_chest_privilege(meta, clicker) then
		--	minetest.show_formspec(
		--		clicker:get_player_name(),
		--		"default:chest_locked",
				command_block_formspec(pos)
		--	)
		--end
	end
})
