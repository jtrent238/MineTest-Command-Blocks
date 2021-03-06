-- commandblockmod (commandblock 1.0.0.0 mod)

-- Definitions made by this mod that other mods can use too
commandblockmod = {}
commandblockmod.modname = minetest.get_current_modname()

-- Load other files
--dofile(minetest.get_modpath("commandblockmod").."/datastorage.lua")

local command_block_formspec = "size[8,3]"..
	"textarea[0,0;10,1;command_input;command_input;]"..
	"textarea[0,1;10,1;command_output;command_output;]"..
	"button[0,2;3,1;button_done;button_done]"..
	"button_exit[5,2;3,1;button_cancel;button_cancel]"
local elements = {"command_input", "command_output", "button_cancel", "button_done"}
--local data = datastorage.get(id, ...)

-- Set a noticeable inventory formspec for players
minetest.register_on_joinplayer(function(player)
	local cb = function(player)
		minetest.chat_send_player(player:get_player_name(), "Command Block mod made by: jtrent238")
	end
	minetest.after(2.0, cb, player)
end)

minetest.register_node("commandblockmod:BlockCommandBlock", {
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

minetest.save = function()
	datastorage.save(command_input)
	end
