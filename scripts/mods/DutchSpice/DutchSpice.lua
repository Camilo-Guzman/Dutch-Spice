local mod = get_mod("DutchSpice")
local mutator = mod:persistent_table("DutchSpice")

--[[
	Functions
--]]
local empowered_specials = true
local auras_and_mutators = true


local function count_event_breed(breed_name)
	return Managers.state.conflict:count_units_by_breed_during_event(breed_name)
end

local function count_breed(breed_name)
	return Managers.state.conflict:count_units_by_breed(breed_name)
end

local boss_pre_spawn_func = nil
local custom_grudge_boss = nil
boss_pre_spawn_func = TerrorEventUtils.add_enhancements_for_difficulty
custom_grudge_boss = TerrorEventUtils.generate_enhanced_breed_from_list

local enhancement_list = {
	["regenerating"] = true,
	["unstaggerable"] = true
}
local enhancement_1 = TerrorEventUtils.generate_enhanced_breed_from_set(enhancement_list)

local enhancement_list = {
	["unstaggerable"] = true
}
local relentless = TerrorEventUtils.generate_enhanced_breed_from_set(enhancement_list)

local enhancement_list = {
	["intangible"] = true
}
local enhancement_3 = TerrorEventUtils.generate_enhanced_breed_from_set(enhancement_list)

local enhancement_list = {
	["ranged_immune"] = true
}
local enhancement_4 = TerrorEventUtils.generate_enhanced_breed_from_set(enhancement_list)
local enhancement_list = {
	["commander"] = true
}
local enhancement_5 = TerrorEventUtils.generate_enhanced_breed_from_set(enhancement_list)
local enhancement_list = {
	["vampiric"] = true
}
local life_leach = TerrorEventUtils.generate_enhanced_breed_from_set(enhancement_list)

local enhancement_list = {
	["regenerating"] = true
}
local regenerating = TerrorEventUtils.generate_enhanced_breed_from_set(enhancement_list)
local enhancement_list = {
	["intangible"] = true,
	["unstaggerable"] = true,
	["crushing"] = true
}
local enhancement_7 = TerrorEventUtils.generate_enhanced_breed_from_set(enhancement_list)
local enhancement_list = {
	["intangible_mirror"] = true,
	["shockwave"] = true
}
local enhancement_8 = TerrorEventUtils.generate_enhanced_breed_from_set(enhancement_list)

local enhancement_list = {
	["crushing"] = true
}
local shield_shatter = TerrorEventUtils.generate_enhanced_breed_from_set(enhancement_list)
local weapon_balance_active = get_mod("Weapon Balance")
local enemy_buffs_present = false

local function check_for_buffs()
	if get_mod("Weapon Balance") or get_mod("TourneyBalance") then
		mod:echo("Custom Enemy buffs present")
		enemy_buffs_present = true
	end
end

local function khorne_cultist_spawn_function(unit, breed, optional_data)
	if enemy_buffs_present and mod:get("auras_and_mutators") then
		local buff_system = Managers.state.entity:system("buff_system")

		buff_system:add_buff(unit, "curse_khorne_champions_aoe", unit)
	end
end
local function khorne_buff_spawn_function(unit, breed, optional_data)
	local nearby_player_units = {}
	local pos = POSITION_LOOKUP[unit]
	local player_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase

	if pos then
		local num_players = Broadphase.query(player_broadphase, pos, 1000, nearby_player_units)
		local preferred_target = nil

		if num_players == 1 then
			preferred_target = nearby_player_units[1]
		else
			local closest_player_dist_sq = math.huge
			local closest_player, player_pos, player_unit = nil
			for i = 1, num_players do
				local player_unit = nearby_player_units[i]
				local player_pos = POSITION_LOOKUP[player_unit]
				local dist_sq = Vector3.distance_squared(pos, player_pos)

				if dist_sq < closest_player_dist_sq then
					preferred_target = player_unit
					closest_player_dist_sq = dist_sq
				end
			end
		end

		if preferred_target then
			local ai_simple = ScriptUnit.extension(unit, "ai_system")

			ai_simple:enemy_aggro(nil, preferred_target)
		end

		local blackboard = BLACKBOARDS[unit]
		local t = Managers.time:time("main")

		blackboard.target_unit = preferred_target
		blackboard.target_unit_found_time = t

		AiUtils.activate_unit(blackboard)

		blackboard.defend = false
	end

	if enemy_buffs_present and mod:get("auras_and_mutators") and ALIVE[unit] then
		local buff_system = Managers.state.entity:system("buff_system")

		buff_system:add_buff(unit, "ai_health_buff_dutch", unit)
		buff_system:add_buff(unit, "khorne_debuff_ranged_dutch_aoe", unit)
		buff_system:add_buff(unit, "khorne_champion_decal", unit)
		buff_system:add_buff(unit, "khorne_buff_dutch_fx", unit)
		buff_system:add_buff(unit, "khorne_prop_dutch", unit)
		buff_system:add_buff(unit, "khorne_debuff_dutch_aoe", unit)
	end
end
local function khorne_warcamp_boss(unit, breed, optional_data)
	if enemy_buffs_present and mod:get("auras_and_mutators") then
		local buff_system = Managers.state.entity:system("buff_system")

		buff_system:add_buff(unit, "khorne_debuff_ranged_dutch_aoe", unit)
		buff_system:add_buff(unit, "khorne_champion_decal", unit)
		buff_system:add_buff(unit, "khorne_buff_dutch_fx", unit)
		buff_system:add_buff(unit, "khorne_prop_dutch", unit)
		buff_system:add_buff(unit, "khorne_debuff_dutch_aoe", unit)
	end
end

local function tzeentch_buff_spawn_function(unit, breed, optional_data)
	local nearby_player_units = {}
	local pos = POSITION_LOOKUP[unit]
	local player_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase

	if pos then
		local num_players = Broadphase.query(player_broadphase, pos, 1000, nearby_player_units)
		local preferred_target = nil

		if num_players == 1 then
			preferred_target = nearby_player_units[1]
		else
			local closest_player_dist_sq = math.huge
			local closest_player, player_pos, player_unit = nil
			for i = 1, num_players do
				local player_unit = nearby_player_units[i]
				local player_pos = POSITION_LOOKUP[player_unit]
				local dist_sq = Vector3.distance_squared(pos, player_pos)

				if dist_sq < closest_player_dist_sq then
					preferred_target = player_unit
					closest_player_dist_sq = dist_sq
				end
			end
		end

		if preferred_target then
			local ai_simple = ScriptUnit.extension(unit, "ai_system")

			ai_simple:enemy_aggro(nil, preferred_target)
		end

		local blackboard = BLACKBOARDS[unit]
		local t = Managers.time:time("main")

		blackboard.target_unit = preferred_target
		blackboard.target_unit_found_time = t

		AiUtils.activate_unit(blackboard)

		blackboard.defend = false
	end

	if enemy_buffs_present and mod:get("auras_and_mutators") then
		local buff_system = Managers.state.entity:system("buff_system")

		buff_system:add_buff(unit, "ai_health_buff_dutch", unit)
		buff_system:add_buff(unit, "tzeentchian_barier_buff", unit)
		buff_system:add_buff(unit, "tzeentch_debuff_dutch_aoe", unit)
		buff_system:add_buff(unit, "tzeentch_champion_decal", unit)
		buff_system:add_buff(unit, "tzeentch_buff_dutch_fx", unit)
	end
end
local function slaanesh_buff_spawn_function(unit, breed, optional_data)
	local nearby_player_units = {}
	local pos = POSITION_LOOKUP[unit]
	local player_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase

	if pos then
		local num_players = Broadphase.query(player_broadphase, pos, 1000, nearby_player_units)
		local preferred_target = nil

		if num_players == 1 then
			preferred_target = nearby_player_units[1]
		else
			local closest_player_dist_sq = math.huge
			local closest_player, player_pos, player_unit = nil
			for i = 1, num_players do
				local player_unit = nearby_player_units[i]
				local player_pos = POSITION_LOOKUP[player_unit]
				local dist_sq = Vector3.distance_squared(pos, player_pos)

				if dist_sq < closest_player_dist_sq then
					preferred_target = player_unit
					closest_player_dist_sq = dist_sq
				end
			end
		end

		if preferred_target then
			local ai_simple = ScriptUnit.extension(unit, "ai_system")

			ai_simple:enemy_aggro(nil, preferred_target)
		end

		local blackboard = BLACKBOARDS[unit]
		local t = Managers.time:time("main")

		blackboard.target_unit = preferred_target
		blackboard.target_unit_found_time = t

		AiUtils.activate_unit(blackboard)

		blackboard.defend = false
	end

	if enemy_buffs_present and mod:get("auras_and_mutators") then
		local buff_system = Managers.state.entity:system("buff_system")

		buff_system:add_buff(unit, "ai_health_buff_dutch", unit)
		buff_system:add_buff(unit, "slaanesh_debuff_dutch_aoe", unit)
		buff_system:add_buff(unit, "belakor_buff_dutch_fx", unit)
		buff_system:add_buff(unit, "belakor_champion_decal", unit)
	end
end
local function random_explosion(unit, breed, optional_data)
	if enemy_buffs_present and mod:get("auras_and_mutators") then
		local nearby_player_units = {}
		local pos = POSITION_LOOKUP[unit]
		local player_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase

		if pos then
			local num_players = Broadphase.query(player_broadphase, pos, 1000, nearby_player_units)
			local preferred_target = nil

			if num_players == 1 then
				preferred_target = nearby_player_units[1]
			else
				local closest_player_dist_sq = math.huge
				local closest_player, player_pos, player_unit = nil
				for i = 1, num_players do
					local player_unit = nearby_player_units[i]
					local player_pos = POSITION_LOOKUP[player_unit]
					local dist_sq = Vector3.distance_squared(pos, player_pos)

					if dist_sq < closest_player_dist_sq then
						preferred_target = player_unit
						closest_player_dist_sq = dist_sq
					end
				end
			end

			if preferred_target then
				local ai_simple = ScriptUnit.extension(unit, "ai_system")

				ai_simple:enemy_aggro(nil, preferred_target)
			end

			local blackboard = BLACKBOARDS[unit]
			local t = Managers.time:time("main")

			blackboard.target_unit = preferred_target
			blackboard.target_unit_found_time = t

			AiUtils.activate_unit(blackboard)

			blackboard.defend = false
		end

		local buff_system = Managers.state.entity:system("buff_system")
		buff_system:add_buff(unit, "random_lightning", unit)
		buff_system:add_buff(unit, "anti_burst", unit)
	end
end
local function nurgle_cultist_spawn_function(unit, breed, optional_data)
	if enemy_buffs_present and mod:get("auras_and_mutators") then
		local buff_system = Managers.state.entity:system("buff_system")

		buff_system:add_buff(unit, "mark_of_nurgle", unit)
	end
end
local function nurgle_buff_spawn_function(unit, breed, optional_data)
	local nearby_player_units = {}
	local pos = POSITION_LOOKUP[unit]
	local player_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase

	if pos then
		local num_players = Broadphase.query(player_broadphase, pos, 1000, nearby_player_units)
		local preferred_target = nil

		if num_players == 1 then
			preferred_target = nearby_player_units[1]
		else
			local closest_player_dist_sq = math.huge
			local closest_player, player_pos, player_unit = nil
			for i = 1, num_players do
				local player_unit = nearby_player_units[i]
				local player_pos = POSITION_LOOKUP[player_unit]
				local dist_sq = Vector3.distance_squared(pos, player_pos)

				if dist_sq < closest_player_dist_sq then
					preferred_target = player_unit
					closest_player_dist_sq = dist_sq
				end
			end
		end

		if preferred_target then
			local ai_simple = ScriptUnit.extension(unit, "ai_system")

			ai_simple:enemy_aggro(nil, preferred_target)
		end

		local blackboard = BLACKBOARDS[unit]
		local t = Managers.time:time("main")

		blackboard.target_unit = preferred_target
		blackboard.target_unit_found_time = t

		AiUtils.activate_unit(blackboard)

		blackboard.defend = false
	end

	if enemy_buffs_present and mod:get("auras_and_mutators") then
		local buff_system = Managers.state.entity:system("buff_system")

		buff_system:add_buff(unit, "nurgle_debuff_dutch_aoe_movement", unit)
		buff_system:add_buff(unit, "nurgle_debuff_dutch_fx", unit)
		buff_system:add_buff(unit, "ai_health_buff_dutch", unit)
		buff_system:add_buff(unit, "gs_nurgle_decal", unit)
	end
end
local function cursed_chest_enemy_spawned_func(unit, breed, optional_data)
	if not breed.special and not breed.boss and not breed.cannot_be_aggroed then
		local player_unit = PlayerUtils.get_random_alive_hero()

		AiUtils.aggro_unit_of_enemy(unit, player_unit)
	end

	local buff_system = Managers.state.entity:system("buff_system")

	buff_system:add_buff(unit, "cursed_chest_objective_unit", unit)

	local blackboard = BLACKBOARDS[unit]

	if blackboard then
		local sound_event = "Play_normal_spawn_stinger"

		if breed.special or breed.boss then
			sound_event = "Play_special_spawn_stinger"
		end

		local audio_system = Managers.state.entity:system("audio_system")

		audio_system:play_audio_unit_event(sound_event, unit)
	end
end
local DECAL_RADIUS_MAP = {
	boss = 2,
	default = 1,
	elite = 1.2,
	special = 1.2,
}
local SPAWN_DECAL_UNIT_NAME = "units/decals/deus_decal_aoe_cursedchest_01"

local function cursed_chest_enemy_spawn_decal_func(event, element, boxed_spawn_pos, breed_name)
	local decal_map = event.decal_map or {}

	event.decal_map = decal_map

	local breed = Breeds[breed_name]
	local spawn_radius

	if breed.boss then
		spawn_radius = DECAL_RADIUS_MAP.boss
	elseif breed.special then
		spawn_radius = DECAL_RADIUS_MAP.special
	elseif breed.elite then
		spawn_radius = DECAL_RADIUS_MAP.elite
	else
		spawn_radius = DECAL_RADIUS_MAP.default
	end

	local spawn_pos = boxed_spawn_pos:unbox()
	local decal_unit, decal_unit_go_id
	local decal_spawn_pose = Matrix4x4.from_quaternion_position(Quaternion.identity(), spawn_pos)
	local decal_radius = spawn_radius

	Matrix4x4.set_scale(decal_spawn_pose, Vector3(decal_radius, decal_radius, decal_radius))

	decal_unit, decal_unit_go_id = Managers.state.unit_spawner:spawn_network_unit(SPAWN_DECAL_UNIT_NAME, "network_synched_dummy_unit", nil, decal_spawn_pose)
	decal_map[boxed_spawn_pos] = decal_unit
end

local function cursed_chest_enemy_despawn_decal_func(event, element, boxed_spawn_pos)
	local decal_map = event.decal_map
	local unit = decal_map and decal_map[boxed_spawn_pos]

	if unit then
		Unit.flow_event(unit, "despawned")

		local unit_go_id = Managers.state.unit_storage:go_id(unit)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_flow_event", unit_go_id, NetworkLookup.flow_events.despawned)

		decal_map[boxed_spawn_pos] = nil
	end
end

local function exalted_chaos_boss(unit, breed, optional_data)
	if enemy_buffs_present and mod:get("auras_and_mutators") then
		local buff_system = Managers.state.entity:system("buff_system")

		buff_system:add_buff(unit, "degenerating_times_2", unit)
		buff_system:add_buff(unit, "anti_burst", unit)
	end
end

local function degenerating_rat_ogre(unit, breed, optional_data)
	local nearby_player_units = {}
	local pos = POSITION_LOOKUP[unit]
	local player_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase

	if pos then
		local num_players = Broadphase.query(player_broadphase, pos, 1000, nearby_player_units)
		local preferred_target = nil

		if num_players == 1 then
			preferred_target = nearby_player_units[1]
		else
			local closest_player_dist_sq = math.huge
			local closest_player, player_pos, player_unit = nil
			for i = 1, num_players do
				local player_unit = nearby_player_units[i]
				local player_pos = POSITION_LOOKUP[player_unit]
				local dist_sq = Vector3.distance_squared(pos, player_pos)

				if dist_sq < closest_player_dist_sq then
					preferred_target = player_unit
					closest_player_dist_sq = dist_sq
				end
			end
		end

		if preferred_target then
			local ai_simple = ScriptUnit.extension(unit, "ai_system")

			ai_simple:enemy_aggro(nil, preferred_target)
		end

		local blackboard = BLACKBOARDS[unit]
		local t = Managers.time:time("main")

		blackboard.target_unit = preferred_target
		blackboard.target_unit_found_time = t

		AiUtils.activate_unit(blackboard)

		blackboard.defend = false
	end

	if enemy_buffs_present and mod:get("auras_and_mutators") then
		local buff_system = Managers.state.entity:system("buff_system")

		buff_system:add_buff(unit, "degenerating", unit)
		Unit.set_scalar_for_materials_in_unit_and_childs(unit, "tint_color_set_1", math.random(13,13))
		Unit.set_scalar_for_materials_in_unit_and_childs(unit, "tint_color_set_2", math.random(13,13))
		Unit.set_vector3_for_materials_in_unit_and_childs(unit, "color_inner", Vector3(math.random(), math.random(), math.random()))
		Unit.set_scalar_for_materials_in_unit_and_childs(unit, "emissive_power", math.random())
		Unit.set_scalar_for_materials_in_unit_and_childs(unit, "emissive_power_boost_max", math.random(0,10))
		Unit.set_scalar_for_materials_in_unit_and_childs(unit, "opacity", math.random())
	end
end
local function degenerating_times_2(unit, breed, optional_data)
	local nearby_player_units = {}
	local pos = POSITION_LOOKUP[unit]
	local player_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase

	if pos then
		local num_players = Broadphase.query(player_broadphase, pos, 1000, nearby_player_units)
		local preferred_target = nil

		if num_players == 1 then
			preferred_target = nearby_player_units[1]
		else
			local closest_player_dist_sq = math.huge
			local closest_player, player_pos, player_unit = nil
			for i = 1, num_players do
				local player_unit = nearby_player_units[i]
				local player_pos = POSITION_LOOKUP[player_unit]
				local dist_sq = Vector3.distance_squared(pos, player_pos)

				if dist_sq < closest_player_dist_sq then
					preferred_target = player_unit
					closest_player_dist_sq = dist_sq
				end
			end
		end

		if preferred_target then
			local ai_simple = ScriptUnit.extension(unit, "ai_system")

			ai_simple:enemy_aggro(nil, preferred_target)
		end

		local blackboard = BLACKBOARDS[unit]
		local t = Managers.time:time("main")

		blackboard.target_unit = preferred_target
		blackboard.target_unit_found_time = t

		AiUtils.activate_unit(blackboard)

		blackboard.defend = false
	end

	if enemy_buffs_present and mod:get("auras_and_mutators") then
		local buff_system = Managers.state.entity:system("buff_system")

		buff_system:add_buff(unit, "degenerating_times_2", unit)
		Unit.set_scalar_for_materials_in_unit_and_childs(unit, "tint_color_set_1", math.random(13,13))
		Unit.set_scalar_for_materials_in_unit_and_childs(unit, "tint_color_set_2", math.random(13,13))
		Unit.set_vector3_for_materials_in_unit_and_childs(unit, "color_inner", Vector3(math.random(), math.random(), math.random()))
		Unit.set_scalar_for_materials_in_unit_and_childs(unit, "emissive_power", math.random())
		Unit.set_scalar_for_materials_in_unit_and_childs(unit, "emissive_power_boost_max", math.random(0,10))
		Unit.set_scalar_for_materials_in_unit_and_childs(unit, "opacity", math.random())
	end
end
local function degenerating(unit, breed, optional_data)
	if enemy_buffs_present and mod:get("auras_and_mutators") then
		local buff_system = Managers.state.entity:system("buff_system")

		buff_system:add_buff(unit, "degenerating", unit)
	end
end
local function change_color(unit, breed, optional_data)
	Unit.set_scalar_for_materials_in_unit_and_childs(unit, "tint_color_set_1", math.random(0,15))
    Unit.set_scalar_for_materials_in_unit_and_childs(unit, "tint_color_set_2", math.random(0,15))
    Unit.set_vector3_for_materials_in_unit_and_childs(unit, "color_inner", Vector3(math.random(), math.random(), math.random()))
    Unit.set_scalar_for_materials_in_unit_and_childs(unit, "emissive_power", math.random())
    Unit.set_scalar_for_materials_in_unit_and_childs(unit, "emissive_power_boost_max", math.random(0,10))
    Unit.set_scalar_for_materials_in_unit_and_childs(unit, "opacity", math.random())
end

local function debug_print(message, ...)
	if DEBUG_TWITCH then
		print("[Twitch] " .. string.format(message, ...))
	end
end

local function add_buff_to_all_players(buff_name)
	local players = Managers.player:human_and_bot_players()

	for _, player in pairs(players) do
		local unit = player.player_unit

		if Unit.alive(unit) then
			local buff_system = Managers.state.entity:system("buff_system")
			local server_controlled = false

			buff_system:add_buff(unit, buff_name, unit, server_controlled)
		end
	end
end

local function activate_darkness()
	if mod:get("auras_and_mutators") then

		local mutator_handler = Managers.state.game_mode._mutator_handler
		local mutator_name = "twitch_darkness"
		local duration = 10000

		debug_print(string.format("[TWITCH VOTE] Activating mutator %s", mutator_name))
		mutator_handler:initialize_mutators({
			mutator_name,
		})
		mutator_handler:activate_mutator(mutator_name, duration, "activated_by_twitch")
		local pickup_system = Managers.state.entity:system("pickup_system")
		local torch_pups_in_level = pickup_system:get_pickups_by_type("mutator_torch")
		local side = Managers.state.side:get_side_from_name("heroes") or Managers.state.side:sides()[1]
		local player_units = side.PLAYER_AND_BOT_UNITS
		local num_player_units = #player_units

		for i = 1, num_player_units do
			local inventory_extension = ScriptUnit.has_extension(player_units[i], "inventory_system")
			local has_torch = inventory_extension and inventory_extension:has_inventory_item("slot_level_event", "mutator_torch")
		end

		return true
	end
end
local function activate_darkness_180()
	if mod:get("auras_and_mutators") then

		local mutator_handler = Managers.state.game_mode._mutator_handler
		local mutator_name = "twitch_darkness"
		local duration = 180

		debug_print(string.format("[TWITCH VOTE] Activating mutator %s", mutator_name))
		mutator_handler:initialize_mutators({
			mutator_name,
		})
		mutator_handler:activate_mutator(mutator_name, duration, "activated_by_twitch")
		local pickup_system = Managers.state.entity:system("pickup_system")
		local torch_pups_in_level = pickup_system:get_pickups_by_type("mutator_torch")
		local side = Managers.state.side:get_side_from_name("heroes") or Managers.state.side:sides()[1]
		local player_units = side.PLAYER_AND_BOT_UNITS
		local num_player_units = #player_units

		for i = 1, num_player_units do
			local inventory_extension = ScriptUnit.has_extension(player_units[i], "inventory_system")
			local has_torch = inventory_extension and inventory_extension:has_inventory_item("slot_level_event", "mutator_torch")
		end

		return true
	end
end

local function activate_twins()
	if mod:get("auras_and_mutators") then

		local mutator_handler = Managers.state.game_mode._mutator_handler
		local mutator_name = "splitting_enemies"
		local duration = 10000

		debug_print(string.format("[TWITCH VOTE] Activating mutator %s", mutator_name))
		mutator_handler:initialize_mutators({
			mutator_name,
		})
		mutator_handler:activate_mutator(mutator_name, duration, "activated_by_twitch")
		return true
	end
end
local function activate_lightning_strike()
	if mod:get("auras_and_mutators") then

		local mutator_handler = Managers.state.game_mode._mutator_handler
		local mutator_name = "lightning_strike"
		local duration = 10000

		debug_print(string.format("[TWITCH VOTE] Activating mutator %s", mutator_name))
		mutator_handler:initialize_mutators({
			mutator_name,
		})
		mutator_handler:activate_mutator(mutator_name, duration, "activated_by_twitch")
		return true
	end
end

local function activate_bush()
	local mutator_handler = Managers.state.game_mode._mutator_handler
		local mutator_name = "life"
		local duration = 10000

		debug_print(string.format("[TWITCH VOTE] Activating mutator %s", mutator_name))
		mutator_handler:initialize_mutators({
			mutator_name,
		})
		mutator_handler:activate_mutator(mutator_name, duration, "activated_by_twitch")
	return true
end

local function spawn_nurglings_dutch()
	local random_player = PlayerUtils.get_random_alive_hero()
	local center_position = POSITION_LOOKUP[random_player]

	local optional_data = {
		spawned_func = function (unit, breed, optional_data)
			local blackboard = BLACKBOARDS[unit]
			local ai_extension = ScriptUnit.extension(unit, "ai_system")

			ai_extension:set_perception("perception_regular", "pick_no_targets")

			if blackboard then
				blackboard.altar_pos = center_position
				blackboard.is_fleeing = false
				blackboard.nurgling_spawned_by_altar = true
			end
		end,
	}
	local lowest_amount = 15
	local highest_amount = 20
	local num_nurglings = math.random(lowest_amount, highest_amount)
	local spawn_radius = 15
	local spread = 15
	local tries = 15
	local group_data = {
		template = "critter_nurglings",
		id = Managers.state.entity:system("ai_group_system"):generate_group_id(),
		size = num_nurglings,
	}
	local spawn_rot = Quaternion.identity()
	local breed_name = "critter_nurgling"
	local spawn_category = "event"
	local spawn_type = "event"
	local spawn_animation
	local breed_data = Breeds[breed_name]
	local conflict_director = Managers.state.conflict
	local nav_world = Managers.state.entity:system("ai_system"):nav_world()

	for i = 1, num_nurglings do
		local spawn_pos = ConflictUtils.get_spawn_pos_on_circle(nav_world, center_position, spawn_radius, spread, tries)

		conflict_director:spawn_queued_unit(breed_data, Vector3Box(spawn_pos), QuaternionBox(spawn_rot), spawn_category, spawn_animation, spawn_type, optional_data, group_data)
	end

	return true
end

local function create_weights()
	local crash = nil

	for id, setting in pairs(PackSpawningSettings) do
		setting.name = id

		if not setting.disabled then
			roaming_set = setting.roaming_set
			roaming_set.name = id
			local weights = {}
			local breed_packs_override = roaming_set.breed_packs_override

			if breed_packs_override then
				for i = 1, #breed_packs_override, 1 do
					weights[i] = breed_packs_override[i][2]
				end

				roaming_set.breed_packs_override_loaded_dice = {
					LoadedDice.create(weights)
				}
			end
		end
	end

	-- Adjustment for the new difficulty system of horde compositions from 1.4 - I am not copypasting each composition 3 times. Or 4, doesn't matter.
	for event, composition in pairs(HordeCompositions) do
		if not composition[1][1] then
			local temp_table = table.clone(composition)
			table.clear_array(composition, #composition)
			composition[1] = temp_table
			composition[2] = temp_table
			composition[3] = temp_table
			composition[4] = temp_table
			composition[5] = temp_table
			composition[6] = temp_table
			composition[7] = temp_table
		elseif not composition[6] then
			composition[6] = composition[5]
			composition[7] = composition[5]
		end
	end

	local weights = {}
	local crash = nil

	for key, setting in pairs(HordeSettings) do
		setting.name = key

		if setting.compositions then
			for name, composition in pairs(setting.compositions) do
				for i = 1, #composition, 1 do
					table.clear_array(weights, #weights)

					local compositions = composition[i]

					for j, variant in ipairs(compositions) do
						weights[j] = variant.weight
						local breeds = variant.breeds

						if breeds then
							for k = 1, #breeds, 2 do
								local breed_name = breeds[k]
								local breed = Breeds[breed_name]

								if not breed then
									print(string.format("Bad or non-existing breed in HordeCompositions table %s : '%s' defined in HordeCompositions.", name, tostring(breed_name)))

									crash = true
								elseif not breed.can_use_horde_spawners then
									variant.must_use_hidden_spawners = true
								end
							end
						end
					end

					compositions.loaded_probs = {
						LoadedDice.create(weights)
					}

					fassert(not crash, "Found errors in HordeComposition table %s - see above. ", name)
					fassert(compositions.loaded_probs, "Could not create horde composition probablitity table, make sure the table '%s' in HordeCompositions is correctly structured and has an entry for each difficulty.", name)
				end
			end
		end

		if setting.compositions_pacing then
			for name, composition in pairs(setting.compositions_pacing) do
				table.clear_array(weights, #weights)

				for i, variant in ipairs(composition) do
					weights[i] = variant.weight
					local breeds = variant.breeds

					for j = 1, #breeds, 2 do
						local breed_name = breeds[j]
						local breed = Breeds[breed_name]

						if not breed then
							print(string.format("Bad or non-existing breed in HordeCompositionsPacing table %s : '%s' defined in HordeCompositionsPacing.", name, tostring(breed_name)))

							crash = true
						elseif not breed.can_use_horde_spawners then
							variant.must_use_hidden_spawners = true
						end
					end
				end

				composition.loaded_probs = {
					LoadedDice.create(weights)
				}

				fassert(not crash, "Found errors in HordeCompositionsPacing table %s - see above. ", name)
				fassert(composition.loaded_probs, "Could not create horde composition probablitity table, make sure the table '%s' in HordeCompositionsPacing is correctly structured.", name)
			end
		end
	end
end

Managers.package:load("resource_packages/dlcs/wizards_part_2", "global")
Managers.package:load("resource_packages/levels/dlcs/wizards/dlc_wizards_tower", "global")

-- Fix to specials being disabled by pacing disables in events.
mod:hook(Pacing, "disable", function (func, self)
	self._threat_population = 1
	self._specials_population = 1
	self._horde_population = 0
	self.pacing_state = "pacing_frozen"
end)

mod:hook(TerrorEventMixer.init_functions, "control_specials", function (func, event, element, t)
	local conflict_director = Managers.state.conflict
	local specials_pacing = conflict_director.specials_pacing
	local not_already_enabled = specials_pacing:is_disabled()

	if specials_pacing then
		specials_pacing:enable(element.enable)

		if element.enable and not_already_enabled then
			local delay = math.random(5, 12)
			local per_unit_delay = math.random(8, 16)
			local t = Managers.time:time("game")

			specials_pacing:delay_spawning(t, delay, per_unit_delay, true)
		end
	end
end)

local NUM_FAR_OFF_CHECKS = 6
local position_lookup = POSITION_LOOKUP

mod:hook_origin(EnemyRecycler, "far_off_despawn", function (self, t, dt, player_positions, spawned)
	local index = self.far_off_index or 1
	local size = #spawned
	local num = NUM_FAR_OFF_CHECKS

	if size < num then
		num = size
		index = 1
	end

	local destroy_los_distance_squared = LevelHelper:current_level_settings().destroy_los_distance_squared or RecycleSettings.destroy_los_distance_squared
	local nav_world = self.nav_world
	local num_players = #player_positions

	if num_players == 0 then
		return
	end

	local Vector3_distance_squared = Vector3.distance_squared
	local i = 1

	while num >= i do
		if size < index then
			index = 1
		end

		local destroy_distance_squared = destroy_los_distance_squared
		local ai_stuck = false
		local unit = spawned[index]
		local pos = position_lookup[unit]
		local blackboard = BLACKBOARDS[unit]

		if blackboard and blackboard.stuck_check_time < t then
			if not blackboard.far_off_despawn_immunity then
				local navigation_extension = blackboard.navigation_extension

				if navigation_extension._enabled and blackboard.no_path_found then
					if not blackboard.stuck_time then
						blackboard.stuck_time = t + 3
					elseif blackboard.stuck_time < t then
						ai_stuck = true
						destroy_distance_squared = RecycleSettings.destroy_stuck_distance_squared
						blackboard.stuck_time = nil
					end
				elseif not blackboard.no_path_found then
					blackboard.stuck_time = nil
				end
			end

			blackboard.stuck_check_time = t + 3 + i * dt
		end

		local num_players_far_away = 0

		for j = 1, num_players, 1 do
			if pos then
				local player_pos = player_positions[j]
				local dist_squared = Vector3_distance_squared(pos, player_pos)

				if destroy_distance_squared < dist_squared then
					num_players_far_away = num_players_far_away + 1
				end
			end
		end

		if num_players_far_away == num_players then
			if ai_stuck then
				print("Destroying unit - ai got stuck breed: %s index: %d size: %d action: %s", blackboard.breed.name, index, size, blackboard.action and blackboard.action.name)
				self.conflict_director:destroy_unit(unit, blackboard, "stuck")
			elseif not blackboard.far_off_despawn_immunity then
				print("Destroying unit - ai too far away from all players. ", blackboard.breed.name, i, index, size)
				self.conflict_director:destroy_unit(unit, blackboard, "far_away")
			end

			size = #spawned

			if size == 0 then
				break
			end
		end

		index = index + 1
		i = i + 1
	end

	self.far_off_index = index
end)

-- Dirty hook to work around lack of node in custom spawners.
mod:hook(AISpawner, "spawn_unit", function (func, self)
	local breed_name = nil
	local breed_list = self._breed_list
	local last = #breed_list
	local spawn_data = breed_list[last]
	breed_list[last] = nil
	last = last - 1
	local breed_name = breed_list[last]
	breed_list[last] = nil
	local breed = Breeds[breed_name]

	--Because this one spawner won't work properly with bilechemists..
	if breed_name == "chaos_plague_sorcerer" then
		if Unit.local_position(self._unit, 0).x == 349.67596435546875 then
			local spawner_system = Managers.state.entity:system("spawner_system")
			self._unit = spawner_system._id_lookup["sorcerer_boss_minion"][1]
			self.changed = true
		end
	elseif self.changed then
		local spawner_system = Managers.state.entity:system("spawner_system")
		self._unit = spawner_system._id_lookup["sorcerer_boss_minion"][5]
		self.changed = nil
	end

	local unit = self._unit

	Unit.flow_event(unit, "lua_spawn")

	local conflict_director = Managers.state.conflict
	local spawn_category = "ai_spawner"
	local node = (Unit.has_node(unit, self._config.node) and Unit.node(unit, self._config.node)) or 0
	local parent_index = Unit.scene_graph_parent(unit, node) or 1
	local parent_world_rotation = Unit.world_rotation(unit, parent_index)
	local spawn_node_rotation = Unit.local_rotation(unit, node)
	local spawn_rotation = Quaternion.multiply(parent_world_rotation, spawn_node_rotation)
	local spawn_type = (Unit.get_data(self._unit, "hidden") and "horde_hidden") or "horde"
	local spawn_pos = Unit.world_position(unit, node)	
	local animation_events = self._config.animation_events

	if spawn_type == "horde_hidden" and breed.use_regular_horde_spawning then
		spawn_type = "horde"
	end

	local spawn_animation = spawn_type == "horde" and animation_events[math.random(#animation_events)]
	local spawner_name = self:get_spawner_name()
	local side_id = spawn_data[1]
	local optional_data = {
		side_id = side_id
	}

	local activate_version = self._activate_version
	local spawned_func = optional_data.spawned_func

	if spawned_func then
		optional_data.spawned_func = function (spawned_unit, ...)
			spawned_func(spawned_unit, ...)

			if activate_version == self._activate_version then
				self._spawned_units[#self._spawned_units + 1] = spawned_unit
			end
		end
	end

	local group_template = spawn_data[2]

	self._num_queued_units = self._num_queued_units + 1
	self._spawned_unit_handles[self._num_queued_units] = conflict_director:spawn_queued_unit(breed, Vector3Box(spawn_pos), QuaternionBox(spawn_rotation), spawn_category, spawn_animation, spawn_type, optional_data, group_template)

	conflict_director:add_horde(1)
end)

--Rewrite of threat calculation because the official function is unreliable and fails to remove units from the count.
mod:hook(ConflictDirector, "calculate_threat_value", function (func, self)
	local aggroed_units = {}	
	local ai_system = Managers.state.entity:system('ai_system')
	local broadphase = ai_system.broadphase

	for i, player in pairs(Managers.player:human_and_bot_players()) do
		local ai_units = {}
		if player.player_unit then
			local num_ai_units = Broadphase.query(broadphase, Unit.local_position(player.player_unit, 0), 50, ai_units)
			if num_ai_units > 0 then
				for i = 1, num_ai_units do
					local ai_unit = ai_units[i]
					if ScriptUnit.has_extension(ai_unit, 'health_system') and ScriptUnit.extension(ai_unit, 'health_system'):is_alive() and BLACKBOARDS[ai_unit].target_unit then
						aggroed_units[ai_unit] = ai_unit
					end
				end
			end
		end
	end

	local threat_value = 0
	local count = 0

	for _, unit in pairs(aggroed_units) do
		local breed = Unit.get_data(unit, "breed")
		threat_value = threat_value + (override_threat_value or breed.threat_value or 0)
		count = count + 1
	end

	self.delay_horde = self.delay_horde_threat_value < threat_value
	self.delay_mini_patrol = self.delay_mini_patrol_threat_value < threat_value
	self.delay_specials = self.delay_specials_threat_value < threat_value
	self.threat_value = threat_value
	self.num_aggroed = count
end)

local sections_to_open = {}
mod:hook_origin(DoorSystem, "update", function(self, context, t)
	DoorSystem.super.update(self, context, t)

	if self.is_server then
		table.clear(sections_to_open)

		local active_groups = self._active_groups
		local ai_group_system = Managers.state.entity:system("ai_group_system")

		for map_section, groups in pairs(active_groups) do
			local open_map_section = false

			for i = 1, #groups, 1 do
				local data = groups[i]
				local group_id = data.group_id
				local active = data.active
				local group = ai_group_system:get_ai_group(group_id)

				if group and not active then
					data.active = true
				elseif active and not group then
					open_map_section = true
				elseif active and group then
					local members = group.members
					local should_open = true

					for unit, extension in pairs(members) do
						local heath_extension = ScriptUnit.has_extension(unit, "health_system")

						if heath_extension and heath_extension:is_alive() then
							local blackboard = BLACKBOARDS[unit]
							local breed = blackboard.breed
							local is_boss = breed and breed.boss

							if is_boss then
									should_open = false

									break
							else
								should_open = false

								break
							end
						end
					end

					if should_open then
						open_map_section = true
					end
				end
			end

			if open_map_section then
				sections_to_open[#sections_to_open + 1] = map_section
			end
		end

		for i = 1, #sections_to_open, 1 do
			local map_section = sections_to_open[i]

			self:open_boss_doors(map_section)

			self._active_groups[map_section] = nil
		end
	end
end)

--UI fluff
--mod:hook(IngamePlayerListUI, "_update_difficulty", function (func, self)
--	local difficulty_settings = Managers.state.difficulty:get_difficulty_settings()
--	local base_difficulty_name = difficulty_settings.display_name
--	local deathwish_enabled = get_mod("catas") and Managers.vmf.persistent_tables.catas.catas.active
--	local difficulty_name = (deathwish_enabled and base_difficulty_name .. "Dutch Deathwish Spice") or base_difficulty_name .. "_DutchSpice"
--
--	if mutator.active and difficulty_name ~= self.current_difficulty_name then
--		self:set_difficulty_name((deathwish_enabled and "Deathwish Dutch Spice") or Localize(base_difficulty_name) .. " DutchSpice")
--
--		self.current_difficulty_name = difficulty_name
--	end
--
--	if difficulty_name ~= self.current_difficulty_name then
--		self:set_difficulty_name(Localize(difficulty_name))
--
--		self.current_difficulty_name = difficulty_name
--	end
--end)

--Make game always private when starting matchmaking, and adds tags in the lobby browser.
--mod:hook(MatchmakingStateHostGame, "_start_hosting_game", function (func, self)
--	if EAC.state() == "trusted" then
--		self.search_config.private_game = true
--	end
--	func(self)
--
--	local lobby_data = Managers.matchmaking.lobby:get_stored_lobby_data()
--	local old_server_name = LobbyAux.get_unique_server_name()
--	local deathwish_enabled = get_mod("Deathwish") and Managers.vmf.persistent_tables.Deathwish.Deathwish.active and (self.search_config.difficulty == "harder" or self.search_config.difficulty == "hardest")
--
--	lobby_data.unique_server_name = deathwish_enabled and "||Deathwish Spciy Onslaught|| " .. string.sub(old_server_name,1,17) or "||Dutch Spice|| " .. string.sub(old_server_name,1,17)
--	Managers.matchmaking.lobby:set_lobby_data(lobby_data)
--end)
--
----Stops player from making game public after game starts.
--mod:hook(MatchmakingManager, "set_in_progress_game_privacy", function(func, self, is_private)
--	if (not is_private) and EAC.state() == "trusted" then
--		mod:echo("Onslaught games on the live realm may not be set public.")
--		return func(self, true)
--	end
--	return func(self, is_private)
--end)
--
----Keeps UI consistent with always private behaviour.
--mod:hook(IngamePlayerListUI, "set_privacy_enabled", function (func, self, enabled, animate)
--	if EAC.state() == "trusted" then
--		func(self, true, animate)
--	else
--		func(self, enabled, animate)
--	end
--end)

--Whispers players that join modded game with a warning.
--mod:hook(MatchmakingManager, "rpc_matchmaking_request_join_lobby", function (func, self, channel_id, lobby_id, friend_join, client_dlc_unlocked_array)
	--local peer_id = CHANNEL_TO_PEER_ID[channel_id]
	
	--mod:chat_whisper(peer_id, "[Automated message] The lobby you are about to join has the following difficulty mod active : Dutch Spice.")
	
	--return func(self, channel_id, lobby_id, friend_join, client_dlc_unlocked_array)
--end)


--Custom spawner logic
local custom_spawners = {}

local function setup_custom_raw_spawner(world, terror_event_id, location, rotation)
	local unit = World.spawn_unit(world, "units/hub_elements/empty", location, rotation)
	Unit.set_data(unit, "terror_event_id", terror_event_id)
	Unit.set_data(unit, "extensions", 0, "AISpawner")
	custom_spawners[#custom_spawners + 1] = unit
end

local function setup_custom_horde_spawner(unit, terror_event_id, hidden)
	Unit.set_data(unit, "terror_event_id", terror_event_id)
	Unit.set_data(unit, "hidden", hidden)
	Unit.set_data(unit, "spawner_settings", "spawner1", "enabled", true)
	Unit.set_data(unit, "spawner_settings", "spawner1", "node", "a_spawner_start")
	Unit.set_data(unit, "spawner_settings", "spawner1", "spawn_rate", 2)
	Unit.set_data(unit, "spawner_settings", "spawner1", "animation_events", 0, "spawn_idle")
	Unit.set_data(unit, "extensions", 0, "AISpawner")
	custom_spawners[#custom_spawners + 1] = unit
end

mod:hook(StateIngame, "on_enter", function (func, self)
	func(self)

	if Managers.player.is_server then
		custom_spawners = {}
		local level_key = Managers.state.game_mode:level_key()

		if level_key == "military" then
			local onslaught_courtyard_roof_left_S1 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(144, 55.1, -1.4), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_courtyard_roof_left_S1, "onslaught_courtyard_roof_left", true)

			local onslaught_courtyard_roof_left_S2 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(147.4, 67.8, -1.4), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_courtyard_roof_left_S2, "onslaught_courtyard_roof_left", true)

			local onslaught_courtyard_roof_left_S3 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(144, 80.6, -1.4), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_courtyard_roof_left_S3, "onslaught_courtyard_roof_left", true)

			local onslaught_courtyard_roof_left_S4 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(134.8, 90, -1.4), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_courtyard_roof_left_S4, "onslaught_courtyard_roof_left", true)

			local onslaught_courtyard_roof_right_S1 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(99.9, 55.1, -1.4), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_courtyard_roof_right_S1, "onslaught_courtyard_roof_right", true)

			local onslaught_courtyard_roof_right_S2 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(96.5, 67.8, -1.4), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_courtyard_roof_right_S2, "onslaught_courtyard_roof_right", true)

			local onslaught_courtyard_roof_right_S3 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(99.9, 80.6, -1.4), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_courtyard_roof_right_S3, "onslaught_courtyard_roof_right", true)

			local onslaught_courtyard_roof_right_S4 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(109.4, 90, -1.4), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_courtyard_roof_right_S4, "onslaught_courtyard_roof_right", true)

			local onslaught_courtyard_roof_middle_S1 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(122.2, 98, 4.56), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_courtyard_roof_middle_S1, "onslaught_courtyard_roof_middle", true)

			local onslaught_temple_guard_assault_S1 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(-215.1, -85.8, 74.2), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_temple_guard_assault_S1, "onslaught_temple_guard_assault", true)

			local onslaught_temple_guard_assault_S2 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(-224.2, -69.1, 74.2), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_temple_guard_assault_S2, "onslaught_temple_guard_assault", true)
		elseif level_key == "catacombs" then
			setup_custom_raw_spawner(self.world, "onslaught_pool_boss_1", Vector3(-163.64, 2.9, -15.9), Quaternion.from_elements(0, 0, -0.009, -0.999))
			setup_custom_raw_spawner(self.world, "onslaught_pool_boss_2", Vector3(-152.19, -27.16, -10.2), Quaternion.from_elements(0, 0, -0.009, -0.999))
			setup_custom_raw_spawner(self.world, "onslaught_pool_boss_3", Vector3(-114.17, -30, 0.3), Quaternion.from_elements(0, 0, 0.709, -0.705))
			setup_custom_raw_spawner(self.world, "buffed_enemy_spawn_catacombs_1", Vector3(-104.181, -31.8771, -16.4793), Quaternion.from_elements(0, 0, -0.0190225, -0.999819))
			setup_custom_raw_spawner(self.world, "buffed_enemy_spawn_catacombs_2", Vector3(-104.132, 42.2295, -16.4836), Quaternion.from_elements(0, 0, 0.988614, 0.150475))
		elseif level_key == "mines" then
			local onslaught_mines_bell_boss = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(216.879, -360.958, -15.0424), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_mines_bell_boss, "onslaught_mines_bell_boss", false)

			local onslaught_mines_horde_front = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(254.738, -380.498, -10.947), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_mines_horde_front, "onslaught_mines_horde_front", false)

			setup_custom_raw_spawner(self.world, "onslaught_mines_extra_troll_1", Vector3(284.75, -327.1, -29.5), Quaternion.from_elements(0, 0, -0.377, -0.926))
			setup_custom_raw_spawner(self.world, "onslaught_mines_extra_troll_2", Vector3(222.67, -350.32, -21.5), Quaternion.from_elements(0, 0, 0.571, -0.82))
			setup_custom_raw_spawner(self.world, "onslaught_mines_extra_troll_3", Vector3(276.667, -377.996, -17.3902), Quaternion.from_elements(0, 0, -0.849433, -0.527696))
		elseif level_key == "ground_zero" then
			setup_custom_raw_spawner(self.world, "onslaught_ele_guard_c_1", Vector3(-38.7, 11.38, -9.1), Quaternion.from_elements(0, 0, -0.257, -0.966))
			setup_custom_raw_spawner(self.world, "onslaught_ele_guard_c_2", Vector3(-37.2, 12.25, -9.1), Quaternion.from_elements(0, 0, -0.26, -0.966))
			setup_custom_raw_spawner(self.world, "onslaught_ele_guard_c_3", Vector3(-35.3, 13.41, -9.1), Quaternion.from_elements(0, 0, -0.26, -0.966))
			setup_custom_raw_spawner(self.world, "onslaught_ele_guard_c_4", Vector3(-33.6, 14.49, -9.1), Quaternion.from_elements(0, 0, -0.26, -0.966))
			setup_custom_raw_spawner(self.world, "onslaught_ele_guard_c_5", Vector3(-31.6, 15.65, -9.1), Quaternion.from_elements(0, 0, -0.26, -0.966))
			setup_custom_raw_spawner(self.world, "onslaught_ele_guard_c_6", Vector3(-30.2, 16.34, -9.1), Quaternion.from_elements(0, 0, -0.26, -0.966))
		elseif level_key == "bell" then
			setup_custom_raw_spawner(self.world, "onslaught_second_ogre", Vector3(6, -436, 36.5), Quaternion.from_elements(0, 0, 0.798, -0.602))
		elseif level_key == "farmlands" then
			setup_custom_raw_spawner(self.world, "onslaught_farmlands_extra_boss", Vector3(-136.1, -4.8, 7), Quaternion.from_elements(0, 0, 0.988, -0.15))
			setup_custom_raw_spawner(self.world, "onslaught_wall_guard_extra_1", Vector3(-109.97, 244.96, 0.86), Quaternion.from_elements(0, 0, 0.99, -0.138))
			setup_custom_raw_spawner(self.world, "onslaught_hay_barn_bridge_guards_extra_1", Vector3(-72.36, 257.7, 1.08), Quaternion.from_elements(0, 0, 0.871, 0.491))
			setup_custom_raw_spawner(self.world, "onslaught_hay_barn_bridge_guards_extra_2", Vector3(-69.8, 253.7, 1.26), Quaternion.from_elements(0, 0, 0.884, 0.468))
			setup_custom_raw_spawner(self.world, "onslaught_hay_barn_bridge_guards_extra_3", Vector3(-68.7, 255.3, 1.04), Quaternion.from_elements(0, 0, 0.874, 0.486))
			setup_custom_raw_spawner(self.world, "onslaught_hay_barn_bridge_guards_extra_4", Vector3(-69.8, 256.7, 0.93), Quaternion.from_elements(0, 0, 0.894, 0.445))
			setup_custom_raw_spawner(self.world, "onslaught_hay_barn_bridge_guards_extra_5", Vector3(-70.9, 258.3, 0.99), Quaternion.from_elements(0, 0, 0.932, 0.361))
			setup_custom_raw_spawner(self.world, "Against_the_Grain_1st_event", Vector3(-76.8781, 264.765, 8.85473), Quaternion.from_elements(0, 0, 0.963928, -0.266162))
			setup_custom_raw_spawner(self.world, "Against_the_Grain_2nd_event", Vector3(-43.5054, 242.15, 5.94876), Quaternion.from_elements(0, 0, -0.642135, -0.766592))
			setup_custom_raw_spawner(self.world, "Against_the_Grain_3rd_event", Vector3(-51.8222, 225.516, 13.4548), Quaternion.from_elements(0, 0, -0.597167, -0.802117))
		elseif level_key == "ussingen" then
			setup_custom_raw_spawner(self.world, "onslaught_gate_spawner_1", Vector3(-20.7, -273.77, -2), Quaternion.from_elements(0, 0, 0.91, -0.412))
			setup_custom_raw_spawner(self.world, "onslaught_gate_spawner_2", Vector3(2.68, -274.39, -0.7), Quaternion.from_elements(0, 0, 0.894, 0.446))
			setup_custom_raw_spawner(self.world, "onslaught_gate_spawner_3", Vector3(-10.15, -297.67, 0.5), Quaternion.from_elements(0, 0, 0.956, 0.294))

			setup_custom_raw_spawner(self.world, "onslaught_cart_guard_1", Vector3(-23.63, 48.57, 20.5), Quaternion.from_elements(0, 0, 0.989, -0.147))
			setup_custom_raw_spawner(self.world, "onslaught_cart_guard_2", Vector3(-17.70, 39.9, 20.5), Quaternion.from_elements(0, 0, 0.899, 0.437))
			setup_custom_raw_spawner(self.world, "onslaught_troll_event_ussingen", Vector3(-4.0586, -2.18367, 18.2297), Quaternion.from_elements(0, 0, 0.9968, 0.0799334))
			setup_custom_raw_spawner(self.world, "onslaught_manor_warrior", Vector3(-29.0768, -37.8507, 16.7434), Quaternion.from_elements(0, 0, -0.0810191, -0.996713))

			local onslaught_camp_boss_top = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(248.979, -67.0314, 45.8501), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_camp_boss_top, "onslaught_camp_boss_top", false)
		elseif level_key == "warcamp" then
			local onslaught_camp_boss_top = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(248.979, -67.0314, 45.8501), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_camp_boss_top, "onslaught_camp_boss_top", false)

			local onslaught_camp_boss_top_behind = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(214.069, -81.3159, 45.7736), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_camp_boss_top_behind, "onslaught_camp_boss_top_behind", false)

			local onslaught_camp_boss_top_right = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(236.587, -94.1319, 44.8331), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_camp_boss_top_right, "onslaught_camp_boss_top_right", false)

			local onslaught_camp_boss_top_left = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(229.412, -60.3625, 45.5009), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_camp_boss_top_left, "onslaught_camp_boss_top_left", false)

		elseif level_key == "skittergate" then
			setup_custom_raw_spawner(self.world, "onslaught_gate_guard", Vector3(-271.67, -355.88, -122.12), Quaternion.from_elements(0, 0, -0.112, -0.994))

			local onslaught_CW_gatekeeper_1 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(265.35, 481.66, -16.1), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_CW_gatekeeper_1, "onslaught_CW_gatekeeper_1", false)

			local onslaught_CW_gatekeeper_2 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(259.66, 442.29, -14.23), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_CW_gatekeeper_2, "onslaught_CW_gatekeeper_2", false)

			local onslaught_CW_gatekeeper_3 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(281.45, 474, -14.85), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_CW_gatekeeper_3, "onslaught_CW_gatekeeper_3", false)

			local onslaught_zerker_gatekeeper_1 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(269.59, 432.6, -8.99), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_zerker_gatekeeper_1, "onslaught_zerker_gatekeeper", false)

			local onslaught_zerker_gatekeeper_2 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(237, 438.64, -6.85), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_zerker_gatekeeper_2, "onslaught_zerker_gatekeeper", false)

			local onslaught_zerker_gatekeeper_3 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(281.45, 474, -14.85), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_zerker_gatekeeper_3, "onslaught_zerker_gatekeeper", false)
		elseif level_key == "dlc_bogenhafen_slum" then
			local onslaught_slum_gauntlet_behind = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(83.87, -43, 6.5), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_slum_gauntlet_behind, "onslaught_slum_gauntlet_behind", false)

			local onslaught_slum_gauntlet_cutoff_1 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(165.44, 14.82, 3.6), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_slum_gauntlet_cutoff_1, "onslaught_slum_gauntlet_cutoff", false)

			local onslaught_slum_gauntlet_cutoff_2 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(154.77, -9.38, 0.6), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_slum_gauntlet_cutoff_2, "onslaught_slum_gauntlet_cutoff", false)
			setup_custom_raw_spawner(self.world, "onslaught_slum_boss_event", Vector3(-20.6403, 155.328, 17.9035), Quaternion.from_elements(0, 0, -0.704612, -0.709593))
		elseif level_key == "dlc_bogenhafen_city" then
			setup_custom_raw_spawner(self.world, "onslaught_sewer_exit_gun_1", Vector3(-23.77, 37.6, 2.1), Quaternion.from_elements(0, 0, -0.109, -0.994))
			setup_custom_raw_spawner(self.world, "onslaught_sewer_exit_gun_2", Vector3(-7.3, 30.48, 13.52), Quaternion.from_elements(0, 0, 0.862, -0.507))
			setup_custom_raw_spawner(self.world, "onslaught_button_window1", Vector3(95.3663, 207.637, 94.0443), Quaternion.from_elements(0, 0, -0.369388, -0.929275))
			setup_custom_raw_spawner(self.world, "onslaught_button_window2", Vector3(94.164, 206.501, 94.0443), Quaternion.from_elements(0, 0, -0.369388, -0.929275))
			setup_custom_raw_spawner(self.world, "onslaught_button_window3", Vector3(92.9596, 205.391, 94.0443), Quaternion.from_elements(0, 0, -0.369388, -0.929275))
			setup_custom_raw_spawner(self.world, "onslaught_button_hidden", Vector3(64.743, 211.813, 81.9658), Quaternion.from_elements(0, 0, 0.327077, -0.944998))
			setup_custom_raw_spawner(self.world, "onslaught_button_front1", Vector3(60.1298, 209.761, 88.3211), Quaternion.from_elements(0, 0, 0.327077, -0.944998))
			setup_custom_raw_spawner(self.world, "onslaught_button_front2", Vector3(58.5169, 211.56, 88.3211), Quaternion.from_elements(0, 0, 0.327077, -0.944998))
			setup_custom_raw_spawner(self.world, "onslaught_button_front3", Vector3(57.1629, 213.096, 88.3211), Quaternion.from_elements(0, 0, 0.327077, -0.944998))
			setup_custom_raw_spawner(self.world, "onslaught_button_front4", Vector3(58.2951, 213.645, 88.3211), Quaternion.from_elements(0, 0, 0.327077, -0.944998))
			setup_custom_raw_spawner(self.world, "onslaught_button_front5", Vector3(59.3585, 212.433, 88.3211), Quaternion.from_elements(0, 0, 0.327077, -0.944998))
			setup_custom_raw_spawner(self.world, "onslaught_button_front6", Vector3(60.5645, 211.44, 88.3211), Quaternion.from_elements(0, 0, 0.327077, -0.944998))

			local onslaught_sewer_backspawn_S1 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(-33.87, 194.21, 6.5), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_sewer_backspawn_S1, "onslaught_sewer_backspawn", true)

			local onslaught_sewer_backspawn_S2 = World.spawn_unit(self.world, "units/hub_elements/empty", Vector3(-30.42, 202.5, 6.5), Quaternion.identity())
			setup_custom_horde_spawner(onslaught_sewer_backspawn_S2, "onslaught_sewer_backspawn", true)
		elseif level_key == "forest_ambush" then
			setup_custom_raw_spawner(self.world, "onslaught_doomwheel_boss", Vector3(288.65, -103.11, 20.15), Quaternion.from_elements(0, 0, 0.923, -0.385))
		elseif level_key == "dlc_portals" then
			setup_custom_raw_spawner(self.world, "onslaught_haunts_gate_outside1", Vector3(-187.699, 121.229, -42.7434), Quaternion.from_elements(0, 0, -0.825738, -0.564054))
			setup_custom_raw_spawner(self.world, "onslaught_haunts_gate_outside2", Vector3(-184.853, 115.435, -42.4276), Quaternion.from_elements(0, 0, 0.877566, 0.479456))
			setup_custom_raw_spawner(self.world, "onslaught_haunts_ladder_left1", Vector3(-222.542, 97.4479, -39.8397), Quaternion.from_elements(0, 0, -0.107894, -0.994162))
			setup_custom_raw_spawner(self.world, "onslaught_haunts_ladder_right1", Vector3(-216.345, 123.297, -40.3883), Quaternion.from_elements(0, 0, -0.0431467, -0.999069))
			setup_custom_raw_spawner(self.world, "onslaught_haunts_heads_entrance", Vector3(169.767, 15.3043, 23.473), Quaternion.from_elements(0, 0, -0.283956, -0.958837))
			setup_custom_raw_spawner(self.world, "onslaught_haunts_heads_basement", Vector3(147.327, 33.9511, 14.473), Quaternion.from_elements(0, 0, 0.839634, -0.543153))
			setup_custom_raw_spawner(self.world, "onslaught_haunts_heads_stairs1", Vector3(141.089, 46.1345, 21.473), Quaternion.from_elements(0, 0, 0.997354, -0.072703))
			setup_custom_raw_spawner(self.world, "onslaught_haunts_heads_stairs2", Vector3(176.482, 50.5217, 21.473), Quaternion.from_elements(0, 0, 0.995331, -0.0965224))
			setup_custom_raw_spawner(self.world, "onslaught_haunts_heads_HUH", Vector3(168.09, 63.6349, 21.473), Quaternion.from_elements(0, 0, 0.967619, 0.252416))
			setup_custom_raw_spawner(self.world, "onslaught_haunts_heads_portal", Vector3(160.684, 27.8345, 33.9505), Quaternion.from_elements(0, 0, 0.979543, 0.201236))
			setup_custom_raw_spawner(self.world, "onslaught_cw_boss", Vector3(155.452, 21.4905, 22.473), Quaternion.from_elements(0, 0, -0.515968, -0.856608))
		elseif level_key == "cemetery" then
			setup_custom_raw_spawner(self.world, "onslaught_cemetery_entrance", Vector3(17.3989, 62.4018, 1.03521), Quaternion.from_elements(0, 0, 0.756467, -0.654032))
			setup_custom_raw_spawner(self.world, "onslaught_cemetery_chain_2", Vector3(-4.9349, 30.1507, 7.94961), Quaternion.from_elements(0, 0, 0.697321, -0.716759))
			setup_custom_raw_spawner(self.world, "onslaught_cemetery_chain_3", Vector3(14.6237, 58.4006, 8.21216), Quaternion.from_elements(0, 0, -0.796064, -0.605212))
			setup_custom_raw_spawner(self.world, "onslaught_cemetery_chain_4", Vector3(-4.31155, 7.42462, -0.329258), Quaternion.from_elements(0, 0, -0.193463, -0.981108))
		elseif level_key == "magnus" then
			setup_custom_raw_spawner(self.world, "onslaught_magnus_boss_middle", Vector3(-36.0143, 16.1249, 1.22907), Quaternion.from_elements(0, 0, 0.72287, -0.690984))
			setup_custom_raw_spawner(self.world, "onslaught_magnus_boss_end", Vector3(237.319, -137.575, 86.7056), Quaternion.from_elements(0, 0, 0.329146, -0.944279))
			setup_custom_raw_spawner(self.world, "magnus_door_event_guards_02", Vector3(-13.6629, 46.1088, 2.56599), Quaternion.from_elements(0, 0, 0.993663, 0.112399))
			setup_custom_raw_spawner(self.world, "magnus_door_event_guards_03", Vector3(-17.4446, 30.0557, 2.67785), Quaternion.from_elements(0, 0, 0.790158, -0.612903))
		elseif level_key == "nurgle" then
			setup_custom_raw_spawner(self.world, "Festering_loop_event_1", Vector3(-392.981, 80.0522, -4.73371), Quaternion.from_elements(0, 0, 0.0481595, -0.99884))
			setup_custom_raw_spawner(self.world, "Festering_loop_event_2", Vector3(-431.886, 128.557, -0.392142), Quaternion.from_elements(0, 0, 0.890867, -0.454264))
			setup_custom_raw_spawner(self.world, "Festering_escape_event", Vector3(-372.268, 178.556, 8.52977), Quaternion.from_elements(0, 0, 0.37137, -0.928485))
		elseif level_key == "fort" then
			setup_custom_raw_spawner(self.world, "Fort_Big_SV", Vector3(-30.5291, -26.5151, 11.1644), Quaternion.from_elements(0, 0, 0.21516, -0.976579))
		elseif level_key == "dlc_wizards_trail" then
			setup_custom_raw_spawner(self.world, "buffed_enemy_spawn_1", Vector3(142.44, 15.5051, 346.302), Quaternion.from_elements(0, 0, -0.835503, -0.549487))
			setup_custom_raw_spawner(self.world, "buffed_enemy_spawn_2", Vector3(38.835, 43.0437, 352.027), Quaternion.from_elements(0, 0, 0.909436, -0.415844))
			setup_custom_raw_spawner(self.world, "buffed_enemy_spawn_3", Vector3(72.2291, -13.4926, 346), Quaternion.from_elements(0, 0, 0.106025, -0.994363))
		elseif level_key == "dlc_dwarf_exterior" then
			setup_custom_raw_spawner(self.world, "buffed_middle_cold", Vector3(-83.3931, -71.921, 10.6233), Quaternion.from_elements(0, 0, -0.471674, -0.881773))
			setup_custom_raw_spawner(self.world, "rat_ogre_cold_end", Vector3(64.5283, 327.424, 16.0465), Quaternion.from_elements(0, 0, 0.838757, -0.544506))
			setup_custom_raw_spawner(self.world, "underground_spawn_1", Vector3(100.705, 337.225, -1.26965), Quaternion.from_elements(0, 0, 0.916221, 0.400674))
			setup_custom_raw_spawner(self.world, "underground_spawn_2", Vector3(94.4506, 341.345, -0.566808), Quaternion.from_elements(0, 0, 0.965357, 0.260932))
		elseif level_key == "dlc_dwarf_beacons" then
			setup_custom_raw_spawner(self.world, "middle_ogre_beacons", Vector3(-137.338, 54.341, -6.58606), Quaternion.from_elements(0, 0, -0.0367461, -0.999325))
			setup_custom_raw_spawner(self.world, "paratrooper_middle", Vector3(-166.095, 158.79, -27), Quaternion.from_elements(0, 0, 0.998317, 0.0579903))
			setup_custom_raw_spawner(self.world, "beacon_ogre_end", Vector3(109.771, 116.281, -11.3278), Quaternion.from_elements(0, 0, 0.763535, -0.645766))
		end

		local entity_manager = Managers.state.entity
		entity_manager:add_and_register_units(self.world, custom_spawners, #custom_spawners)
	end
end)

-- Nest boss logic
mod:hook(Breeds.skaven_storm_vermin_warlord, "run_on_update", function (func, unit, blackboard, t, dt)
	local side = Managers.state.side.side_by_unit[unit]
	local enemy_player_and_bot_units = side.ENEMY_PLAYER_AND_BOT_UNITS
	local enemy_player_and_bot_positions = side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local self_pos = POSITION_LOOKUP[unit]
	local range = BreedActions.skaven_storm_vermin_champion.special_attack_spin.radius
	local num = 0

	for i, position in ipairs(enemy_player_and_bot_positions) do
		local player_unit = enemy_player_and_bot_units[i]

		if Vector3.distance(self_pos, position) < range and not ScriptUnit.extension(player_unit, "status_system"):is_disabled() and not ScriptUnit.extension(player_unit, "status_system"):is_invisible() then
			num = num + 1
		end
	end

	blackboard.surrounding_players = num

	if blackboard.surrounding_players > 0 then
		blackboard.surrounding_players_last = t
	end
	
	if not blackboard.spawned_at_t then blackboard.spawned_at_t = t end
	
	if not blackboard.has_spawned_initial_wave and blackboard.spawned_at_t + 4 < t then
		local conflict_director = Managers.state.conflict
		
		local strictly_not_close_to_players = true
		local silent = false
		local composition_type = "stronghold_boss_initial_wave"
		local limit_spawners, terror_event_id = nil
		local side_id = side.side_id
		conflict_director.horde_spawner:execute_event_horde(t, terror_event_id, side_id, composition_type, limit_spawners, silent, nil, strictly_not_close_to_players)
		blackboard.has_spawned_initial_wave = true
	end

	if blackboard.trickle_timer and blackboard.trickle_timer < t and not blackboard.defensive_mode_duration then
		local conflict_director = Managers.state.conflict

		if conflict_director:count_units_by_breed("skaven_slave") < 10 then
			local strictly_not_close_to_players = true
			local silent = true
			local composition_type = "stronghold_boss_trickle"
			local limit_spawners, terror_event_id = nil
			local side_id = side.side_id

			conflict_director.horde_spawner:execute_event_horde(t, terror_event_id, side_id, composition_type, limit_spawners, silent, nil, strictly_not_close_to_players)

			blackboard.trickle_timer = t + 8
		else
			blackboard.trickle_timer = t + 2
		end
	end

	local breed = blackboard.breed

	if blackboard.dual_wield_mode then
		local hp = ScriptUnit.extension(blackboard.unit, "health_system"):current_health_percent()
		if blackboard.current_phase == 1 and hp < 0.95 then
			blackboard.current_phase = 2
			blackboard.dual_wield_timer = t + 20
			blackboard.dual_wield_mode = false
		end
	
		if (blackboard.dual_wield_timer < t and not blackboard.active_node) or blackboard.defensive_mode_duration then
			blackboard.dual_wield_timer = t + 20
			blackboard.dual_wield_mode = false
		end
	else
		local hp = ScriptUnit.extension(blackboard.unit, "health_system"):current_health_percent()

		if blackboard.current_phase == 2 and hp < 0.15 then
			blackboard.current_phase = 3
			local new_run_speed = breed.angry_run_speed
			blackboard.run_speed = new_run_speed

			if not blackboard.run_speed_overridden then
				blackboard.navigation_extension:set_max_speed(new_run_speed)
			end
		elseif blackboard.current_phase == 1 and hp < 0.95 then
			blackboard.current_phase = 2
		end

		if blackboard.defensive_mode_duration then
			if not blackboard.defensive_mode_duration_at_t then
				blackboard.defensive_mode_duration_at_t = t + blackboard.defensive_mode_duration - 15
			end

			if blackboard.defensive_mode_duration_at_t <= t then
				blackboard.defensive_mode_duration = nil
				blackboard.defensive_mode_duration_at_t = nil
			else
				blackboard.defensive_mode_duration = t - blackboard.defensive_mode_duration_at_t
				blackboard.dual_wield_mode = false
			end
		elseif blackboard.dual_wield_timer < t and not blackboard.active_node then
			blackboard.dual_wield_mode = true
			blackboard.dual_wield_timer = t + 20
		end
	end

	if blackboard.displaced_units then
		AiUtils.push_intersecting_players(unit, unit, blackboard.displaced_units, breed.displace_players_data, t, dt)
	end
end)

-- Warcamp boss logic
mod:hook(Breeds.chaos_exalted_champion_warcamp, "run_on_update", function (func, unit, blackboard, t, dt)
	local self_pos = POSITION_LOOKUP[unit]
	local breed = blackboard.breed
	local wwise_world = Managers.world:wwise_world(blackboard.world)
	local range = BreedActions.chaos_exalted_champion.special_attack_aoe.radius
	local num = 0
	local player_average_hp = 0
	local side = Managers.state.side.side_by_unit[unit]
	local enemy_player_and_bot_positions = side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local enemy_player_and_bot_units = side.ENEMY_PLAYER_AND_BOT_UNITS

	for i, position in ipairs(enemy_player_and_bot_positions) do
		local player_unit = enemy_player_and_bot_units[i]

		if Vector3.distance(self_pos, position) < range and not ScriptUnit.extension(player_unit, "status_system"):is_disabled() and not ScriptUnit.extension(player_unit, "status_system"):is_invisible() then
			num = num + 1
		end

		if ScriptUnit.extension(player_unit, "status_system"):is_knocked_down() then
			player_average_hp = player_average_hp - 1
		else
			local player_hp = ScriptUnit.extension(player_unit, "health_system"):current_health_percent()
			player_average_hp = player_average_hp + player_hp
		end
	end

	blackboard.surrounding_players = num

	if blackboard.surrounding_players > 0 then
		blackboard.surrounding_players_last = t
	end

	player_average_hp = player_average_hp / 4
	local hp = ScriptUnit.extension(unit, "health_system"):current_health_percent()

	if blackboard.current_phase == 1 and hp < 0.95 then
		local new_run_speed = breed.angry_run_speed
		blackboard.run_speed = new_run_speed

		if not blackboard.run_speed_overridden then
			blackboard.navigation_extension:set_max_speed(new_run_speed)
		end
	end

	if blackboard.override_spawn_allies_call_position then
		if blackboard.current_phase == 1 and hp < 0.9 then
			blackboard.current_phase = 2
			blackboard.trickle_timer = t + 1
		elseif blackboard.current_phase == 2 and hp < 0.4 then
			blackboard.current_phase = 3
		end
	end

	local conflict_director = Managers.state.conflict

	if blackboard.defensive_mode_duration then
		local remaining = blackboard.defensive_mode_duration - dt

		if remaining <= 0 or (remaining <= 15 and conflict_director:enemies_spawned_during_event() <= 20) then
			blackboard.defensive_mode_duration = nil
		elseif remaining <= 15 and conflict_director:count_units_by_breed("chaos_berzerker") < 10 then
			blackboard.defensive_mode_duration = nil
		else
			blackboard.defensive_mode_duration = remaining
		end
	end

	if hp > 0.05 and blackboard.trickle_timer and blackboard.trickle_timer < t and not blackboard.defensive_mode_duration then
		local timer = hp * 15
		timer = math.max(timer, 5)

		if conflict_director:count_units_by_breed("chaos_marauder") < 10 or conflict_director:count_units_by_breed("chaos_berzerker") < 3 then
			local strictly_not_close_to_players = true
			local silent = true
			local composition_type = "warcamp_boss_event_trickle"
			local limit_spawners = nil
			local terror_event_id = "warcamp_boss_minions"
			local side_id = side.side_id

			conflict_director.horde_spawner:execute_event_horde(t, terror_event_id, side_id, composition_type, limit_spawners, silent, nil, strictly_not_close_to_players)

			blackboard.trickle_timer = t + timer
		else
			blackboard.trickle_timer = t + (timer * 2/3)
		end
	end

	if blackboard.displaced_units then
		AiUtils.push_intersecting_players(unit, unit, blackboard.displaced_units, breed.displace_players_data, t, dt)
	end

	AiBreedSnippets.update_exalted_champion_cheer_state(unit, blackboard, t, dt, player_average_hp)

	if blackboard.ray_can_go_update_time < t and Unit.alive(blackboard.target_unit) then
		local nav_world = blackboard.nav_world
		local target_position = POSITION_LOOKUP[blackboard.target_unit]
		blackboard.ray_can_go_to_target = LocomotionUtils.ray_can_go_on_mesh(nav_world, POSITION_LOOKUP[unit], target_position, nil, 1, 1)
		blackboard.ray_can_go_update_time = t + 0.5
	end
end)

--Rasknitt boss logic
mod:hook(BTGreySeerGroundCombatAction, "update_regular_spells", function (func, self, unit, blackboard, t)
	local spell_data = blackboard.spell_data
	local ready_to_summon = nil
	local dialogue_input = ScriptUnit.extension_input(unit, "dialogue_system")
	local warp_lightning_timer = spell_data.warp_lightning_spell_timer
	local vemintide_timer = spell_data.vermintide_spell_timer
	local teleport_timer = spell_data.teleport_spell_timer
	local current_phase = blackboard.current_phase

	if vemintide_timer < t then
		blackboard.current_spell_name = "vermintide"
		ready_to_summon = true
		spell_data.vermintide_spell_timer = t + spell_data.vermintide_spell_cooldown
		local event_data = FrameTable.alloc_table()

		dialogue_input:trigger_networked_dialogue_event("egs_cast_vermintide", event_data)
	elseif warp_lightning_timer < t then
		blackboard.current_spell_name = "warp_lightning"
		ready_to_summon = true
		spell_data.warp_lightning_spell_timer = t + spell_data.warp_lightning_spell_cooldown
		local event_data = FrameTable.alloc_table()

		dialogue_input:trigger_networked_dialogue_event("egs_cast_lightning", event_data)
	end

	return ready_to_summon
end)

mod:hook(AiBreedSnippets, "on_grey_seer_update", function (func, unit, blackboard, t)
	local breed = blackboard.breed
	local mounted_data = blackboard.mounted_data
	local health_extension = ScriptUnit.extension(blackboard.unit, "health_system")
	local hp = health_extension:current_health_percent()
	local hit_reaction_extension = blackboard.hit_reaction_extension
	local position = POSITION_LOOKUP[unit]
	local current_phase = blackboard.current_phase
	local mount_unit = mounted_data.mount_unit
	local network_manager = Managers.state.network
	local game = network_manager:game()
	local go_id = Managers.state.unit_storage:go_id(unit)
	local network_transmit = network_manager.network_transmit
	local dialogue_input = ScriptUnit.extension_input(unit, "dialogue_system")

	if blackboard.intro_timer or current_phase == 6 then
		return
	end

	if blackboard.current_phase ~= 5 and blackboard.death_sequence then
		blackboard.current_phase = 5
		local event_data = FrameTable.alloc_table()

		dialogue_input:trigger_networked_dialogue_event("egs_death_scene", event_data)

		blackboard.face_player_when_teleporting = true
		blackboard.death_sequence = nil
		local strictly_not_close_to_players = true
		local silent = true
		local composition_type = "skittergate_grey_seer_trickle"
		local limit_spawners, terror_event_id = nil
		local conflict_director = Managers.state.conflict

		conflict_director.horde_spawner:execute_event_horde(t, terror_event_id, composition_type, limit_spawners, silent, nil, strictly_not_close_to_players)
	elseif current_phase == 2 and hp < 0.5 then
		blackboard.current_phase = 3
	elseif current_phase == 1 and hp < 0.75 then
		blackboard.current_phase = 2
	end

	if not AiUtils.unit_alive(mount_unit) and blackboard.current_phase ~= 5 and blackboard.current_phase ~= 6 then
		if blackboard.current_phase ~= 4 then
			local event_data = FrameTable.alloc_table()

			dialogue_input:trigger_networked_dialogue_event("egs_stormfiend_dead", event_data)
		end

		blackboard.current_phase = 4
		blackboard.knocked_off_mount = true
		blackboard.call_stormfiend = nil
		blackboard.about_to_mount = nil
		blackboard.should_mount_unit = nil
	end

	if blackboard.unlink_unit then
		blackboard.unlink_unit = nil
		local mount_blackboard = mount_unit and BLACKBOARDS[mount_unit]

		if mount_blackboard then
			mount_blackboard.linked_unit = nil
		end

		blackboard.quick_teleport_timer = t + 10
		blackboard.quick_teleport = nil
		blackboard.hp_at_knocked_off = hp
		local game = Managers.state.network:game()
		local mount_go_id = Managers.state.unit_storage:go_id(mount_unit)

		if game and mount_go_id then
			GameSession.set_game_object_field(game, mount_go_id, "animation_synced_unit_id", 0)
		end
	end

	local call_mount_hp_threshold = 0.25

	if mounted_data.knocked_off_mounted_timer and blackboard.hp_at_knocked_off and call_mount_hp_threshold <= blackboard.hp_at_knocked_off - hp then
		mounted_data.knocked_off_mounted_timer = t
	end

	if blackboard.knocked_off_mount and AiUtils.unit_alive(mount_unit) then
		local mount_blackboard = BLACKBOARDS[mount_unit]
		local mounted_timer_finished = mounted_data.knocked_off_mounted_timer and mounted_data.knocked_off_mounted_timer <= t
		local should_call_stormfiend = not blackboard.call_stormfiend and not mount_blackboard.intro_rage and mounted_timer_finished and not mount_blackboard.goal_position and not mount_blackboard.anim_cb_move

		if should_call_stormfiend then
			blackboard.call_stormfiend = true
		elseif mounted_timer_finished then
			blackboard.about_to_mount = true
			local mount_unit_position = POSITION_LOOKUP[mount_unit]
			local distance_to_goal = Vector3.distance(position, mount_unit_position)

			if distance_to_goal < 2 then
				blackboard.knocked_off_mount = nil
				blackboard.should_mount_unit = true
				blackboard.ready_to_summon = nil
				blackboard.about_to_mount = nil
				blackboard.call_stormfiend = nil
				mount_blackboard.should_mount_unit = true
				local health_extension = ScriptUnit.extension(mount_unit, "health_system")
				local mount_hp = health_extension:current_health_percent()
				mount_blackboard.hp_at_mounted = mount_hp
			end
		end
	end

	if blackboard.trickle_timer and blackboard.trickle_timer < t and not blackboard.defensive_mode_duration and current_phase < 4 then
		local conflict_director = Managers.state.conflict
		local timer = hp * 8

		if blackboard.knocked_off_mount or not AiUtils.unit_alive(mount_unit) then
			timer = timer * 0.5
		end

		if conflict_director:count_units_by_breed("skaven_slave") < 60 then
			local strictly_not_close_to_players = true
			local silent = true
			local composition_type = "skittergate_grey_seer_trickle"
			local limit_spawners, terror_event_id = nil

			conflict_director.horde_spawner:execute_event_horde(t, terror_event_id, composition_type, limit_spawners, silent, nil, strictly_not_close_to_players)

			blackboard.trickle_timer = t + timer
		else
			blackboard.trickle_timer = t + (timer / 2)
		end
	end

	if blackboard.missile_bot_threat_unit then
		local bot_threat_position = POSITION_LOOKUP[blackboard.missile_bot_threat_unit]
		local radius = 2
		local height = 1
		local half_height = height * 0.5
		local size = Vector3(radius, half_height, radius)
		bot_threat_position = bot_threat_position - Vector3.up() * half_height

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(bot_threat_position, "cylinder", size, nil, 1)

		blackboard.missile_bot_threat_unit = nil
	end
end)

--Nurgloth
mod:hook_origin(AiBreedSnippets, "on_chaos_exalted_sorcerer_drachenfels_spawn", function (unit, blackboard)
	local t = Managers.time:time("game")
	local breed = blackboard.breed
	blackboard.next_move_check = 0
	blackboard.max_vortex_units = breed.max_vortex_units
	blackboard.done_casting_timer = 0
	blackboard.spawned_allies_wave = 0
	blackboard.recent_attacker_timer = 0
	blackboard.recent_melee_attacker_timer = 0
	blackboard.health_extension = ScriptUnit.extension(unit, "health_system")
	blackboard.num_portals_alive = 0
	blackboard.tentacle_portal_units = {}
	blackboard.ring_total_cooldown = 20
	blackboard.charge_total_cooldown = 20
	blackboard.teleport_total_cooldown = 10
	blackboard.ring_cooldown = 0
	blackboard.charge_cooldown = 0
	blackboard.ring_summonings_finished = 0
	blackboard.teleport_cooldown = 0
	blackboard.ready_to_summon = true
	blackboard.surrounding_players = 0
	blackboard.aggro_list = {}
	blackboard.ring_pulse_rate = 0
	blackboard.defensive_phase_duration = 0
	blackboard.defensive_phase_max_duration = 10
	local available_spells = breed.available_spells
	local spells = {}
	local spells_lookup = {}
	local physics_world = World.get_data(blackboard.world, "physics_world")
	local level_analysis = Managers.state.conflict.level_analysis
	local node_units = level_analysis.generic_ai_node_units.sorcerer_boss_drachenfels_center
	local center_unit = node_units[1]
	blackboard.no_kill_achievement = true
	blackboard.ring_center_position = Vector3Box(Unit.local_position(center_unit, 0))
	blackboard.spell_count = 0
	local spell = {
		name = "plague_wave",
		plague_wave_timer = t + 10,
		physics_world = physics_world,
		target_starting_pos = Vector3Box(),
		plague_wave_rot = QuaternionBox(),
		search_func = BTChaosExaltedSorcererSkulkAction.update_plague_wave
	}
	blackboard.plague_wave_data = spell
	spells[#spells + 1] = spell
	spells_lookup.plague_wave = spell
	local spell = {
		range = 40,
		magic_missile = true,
		magic_missile_speed = 20,
		true_flight_template_name = "sorcerer_magic_missile",
		projectile_unit_name = "units/weapons/projectile/magic_missile/magic_missile",
		name = "magic_missile",
		launch_angle = 0.7,
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box()
	}
	blackboard.magic_missile_data = spell
	spells[#spells + 1] = spell
	spells_lookup.magic_missile = spell
	local spell = {
		range = 40,
		magic_missile = true,
		magic_missile_speed = 15,
		true_flight_template_name = "sorcerer_strike_missile",
		projectile_unit_name = "units/weapons/projectile/strike_missile/strike_missile",
		name = "sorcerer_strike_missile",
		explosion_template_name = "chaos_strike_missile_impact",
		launch_angle = 1.25,
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box()
	}
	blackboard.sorcerer_strike_missile_data = spell
	spells[#spells + 1] = spell
	spells_lookup.sorcerer_strike_missile = spell
	local spell = {
		range = 40,
		name = "magic_missile_ground",
		magic_missile = true,
		magic_missile_speed = 10,
		target_ground = true,
		projectile_unit_name = "units/weapons/projectile/strike_missile_drachenfels/strike_missile_drachenfels",
		true_flight_template_name = "sorcerer_magic_missile_ground",
		explosion_template_name = "chaos_drachenfels_strike_missile_impact",
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box()
	}
	blackboard.magic_missile_ground_data = spell
	spells[#spells + 1] = spell
	spells_lookup.magic_missile_ground = spell
	local spell = {
		name = "missile_barrage",
		magic_missile = true,
		magic_missile_speed = 20,
		range = 40,
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box()
	}
	blackboard.missile_barrage_data = spell
	spells[#spells + 1] = spell
	spells_lookup.missile_barrage = spell
	local spell = {
		range = 40,
		name = "seeking_bomb_missile",
		magic_missile = true,
		magic_missile_speed = 2.5,
		true_flight_template_name = "sorcerer_slow_bomb_missile",
		projectile_unit_name = "units/weapons/projectile/insect_swarm_missile_drachenfels/insect_swarm_missile_drachenfels_01",
		explosion_template_name = "chaos_slow_bomb_missile_new",
		life_time = 15,
		search_func = BTChaosExaltedSorcererSkulkAction.update_cast_missile,
		throw_pos = Vector3Box(),
		target_direction = Vector3Box(),
		projectile_size = {
			3,
			3,
			3
		}
	}
	blackboard.seeking_bomb_missile_data = spell
	spells[#spells + 1] = spell
	spells_lookup.seeking_bomb_missile = spell
	local spell = {
		name = "dummy",
		search_func = BTChaosExaltedSorcererSkulkAction.update_dummy
	}
	blackboard.dummy_data = spell
	spells[#spells + 1] = spell
	spells_lookup.dummy = spell
	local id_lookup = Managers.state.entity:system("spawner_system")._id_lookup
	local level_analysis = Managers.state.conflict.level_analysis
	local center_node_units = level_analysis.generic_ai_node_units.sorcerer_boss_drachenfels_center
	local wall_node_units = level_analysis.generic_ai_node_units.sorcerer_boss_drachenfels_wall
	local level_has_boss_arena = center_node_units and wall_node_units and id_lookup.sorcerer_boss_drachenfels and id_lookup.sorcerer_boss_drachenfels_minion

	if level_has_boss_arena then
		local center_marker = center_node_units[1]
		blackboard.in_boss_arena = Vector3.distance(POSITION_LOOKUP[unit], Unit.local_position(center_marker, 0)) < 20
	else
		blackboard.in_boss_arena = false
	end

	if blackboard.in_boss_arena then
		blackboard.spawners = {
			sorcerer_boss_center = center_node_units
		}
		blackboard.mode = "setup"
		blackboard.intro_timer = t + 12.3
		local center_unit = center_node_units[1]
		local arena_center_pos = Unit.local_position(center_unit, 0) + Vector3(0, 0, 0.75)
		local arena_rot = Unit.local_rotation(center_unit, 0)
		local arena_pose_box = Matrix4x4Box(Matrix4x4.from_quaternion_position(arena_rot, arena_center_pos))
		blackboard.arena_pose_boxed = arena_pose_box
		blackboard.arena_half_extents = Vector3Box(12, 12, 1)

		blackboard.valid_teleport_pos_func = function (pos, blackboard)
			local pose = blackboard.arena_pose_boxed:unbox()
			local half_extents = blackboard.arena_half_extents:unbox()
			local inside = math.point_is_inside_oobb(pos, pose, half_extents)

			return inside
		end
	else
		blackboard.phase = "offensive"

		blackboard.valid_teleport_pos_func = function (pos, blackboard)
			return true
		end

		print("Sorcerer boss not in arena")
	end

	local side = Managers.state.side:get_side_from_name("heroes")
	local player_units = side.PLAYER_AND_BOT_UNITS

	for _, player_unit in pairs(player_units) do
		local health_extension = ScriptUnit.extension(player_unit, "health_system")
		health_extension.is_invincible = true
	end

	blackboard.spells = spells
	blackboard.spells_lookup = spells_lookup
	local breed = blackboard.breed
	local audio_system_extension = Managers.state.entity:system("audio_system")

	if breed.teleport_sound_event then
		audio_system_extension:play_audio_unit_event(breed.teleport_sound_event, unit)
	end

	local conflict_director = Managers.state.conflict

	conflict_director:add_unit_to_bosses(unit)

	blackboard.is_valid_target_func = GenericStatusExtension.is_lord_target
end)
local leech_spawn_count = 0
mod:hook(BTSpawnAllies, "_spawn", function (func, self, unit, data, blackboard, t)
	func(self, unit, data, blackboard, t)

	local comp = blackboard.action.name

	if comp == "spawn_allies_defensive" or comp == "spawn_allies_devensive_intense" then
		local conflict_director = Managers.state.conflict
		local hidden_pos = conflict_director.specials_pacing:get_special_spawn_pos()

		conflict_director:spawn_one(Breeds.skaven_pack_master, hidden_pos)
		conflict_director:spawn_one(Breeds.skaven_pack_master, hidden_pos)
	elseif comp == "spawn_allies_offensive" then
		local conflict_director = Managers.state.conflict
		local hidden_pos = conflict_director.specials_pacing:get_special_spawn_pos()

		conflict_director:spawn_one(Breeds.chaos_corruptor_sorcerer, hidden_pos)
		conflict_director:spawn_one(Breeds.chaos_corruptor_sorcerer, hidden_pos)
	elseif comp == "spawn_allies_trickle" then
		if leech_spawn_count == 2 then
			leech_spawn_count = 0
		else
			local conflict_director = Managers.state.conflict
			local hidden_pos = conflict_director.specials_pacing:get_special_spawn_pos()

			conflict_director:spawn_one(Breeds.chaos_corruptor_sorcerer, hidden_pos)

			leech_spawn_count = leech_spawn_count + 1
		end
	end
end)

mod:hook_origin(BTChaosSorcererSummoningAction, "update_boss_rings", function(self, unit, blackboard, t, dt)
	local world = blackboard.world
	local action = blackboard.action
	local ring_sequence = action.ring_sequence
	local all_done = true
	local colors = {
		Color(255, 0, 0),
		Color(255, 0, 0),
	}

	for i, ring in ipairs(ring_sequence) do
		local done = ring.done

		if not done then
			if ring.delay and ring.delay > 0 then
				ring.delay = ring.delay - 1
			end
			ring.delay_time = ring.delay_time or ring.delay + t or t

			if t >= ring.delay_time and not ring.damage_effect_time then
				if debug and ring.delay > 0 then
					QuickDrawerStay:reset()
				end

				local premonition_type = ring.premination
				local ring_info = action.ring_info
				local origin_pos = Vector3Box.unbox(blackboard.ring_center_position)
				local ring_position = ring.position
				local max_radius = ring_info[ring_position].max_radius
				local min_radius = ring_info[ring_position].min_radius
				local premonition_time = premonition_type == "short" and 1 or premonition_type == "medium" and 2 or premonition_type == "long" and 2 or 0.75
				local premonition_effect = premonition_type == "short" and ring_info[ring_position].premonition_effect_name_short or premonition_type == "medium" and ring_info[ring_position].premonition_effect_name_medium or premonition_type == "long" and ring_info[ring_position].premonition_effect_name_long

				if premonition_effect then
					Managers.state.network:rpc_play_particle_effect_no_rotation(nil, NetworkLookup.effects[premonition_effect], NetworkConstants.invalid_game_object_id, 0, origin_pos, false)
				end

				local vector_max = Vector3(max_radius, 0, 0)
				local vector_min = Vector3(min_radius, 0, 0)

				if debug then
					for j = 1, 360 do
						vector_max = Quaternion.rotate(Quaternion.from_euler_angles_xyz(0, 0, 1), vector_max)
						vector_min = Quaternion.rotate(Quaternion.from_euler_angles_xyz(0, 0, 1), vector_min)

						QuickDrawerStay:line(origin_pos + vector_max + Vector3.up() * 0.6, origin_pos + vector_min + Vector3.up() * 0.1, colors[i % 2 + 1])
					end
				end

				fassert(premonition_type, "No or invalid premonition type")

				ring.damage_effect_time = t + premonition_time
			elseif ring.damage_effect_time and t >= ring.damage_effect_time and not ring.premonition_time then
				local ring_info = action.ring_info
				local ring_position = ring.position
				local origin_pos = Vector3Box.unbox(blackboard.ring_center_position)
				local effect_name = ring_info[ring_position].damage_effect_name

				if effect_name then
					Managers.state.network:rpc_play_particle_effect_no_rotation(nil, NetworkLookup.effects[effect_name], NetworkConstants.invalid_game_object_id, 0, origin_pos, false)
				end

				ring.premonition_time = t
			elseif ring.premonition_time and t >= ring.premonition_time then
				local ring_position = ring.position
				local ring_info = action.ring_info
				local origin_pos = Vector3Box.unbox(blackboard.ring_center_position)
				local inner_radius = ring_info[ring_position].min_radius
				local outer_radius = ring_info[ring_position].max_radius
				local audio_system = Managers.state.entity:system("audio_system")

				audio_system:play_audio_position_event(action.damage_sound_event, origin_pos)

				if blackboard.summoning_start_event_playing then
					blackboard.summoning_start_event_playing = nil

					local wwise_world = Managers.world:wwise_world(blackboard.world)

					audio_system:_play_event_with_source(wwise_world, action.end_ability_sound_event, blackboard.audio_source_id)
					WwiseWorld.destroy_manual_source(wwise_world, blackboard.audio_source_id)
				end

				local nearby_ais = {}
				local side = Managers.state.side:get_side_from_name("heroes")
				local player_units = side.PLAYER_AND_BOT_UNITS
				local catapult_strength = ( ring.catapult_strength / 2 )

				AiUtils.broadphase_query(origin_pos, outer_radius, nearby_ais)

				local inner_squared = inner_radius * inner_radius
				local outer_squared = outer_radius * outer_radius

				for _, hit_unit in ipairs(nearby_ais) do
					local position = POSITION_LOOKUP[hit_unit]
					local distance_squared = Vector3.distance_squared(position, origin_pos)

					if inner_squared < distance_squared and hit_unit ~= unit then
						local damage_profile_name = action.damage_profile_name
						local damage_profile = DamageProfileTemplates[damage_profile_name]
						local difficulty_rank = Managers.state.difficulty:get_difficulty()
						local actual_power_level = action.power_level[difficulty_rank]
						local hit_ragdoll_actor, boost_curve_multiplier, is_critical_strike, added_dot, first_hit, total_hits, backstab_multiplier
						local source_attacker_unit = unit

						DamageUtils.add_damage_network_player(damage_profile, nil, actual_power_level, hit_unit, unit, "torso", POSITION_LOOKUP[hit_unit], Vector3.up(), "undefined", hit_ragdoll_actor, boost_curve_multiplier, is_critical_strike, added_dot, first_hit, total_hits, backstab_multiplier, source_attacker_unit)
					end
				end

				for _, player_unit in ipairs(player_units) do
					local position = POSITION_LOOKUP[player_unit]
					local distance_squared = Vector3.distance_squared(position, origin_pos)
					local catapult_direction = ring.catapult_direction
					local direction = catapult_direction == "in" and origin_pos - position or position - origin_pos

					direction = Vector3.normalize(direction)

					if distance_squared < outer_squared and inner_squared < distance_squared then
						local damage_profile_name = action.damage_profile_name
						local damage_profile = DamageProfileTemplates[damage_profile_name]
						local difficulty_rank = Managers.state.difficulty:get_difficulty()
						local player = Managers.player:owner(player_unit)
						local is_bot = player and not player:is_player_controlled()
						local actual_power_level = is_bot and 0 or action.power_level[difficulty_rank]

						DamageUtils.add_damage_network_player(damage_profile, nil, actual_power_level, player_unit, unit, "torso", POSITION_LOOKUP[player_unit], Vector3.up(), "undefined")

						if catapult_strength then
							StatusUtils.set_catapulted_network(player_unit, true, (direction + Vector3.up()) * catapult_strength)
						end

						blackboard.hit_by_eruptions = true
					end
				end

				ring.done = true
			else
				all_done = false

				break
			end

			if not ring.done then
				all_done = false
			end
		end
	end

	if all_done then
		return true
	end
end)


-- Because it's crashy in here
mod:hook(AiUtils, "push_intersecting_players", function (func, unit, source_unit, displaced_units, data, t, dt, hit_func, ...)
	local side = Managers.state.side.side_by_unit[source_unit or unit]
	if side then
		func(unit, source_unit, displaced_units, data, t, dt, hit_func, ...)
	end
end)

mutator.start = function()

	mutator.OriginalTerrorEventBlueprints = table.clone(TerrorEventBlueprints)
	mutator.OriginalHordeCompositions = table.clone(HordeCompositions)
	mutator.OriginalHordeCompositionsPacing = table.clone(HordeCompositionsPacing)
	mutator.OriginalBreedPacks = table.clone(BreedPacks)
	mutator.OriginalPackSpawningSettings = table.clone(PackSpawningSettings)
	mutator.OriginalRecycleSettings  = table.clone(RecycleSettings)
	mutator.OriginalPacingSettingsDefault = table.clone(PacingSettings.default)
	mutator.OriginalPacingSettingsChaos = table.clone(PacingSettings.chaos)
	mutator.OriginalPacingSettingsBeastmen = table.clone(PacingSettings.beastmen)
	mutator.OriginalSpecialsSettings = table.clone(SpecialsSettings)
	mutator.OriginalBossSettings = table.clone(BossSettings)
	mutator.OriginalBreedActions = table.clone(BreedActions)
	mutator.OriginalThreatValue = {}
	for name, breed in pairs(Breeds) do
		if breed.threat_value then
			mutator.OriginalThreatValue[name] = breed.threat_value
		end
	end

	mutator.OriginalBeastmenBannerBuff = BuffTemplates.healing_standard.buffs

	mod:dofile("scripts/mods/DutchSpice/SpicyEnemies/Ambients")

	--Mutator changes
	MutatorTemplates.lightning_strike.max_spawns = 10000
	MutatorTemplates.lightning_strike.spawn_rate = 20
	ExplosionTemplates.lightning_strike_twitch.explosion.power_level = 500

	--Enemy changes
	Breeds.skaven_storm_vermin.bloodlust_health = BreedTweaks.bloodlust_health.beastmen_elite
	Breeds.skaven_storm_vermin.primary_armor_category = 6
	Breeds.skaven_storm_vermin.size_variation_range = { 1.23, 1.25 }
	Breeds.skaven_storm_vermin.max_health = BreedTweaks.max_health.bestigor
	Breeds.skaven_storm_vermin.hit_mass_counts = BreedTweaks.hit_mass_counts.bestigor
	BuffTemplates.healing_standard.buffs = {
		{
			multiplier = 0.25,
			stat_buff = "damage_dealt",
			name = "curse_khorne_champions_damage_buff",
			max_stacks = 1
		}
	}
	BuffTemplates.cursed_chest_objective_unit.buffs = {
		{
			apply_buff_func = "apply_cursed_chest_init",
			name = "cursed_chest_init",
		}
	}
	BeastmenStandardTemplates.healing_standard.radius = 10
	UtilityConsiderations.beastmen_place_standard.distance_to_target.max_value = 15

	if mod:get("enhanced_specials") then
		BreedActions.skaven_ratling_gunner.shoot_ratling_gun.fire_rate_at_start = 20
		BreedActions.skaven_ratling_gunner.shoot_ratling_gun.fire_rate_at_end = 35
		BreedActions.skaven_ratling_gunner.shoot_ratling_gun.ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true
		}
		BreedActions.skaven_poison_wind_globadier.throw_poison_globe.time_between_throws = {
			6,
			2
		}
		Breeds.skaven_warpfire_thrower.run_speed = 6
		Breeds.skaven_warpfire_thrower.max_health = BreedTweaks.max_health.stormvermin
		BreedActions.skaven_warpfire_thrower.shoot_warpfire_thrower.hit_radius = 1
		BreedActions.skaven_warpfire_thrower.shoot_warpfire_thrower.warpfire_follow_target_speed = 1.25
		BreedActions.skaven_warpfire_thrower.shoot_warpfire_thrower.ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true
		}
		BreedActions.chaos_corruptor_sorcerer.grab_attack.ignore_staggers = {
			true,
			true,
			true,
			true,
			true,
			true
		}
		BreedActions.chaos_corruptor_sorcerer.grab_attack.drain_life_tick_rate = 0.5
		BreedActions.chaos_corruptor_sorcerer.skulk_approach.teleport_cooldown = {
			3,
			3
		}
		BreedActions.chaos_corruptor_sorcerer.skulk_approach.initial_skulk_time = {
			4,
			5
		}
		BreedActions.chaos_corruptor_sorcerer.skulk_approach.skulk_time = {
			1,
			2
		}
	end

	--Non-event settings and compositions
	RecycleSettings.max_grunts = 165
	RecycleSettings.push_horde_if_num_alive_grunts_above = 300
	PackSpawningSettings.default.area_density_coefficient = 0.15
	PackSpawningSettings.default_light.area_density_coefficient = 0.15
	PackSpawningSettings.skaven.area_density_coefficient = 0.15
	PackSpawningSettings.skaven_light.area_density_coefficient = 0.15
	PackSpawningSettings.chaos.area_density_coefficient = 0.15
	PackSpawningSettings.chaos_light.area_density_coefficient = 0.15
	PackSpawningSettings.beastmen.area_density_coefficient = 0.15
	PackSpawningSettings.beastmen_light.area_density_coefficient = 0.15
	PackSpawningSettings.skaven_beastmen.area_density_coefficient = 0.15
	PackSpawningSettings.chaos_beastmen.area_density_coefficient = 0.15
	PackSpawningSettings.default.roaming_set.breed_packs_override = {
		{
			"shield_rats",
			8,
			0.08
		},
		{
			"plague_monks",
			15,
			0.08
		},
		{
			"marauders",
			8,
			0.08
		},
		{
			"marauders_elites",
			10,
			0.20
		}
	}
	PackSpawningSettings.default_light.roaming_set.breed_packs_override = {
		{
			"shield_rats",
			8,
			0.09
		},
		{
			"plague_monks",
			15,
			0.15
		},
		{
			"marauders",
			8,
			0.09
		},
		{
			"marauders_elites",
			8,
			0.15
		}
	}
	PackSpawningSettings.skaven.roaming_set.breed_packs_override = {
		{
			"shield_rats",
			4,
			0.20
		},
		{
			"plague_monks",
			15,
			0.25
		}
	}
	PackSpawningSettings.skaven_light.roaming_set.breed_packs_override = {
		{
			"shield_rats",
			4,
			0.20
		},
		{
			"plague_monks",
			15,
			0.08
		}
	}
	PackSpawningSettings.chaos.roaming_set.breed_packs_override = {
		{
			"marauders_and_warriors",
			15,
			0.20
		},
		{
			"marauders_shields",
			8,
			0.12
		},
		{
			"marauders_elites",
			8,
			0.20
		},
		{
			"marauders_berzerkers",
			10,
			0.20
		}
	}
	PackSpawningSettings.chaos_light.roaming_set.breed_packs_override = {
		{
			"marauders_and_warriors",
			9,
			0.20
		},
		{
			"marauders_shields",
			8,
			0.06
		},
		{
			"marauders_elites",
			12,
			0.20
		},
		{
			"marauders_berzerkers",
			10,
			0.20
		}
	}
	PackSpawningSettings.beastmen.roaming_set.breed_packs_override = {
		{
			"beastmen_elites",
			20,
			0.25
		},
		{
			"beastmen",
			3,
			0.08
		},
		{
			"beastmen_light",
			3,
			0.08
		}
	}
	PackSpawningSettings.beastmen_light.roaming_set.breed_packs_override = {
		{
			"beastmen_light",
			6,
			0.08
		}
	}
	PackSpawningSettings.skaven_beastmen.roaming_set.breed_packs_override = {
		{
			"shield_rats",
			4,
			0.20
		},
		{
			"plague_monks",
			13,
			0.15
		},
		{
			"beastmen",
			5,
			0.08
		},
		{
			"beastmen_elites",
			15,
			0.25
		}
	}
	PackSpawningSettings.chaos_beastmen.roaming_set.breed_packs_override = {
		{
			"marauders",
			6,
			0.08
		},
		{
			"marauders_elites",
			13,
			0.20
		},
		{
			"beastmen",
			5,
			0.08
		},
		{
			"beastmen_elites",
			13,
			0.2
		}
	}
	PackSpawningSettings.default.difficulty_overrides = nil
	PackSpawningSettings.skaven.difficulty_overrides = nil
	PackSpawningSettings.skaven_light.difficulty_overrides = nil
	PackSpawningSettings.chaos.difficulty_overrides = nil
	PackSpawningSettings.beastmen.difficulty_overrides = nil
	PackSpawningSettings.skaven_beastmen.difficulty_overrides = nil
	PackSpawningSettings.chaos_beastmen.difficulty_overrides = nil

	PacingSettings.default.peak_fade_threshold = 110
	PacingSettings.default.peak_intensity_threshold = 120
	PacingSettings.default.sustain_peak_duration = { 5, 10 }
	PacingSettings.default.relax_duration = { 7, 10 }
	PacingSettings.default.horde_frequency = { 30, 45 }
	PacingSettings.default.multiple_horde_frequency = { 6, 9 }
	PacingSettings.default.max_delay_until_next_horde = { 60, 72 }
	PacingSettings.default.horde_startup_time = { 10, 20 }

	PacingSettings.default.mini_patrol.only_spawn_above_intensity = 0
	PacingSettings.default.mini_patrol.only_spawn_below_intensity = 900
	PacingSettings.default.mini_patrol.frequency = { 6, 10 }

	PacingSettings.default.difficulty_overrides = nil

	PacingSettings.chaos.peak_fade_threshold = 110
	PacingSettings.chaos.peak_intensity_threshold = 120
	PacingSettings.chaos.sustain_peak_duration = { 5, 10 }
	PacingSettings.chaos.relax_duration = { 10, 13 }
	PacingSettings.chaos.horde_frequency = { 30, 45 }
	PacingSettings.chaos.multiple_horde_frequency = { 6, 9 }
	PacingSettings.chaos.max_delay_until_next_horde = { 70, 90 }
	PacingSettings.chaos.horde_startup_time = { 10, 20 }
	PacingSettings.chaos.multiple_hordes = 3

	PacingSettings.chaos.mini_patrol.only_spawn_above_intensity = 0
	PacingSettings.chaos.mini_patrol.only_spawn_below_intensity = 900
	PacingSettings.chaos.mini_patrol.frequency = { 6, 10 }

	PacingSettings.chaos.difficulty_overrides = nil
	
	PacingSettings.beastmen.peak_fade_threshold = 110
	PacingSettings.beastmen.peak_intensity_threshold = 120
	PacingSettings.beastmen.sustain_peak_duration = { 5, 10 }
	PacingSettings.beastmen.relax_duration = { 10, 13 }
	PacingSettings.beastmen.horde_frequency = { 35, 50 }
	PacingSettings.beastmen.multiple_horde_frequency = { 6, 9 }
	PacingSettings.beastmen.max_delay_until_next_horde = { 75, 95 }
	PacingSettings.beastmen.horde_startup_time = { 10, 20 }

	PacingSettings.beastmen.mini_patrol.only_spawn_above_intensity = 0
	PacingSettings.beastmen.mini_patrol.only_spawn_below_intensity = 900
	PacingSettings.beastmen.mini_patrol.frequency = { 6, 10 }

	PacingSettings.beastmen.difficulty_overrides = nil

	HordeCompositionsPacing.small = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"skaven_slave",
				{
					8,
					10
				},
				"skaven_clan_rat",
				{
					12,
					14
				}
			}
		},
		{
			name = "shielders",
			weight = 7,
			breeds = {
				"skaven_slave",
				{
					10,
					12
				},
				"skaven_clan_rat_with_shield",
				{
					7,
					8
				}
			}
		},
		sound_settings = HordeCompositionsSoundSettings.skaven
	}
	HordeCompositionsPacing.medium = {
		{
			name = "plain",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					15,
					20
				},
				"skaven_clan_rat",
				{
					26,
					30
				}
			}
		},
		{
			name = "shielders",
			weight = 7,
			breeds = {
				"skaven_slave",
				{
					16,
					20
				},
				"skaven_clan_rat",
				{
					10,
					12
				}
			}
		},
		{
			name = "leader",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					15,
					20
				},
				"skaven_clan_rat",
				{
					18,
					20
				}

			}
		},
		sound_settings = HordeCompositionsSoundSettings.skaven
	}
	HordeCompositionsPacing.large = {
		{
			name = "plain",
			weight = 2,
			breeds = {
				"skaven_slave",
				{
					15,
					20
				},
				"skaven_clan_rat",
				{
					35,
					42
				}
			}
		},
		{
			name = "shielders",
			weight = 7,
			breeds = {
				"skaven_clan_rat",
				{
					40,
					42
				},
				"skaven_clan_rat_with_shield",
				{
					10,
					12
				}
			}
		},
		{
			name = "leader",
			weight = 6,
			breeds = {
				"skaven_slave",
				{
					15,
					20
				},
				"skaven_clan_rat",
				{
					20,
					22
				},
				"skaven_storm_vermin_commander",
				{
					5,
					6
				},
				"skaven_plague_monk",
				{
					2,
					3
				}
				
			}
		},
		{
			name = "shielders_heavy",
			weight = 2,
			breeds = {
				"skaven_slave",
				{
					20,
					30
				},
				"skaven_clan_rat",
				{
					10,
					12
				},
				"skaven_clan_rat_with_shield",
				{
					10,
					15
				},
				"skaven_storm_vermin_with_shield",
				{
					3,
					4
				},
				"skaven_plague_monk",
				{
					3,
					4
				}
			}
		},
		sound_settings = HordeCompositionsSoundSettings.skaven
	}
	HordeCompositionsPacing.huge = {
		{
			name = "plain",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					30,
					34
				},
				"skaven_clan_rat",
				{
					28,
					32
				},
				"skaven_plague_monk",
				{
					9,
					10
				}
			}
		},
		{
			name = "shielders",
			weight = 7,
			breeds = {
				"skaven_slave",
				{
					12,
					16
				},
				"skaven_clan_rat",
				{
					20,
					25
				},
				"skaven_clan_rat_with_shield",
				{
					18,
					20
				},
				"skaven_storm_vermin_commander",
				{
					3,
					4
				},
				"skaven_plague_monk",
				{
					3,
					4
				}
			}
		},
		{
			name = "leader",
			weight = 6,
			breeds = {
				"skaven_slave",
				{
					20,
					22
				},
				"skaven_clan_rat",
				{
					30,
					35
				},
				"skaven_storm_vermin_commander",
				{
					5,
					6
				},
				"skaven_storm_vermin",
				{
					1,
					2
				}
			}
		},
		{
			name = "shielders_heavy",
			weight = 2,
			breeds = {
				"skaven_slave",
				{
					22,
					28
				},
				"skaven_clan_rat",
				{
					20,
					22
				},
				"skaven_clan_rat_with_shield",
				{
					8,
					10
				},
				"skaven_storm_vermin_with_shield",
				{
					2,
					3
				},
				"skaven_storm_vermin_commander",
				{
					4,
					5
				}
			}
		},
		sound_settings = HordeCompositionsSoundSettings.skaven
	}
	HordeCompositionsPacing.huge_shields = {
		{
			name = "plain",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					20,
					22
				},
				"skaven_clan_rat",
				{
					30,
					34
				},
				"skaven_clan_rat_with_shield",
				{
					7,
					9
				},
				"skaven_storm_vermin_commander",
				{
					3,
					4
				},
				"skaven_plague_monk",
				{
					2,
					3
				}
			}
		},
		{
			name = "shielders",
			weight = 7,
			breeds = {
				"skaven_slave",
				{
					20,
					22
				},
				"skaven_clan_rat",
				{
					26,
					28
				},
				"skaven_clan_rat_with_shield",
				{
					12,
					14
				},
				"skaven_plague_monk",
				{
					3,
					4
				},
				"skaven_storm_vermin_commander",
				{
					3,
					4
				}
			}
		},
		{
			name = "leader",
			weight = 6,
			breeds = {
				"skaven_slave",
				{
					20,
					24
				},
				"skaven_clan_rat",
				{
					24,
					28
				},
				"skaven_storm_vermin_commander",
				{
					3,
					4
				},
				"skaven_clan_rat_with_shield",
				{
					6,
					8
				},
				"skaven_plague_monk",
				{
					4,
					5
				}
			}
		},
		{
			name = "shielders_heavy",
			weight = 2,
			breeds = {
				"skaven_slave",
				{
					22,
					24
				},
				"skaven_clan_rat",
				{
					14,
					16
				},
				"skaven_clan_rat_with_shield",
				{
					18,
					20
				},
				"skaven_storm_vermin_commander",
				{
					3,
					4
				},
				"skaven_storm_vermin_with_shield",
				{
					3,
					4
				}
			}
		},
		sound_settings = HordeCompositionsSoundSettings.skaven
	}
	HordeCompositionsPacing.huge_armor = {
		{
			name = "plain",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					36,
					40
				},
				"skaven_clan_rat",
				{
					10,
					14
				},
				"skaven_storm_vermin",
				{
					3,
					4
				},
				"skaven_dummy_slave",
				{
					3,
					4
				},
			}
		},
		{
			name = "shielders",
			weight = 7,
			breeds = {
				"skaven_slave",
				{
					18,
					22
				},
				"skaven_clan_rat",
				{
					24,
					26
				},
				"skaven_clan_rat_with_shield",
				{
					7,
					9
				},
				"skaven_storm_vermin_commander",
				{
					3,
					4
				},
				"skaven_storm_vermin",
				{
					2,
					3
				},
			}
		},
		{
			name = "leader",
			weight = 6,
			breeds = {
				"skaven_slave",
				{
					22,
					24
				},
				"skaven_clan_rat",
				{
					20,
					22
				},
				"skaven_clan_rat_with_shield",
				{
					7,
					9
				},
				"skaven_storm_vermin_commander",
				{
					7,
					8
				}
			}
		},
		{
			name = "shielders_heavy",
			weight = 2,
			breeds = {
				"skaven_slave",
				{
					18,
					20
				},
				"skaven_clan_rat",
				{
					20,
					22
				},
				"skaven_clan_rat_with_shield",
				{
					3,
					5
				},
				"skaven_storm_vermin_commander",
				{
					4,
					5
				},
				"skaven_storm_vermin_with_shield",
				{
					3,
					4
				}
			}
		},
		sound_settings = HordeCompositionsSoundSettings.skaven
	}
	HordeCompositionsPacing.huge_berzerker = {
		{
			name = "plain",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					24,
					26
				},
				"skaven_clan_rat",
				{
					28,
					30
				},
				"skaven_plague_monk",
				{
					7,
					8
				}
			}
		},
		{
			name = "shielders",
			weight = 7,
			breeds = {
				"skaven_slave",
				{
					28,
					32
				},
				"skaven_clan_rat",
				{
					26,
					30
				},
				"skaven_clan_rat_with_shield",
				{
					5,
					7
				},
				"skaven_plague_monk",
				{
					7,
					8
				}
			}
		},
		{
			name = "leader",
			weight = 6,
			breeds = {
				"skaven_slave",
				{
					24,
					26
				},
				"skaven_clan_rat",
				{
					20,
					22
				},
				"skaven_clan_rat_with_shield",
				{
					7,
					9
				},
				"skaven_storm_vermin_commander",
				{
					3,
					4
				},
				"skaven_plague_monk",
				{
					4,
					5
				}
			}
		},
		{
			name = "shielders_heavy",
			weight = 2,
			breeds = {
				"skaven_slave",
				{
					15,
					18
				},
				"skaven_clan_rat",
				{
					20,
					22
				},
				"skaven_clan_rat_with_shield",
				{
					3,
					5
				},
				"skaven_storm_vermin_with_shield",
				{
					3,
					4
				},
				"skaven_plague_monk",
				{
					4,
					5
				}
			}
		},
		sound_settings = HordeCompositionsSoundSettings.skaven
	}
	HordeCompositionsPacing.chaos_medium = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_marauder",
				{
					3,
					4
				},
				"chaos_fanatic",
				{
					15,
					20
				}
			}
		},
		{
			name = "zerkers",
			weight = 5,
			breeds = {
				"chaos_fanatic",
				{
					15,
					20
				},
				"chaos_berzerker",
				{
					1,
					1
				}
			}
		},
		{
			name = "shielders",
			weight = 2,
			breeds = {
				"chaos_fanatic",
				{
					15,
					20
				},
				"chaos_marauder_with_shield",
				{
					1,
					3
				}
			}
		},
		{
			name = "leader",
			weight = 4,
			breeds = {
				"chaos_fanatic",
				{
					15,
					20
				},
				"chaos_raider",
				{
					1,
					1
				}
			}
		},
		sound_settings = HordeCompositionsSoundSettings.chaos
	}
	HordeCompositionsPacing.chaos_large = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_marauder",
				{
					5,
					6
				},
				"chaos_fanatic",
				{
					20,
					25
				}
			}
		},
		{
			name = "zerker",
			weight = 5,
			breeds = {
				"chaos_fanatic",
				{
					20,
					25
				},
				"chaos_berzerker",
				{
					2,
					3
				}
			}
		},
		{
			name = "shielders",
			weight = 2,
			breeds = {
				"chaos_fanatic",
				{
					20,
					25
				},
				"chaos_marauder_with_shield",
				{
					3,
					4
				}
			}
		},
		{
			name = "leader",
			weight = 4,
			breeds = {
				"chaos_fanatic",
				{
					20,
					25
				},
				"chaos_raider",
				{
					2,
					2
				}
			}
		},
		{
			name = "frenzy",
			weight = 2,
			breeds = {
				"chaos_fanatic",
				{
					20,
					22
				},
				"chaos_raider",
				{
					1,
					1
				},
				"chaos_berzerker",
				{
					1,
					2
				},
				"chaos_marauder_with_shield",
				{
					1,
					2
				},
			}
		},
		sound_settings = HordeCompositionsSoundSettings.chaos
	}
	HordeCompositionsPacing.chaos_huge = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_fanatic",
				{
					14,
					16
				},
				"chaos_marauder",
				{
					19,
					21
				},
				"skaven_dummy_clan_rat",
				{
					6,
					8
				},
				"chaos_raider",
				{
					4,
					5
				},
				"chaos_warrior",
				1
			}
		},
		{
			name = "zerker",
			weight = 5,
			breeds = {
				"chaos_fanatic",
				{
					18,
					20
				},
				"chaos_marauder",
				{
					14,
					16
				},

				"skaven_dummy_clan_rat",
				{
					8,
					10
				},
				"chaos_berzerker",
				{
					6,
					7
				}
			}
		},
		{
			name = "shielders",
			weight = 2,
			breeds = {
				"chaos_fanatic",
				{
					10,
					12
				},
				"chaos_marauder",
				{
					8,
					10
				},
				"chaos_marauder_with_shield",
				{
					12,
					13
				},
				"skaven_dummy_clan_rat",
				{
					6,
					7
				},
				"chaos_raider",
				{
					4,
					5
				},
				"chaos_warrior",
				1,
			}
		},
		{
			name = "leader",
			weight = 4,
			breeds = {
				"chaos_fanatic",
				{
					16,
					18
				},
				"chaos_marauder",
				{
					18,
					20
				},
				"chaos_raider",
				{
					6,
					8
				},
				"chaos_warrior",
				1
			}
		},
		{
			name = "frenzy",
			weight = 2,
			breeds = {
				"chaos_fanatic",
				{
					10,
					12
				},
				"chaos_marauder",
				{
					12,
					14
				},
				"chaos_raider",
				{
					3,
					4
				},
				"chaos_berzerker",
				{
					3,
					4
				},
				"chaos_marauder_with_shield",
				{
					5,
					6
				},
				"skaven_dummy_clan_rat",
				{
					10,
					12
				},
			}
		},
		sound_settings = HordeCompositionsSoundSettings.chaos
	}
	HordeCompositionsPacing.chaos_huge_shields = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_fanatic",
				{
					20,
					22
				},
				"chaos_marauder",
				{
					15,
					16
				},
				"chaos_marauder_with_shield",
				{
					10,
					12
				},
				"chaos_berzerker",
				{
					7,
					8
				},
				"chaos_warrior",
				1
			}
		},
		{
			name = "zerker",
			weight = 5,
			breeds = {
				"chaos_fanatic",
				{
					10,
					12
				},
				"chaos_marauder",
				{
					7,
					9
				},
				"chaos_marauder_with_shield",
				{
					5,
					6
				},
				"skaven_dummy_clan_rat",
				{
					9,
					11
				},
				"chaos_berzerker",
				{
					3,
					4
				},
				"chaos_raider",
				{
					5,
					6
				}
			}
		},
		{
			name = "shielders",
			weight = 2,
			breeds = {
				"chaos_fanatic",
				{
					10,
					12
				},
				"chaos_marauder",
				{
					7,
					9
				},
				"chaos_marauder_with_shield",
				{
					6,
					8
				},
				"skaven_dummy_clan_rat",
				{
					10,
					12
				},
				"chaos_raider",
				{
					8,
					10
				}
			}
		},
		{
			name = "leader",
			weight = 4,
			breeds = {
				"chaos_fanatic",
				{
					12,
					14
				},
				"chaos_marauder",
				{
					18,
					20
				},
				"chaos_raider",
				{
					7,
					8
				},
				"chaos_marauder_with_shield",
				{
					6,
					7
				},
				"chaos_warrior",
				1
			}
		},
		{
			name = "frenzy",
			weight = 2,
			breeds = {
				"chaos_fanatic",
				{
					25,
					27
				},
				"chaos_marauder",
				{
					16,
					18
				},
				"chaos_raider",
				{
					3,
					4
				},
				"chaos_berzerker",
				{
					5,
					6
				},
				"chaos_marauder_with_shield",
				{
					6,
					7
				},
			}
		},
		sound_settings = HordeCompositionsSoundSettings.chaos
	}
	HordeCompositionsPacing.chaos_huge_armor = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_fanatic",
				{
					20,
					22
				},
				"chaos_marauder",
				{
					20,
					22
				},
				"chaos_raider",
				{
					5,
					6
				},
				"chaos_marauder_tutorial",
				{
					3,
					4
				},
			}
		},
		{
			name = "zerker",
			weight = 5,
			breeds = {
				"chaos_fanatic",
				{
					20,
					22
				},
				"chaos_marauder",
				{
					14,
					16
				},
				"chaos_berzerker",
				{
					3,
					4
				},
				"chaos_marauder_tutorial",
				{
					2,
					3
				},
				"chaos_warrior",
				1
			}
		},
		{
			name = "shielders",
			weight = 2,
			breeds = {
				"chaos_fanatic",
				{
					20,
					22
				},
				"chaos_marauder",
				{
					14,
					16
				},
				"chaos_marauder_with_shield",
				{
					9,
					10
				},
				"chaos_raider",
				{
					3,
					4
				},
				"chaos_berzerker",
				{
					2,
					3
				},
				"chaos_marauder_tutorial",
				{
					2,
					3
				},
			}
		},
		{
			name = "leader",
			weight = 4,
			breeds = {
				"chaos_fanatic",
				{
					20,
					22
				},
				"chaos_marauder",
				{
					14,
					16
				},
				"chaos_raider",
				{
					3,
					4
				},
				"chaos_marauder_tutorial",
				{
					2,
					3
				},
				"chaos_warrior",
				1
			}
		},
		{
			name = "frenzy",
			weight = 2,
			breeds = {
				"chaos_fanatic",
				{
					12,
					14
				},
				"chaos_marauder",
				{
					18,
					20
				},
				"chaos_raider",
				{
					2,
					3
				},
				"chaos_berzerker",
				{
					2,
					3
				},
				"chaos_marauder_tutorial",
				{
					2,
					3
				},
				"chaos_warrior",
				1
			}
		},
		sound_settings = HordeCompositionsSoundSettings.chaos
	}
	HordeCompositionsPacing.chaos_huge_berzerker = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_fanatic",
				{
					13,
					15
				},
				"chaos_marauder",
				{
					17,
					19
				},
				"skaven_dummy_clan_rat",
				{
					9,
					11
				},
				"chaos_berzerker",
				{
					9,
					11
				}
			}
		},
		{
			name = "zerker",
			weight = 5,
			breeds = {
				"chaos_fanatic",
				{
					8,
					10
				},
				"chaos_marauder",
				{
					16,
					18
				},
				"skaven_dummy_clan_rat",
				{
					6,
					8
				},
				"chaos_berzerker",
				{
					5,
					6
				},
				"chaos_warrior",
				1
			}
		},
		{
			name = "shielders",
			weight = 2,
			breeds = {
				"chaos_fanatic",
				{
					16,
					18
				},
				"chaos_marauder",
				{
					12,
					14
				},
				"chaos_marauder_with_shield",
				{
					6,
					8
				},
				"skaven_dummy_clan_rat",
				{
					6,
					8
				},
				"chaos_berzerker",
				{
					6,
					7
				},
				"chaos_raider_tutorial",
				1
			}
		},
		{
			name = "leader",
			weight = 4,
			breeds = {
				"chaos_fanatic",
				{
					29,
					31
				},
				"chaos_marauder",
				{
					18,
					20
				},
				"chaos_marauder_tutorial",
				{
					4,
					5
				},
				"chaos_berzerker",
				{
					5,
					6
				}
			}
		},
		{
			name = "frenzy",
			weight = 2,
			breeds = {
				"chaos_fanatic",
				{
					14,
					16
				},
				"chaos_marauder",
				{
					16,
					18
				},
				"chaos_raider",
				{
					4,
					5
				},
				"chaos_berzerker",
				{
					4,
					5
				},
				"chaos_marauder_with_shield",
				{
					3,
					4
				},
				"chaos_warrior",
				1
			}
		},
		sound_settings = HordeCompositionsSoundSettings.chaos
	}
	HordeCompositionsPacing.beastmen_medium = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					12,
					14
				},
				"beastmen_ungor",
				{
					5,
					7
				}
			}
		},
		{
			name = "plain",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					7,
					9
				},
				"beastmen_ungor",
				{
					8,
					10
				}
			}
		},
		{
			name = "leader_gor",
			weight = 3,
			breeds = {
				"beastmen_gor",
				{
					12,
					14
				},
				"beastmen_ungor",
				{
					5,
					7
				},
				"beastmen_bestigor",
				{
					1,
					2
				}
			}
		},
		{
			name = "leader_ungor",
			weight = 3,
			breeds = {
				"beastmen_gor",
				{
					7,
					9
				},
				"beastmen_ungor",
				{
					8,
					10
				},
				"beastmen_bestigor",
				{
					1,
					2
				}
			}
		},
		sound_settings = HordeCompositionsSoundSettings.beastmen
	}
	HordeCompositionsPacing.beastmen_large = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					16,
					18
				},
				"beastmen_ungor",
				{
					5,
					7
				}
			}
		},
		{
			name = "plain",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					12,
					14
				},
				"beastmen_ungor",
				{
					8,
					10
				}
			}
		},
		{
			name = "leader_gor",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					16,
					18
				},
				"beastmen_ungor",
				{
					5,
					7
				},
				"beastmen_bestigor",
				{
					1,
					2
				}
			}
		},
		{
			name = "leader_ungor",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					12,
					14
				},
				"beastmen_ungor",
				{
					8,
					10
				},
				"beastmen_bestigor",
				{
					1,
					2
				}
			}
		},
		sound_settings = HordeCompositionsSoundSettings.beastmen
	}
	HordeCompositionsPacing.beastmen_huge = {
		{
			name = "plain",
			weight = 3,
			breeds = {
				"beastmen_gor",
				{
					15,
					16
				},
				"beastmen_gor_dummy",
				{
					5,
					6
				},
				"beastmen_ungor",
				{
					15,
					16
				},
				"beastmen_bestigor",
				{
					4,
					5
				},
				"beastmen_bestigor_dummy",
				1
			}
		},
		{
			name = "leader",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					15,
					16
				},
				"beastmen_gor_dummy",
				{
					5,
					6
				},
				"beastmen_ungor",
				{
					15,
					16
				},
				"beastmen_bestigor",
				{
					2,
					3
				},
                "beastmen_bestigor_dummy",
				{
					1,
					2
				}
			}
		},
		{
			name = "leader_gor",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					15,
					16
				},
				"beastmen_gor_dummy",
				{
					5,
					6
				},
				"beastmen_ungor",
				{
					15,
					16
				},
				"beastmen_bestigor",
				{
					3,
					4
				},
				"chaos_berzerker",
				{
					3,
					4
				},
			}
		},
		{
			name = "leader_ungor",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					15,
					16
				},
				"beastmen_gor_dummy",
				{
					5,
					6
				},
				"beastmen_ungor",
				{
					15,
					16
				},
				"beastmen_bestigor",
				{
					2,
					3
				},
				"chaos_raider",
				{
					3,
					4
				},
			}
			
		},
		sound_settings = HordeCompositionsSoundSettings.beastmen
	}
	HordeCompositionsPacing.beastmen_huge_armor = {
		{
			name = "plain",
			weight = 3,
			breeds = {
				"beastmen_gor",
				{
					15,
					16
				},
				"beastmen_ungor",
				{
					15,
					16
				},
				"chaos_marauder_with_shield",
				{
					5,
					6
				},
				"beastmen_bestigor",
				{
					5,
					6
				}
			}
		},
		{
			name = "leader",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					15,
					16
				},
				"beastmen_gor_dummy",
				{
					5,
					6
				},
				"beastmen_ungor",
				{
					15,
					16
				},
				"beastmen_bestigor",
				{
					2,
					3
				},
				"chaos_berzerker",
				{
					3,
					4
				},
			}
		},
		{
			name = "leader_gor",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					15,
					16
				},
				"beastmen_gor_dummy",
				{
					5,
					6
				},
				"beastmen_ungor",
				{
					15,
					16
				},
				"beastmen_bestigor",
				{
					5,
					6
				}
			}
		},
		{
			name = "leader",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					15,
					16
				},
				"beastmen_gor_dummy",
				{
					5,
					6
				},
				"beastmen_ungor",
				{
					15,
					16
				},
				"beastmen_bestigor_dummy",
				{
					3,
					4
				},
			},
		},
		sound_settings = HordeCompositionsSoundSettings.beastmen
	}

	SpecialsSettings.default.max_specials = 8
	SpecialsSettings.default_light.max_specials = 8
	SpecialsSettings.skaven.max_specials = 8
	SpecialsSettings.skaven_light.max_specials = 8
	SpecialsSettings.chaos.max_specials = 8
	SpecialsSettings.chaos_light.max_specials = 8
	SpecialsSettings.beastmen.max_specials = 8
	SpecialsSettings.skaven_beastmen.max_specials = 8
	SpecialsSettings.chaos_beastmen.max_specials = 8
	PacingSettings.default.delay_specials_threat_value = nil
	PacingSettings.chaos.delay_specials_threat_value = nil
	PacingSettings.beastmen.delay_specials_threat_value = nil
	SpecialsSettings.default.methods.specials_by_slots = {
		max_of_same = 4,
		coordinated_attack_cooldown_multiplier = 0.5,
		chance_of_coordinated_attack = 0.5,
		select_next_breed = "get_random_breed",
		after_safe_zone_delay = {
			5,
			20
		},
		spawn_cooldown = {
			25,
			50
		}
	}
	SpecialsSettings.default_light.methods.specials_by_slots = {
		max_of_same = 2,
		coordinated_attack_cooldown_multiplier = 0.5,
		chance_of_coordinated_attack = 0.5,
		select_next_breed = "get_random_breed",
		after_safe_zone_delay = {
			5,
			20
		},
		spawn_cooldown = {
			25,
			50
		}
	}
	SpecialsSettings.skaven.methods.specials_by_slots = {
		max_of_same = 2,
		coordinated_attack_cooldown_multiplier = 0.5,
		chance_of_coordinated_attack = 0.5,
		select_next_breed = "get_random_breed",
		after_safe_zone_delay = {
			5,
			20
		},
		spawn_cooldown = {
			25,
			50
		}
	}
	SpecialsSettings.skaven_light.methods.specials_by_slots = {
		max_of_same = 2,
		coordinated_attack_cooldown_multiplier = 0.5,
		chance_of_coordinated_attack = 0.5,
		select_next_breed = "get_random_breed",
		after_safe_zone_delay = {
			5,
			20
		},
		spawn_cooldown = {
			25,
			50
		}
	}
	SpecialsSettings.chaos.methods.specials_by_slots = {
		max_of_same = 2,
		coordinated_attack_cooldown_multiplier = 0.5,
		chance_of_coordinated_attack = 0.5,
		select_next_breed = "get_random_breed",
		after_safe_zone_delay = {
			5,
			20
		},
		spawn_cooldown = {
			25,
			50
		}
	}
	SpecialsSettings.chaos_light.methods.specials_by_slots = {
		max_of_same = 2,
		coordinated_attack_cooldown_multiplier = 0.5,
		chance_of_coordinated_attack = 0.5,
		select_next_breed = "get_random_breed",
		after_safe_zone_delay = {
			5,
			20
		},
		spawn_cooldown = {
			25,
			50
		}
	}
	SpecialsSettings.beastmen.methods.specials_by_slots = {
		max_of_same = 2,
		coordinated_attack_cooldown_multiplier = 0.5,
		chance_of_coordinated_attack = 0.5,
		select_next_breed = "get_random_breed",
		after_safe_zone_delay = {
			5,
			20
		},
		spawn_cooldown = {
			25,
			50
		}
	}
	SpecialsSettings.skaven_beastmen.methods.specials_by_slots = {
		max_of_same = 2,
		coordinated_attack_cooldown_multiplier = 0.5,
		chance_of_coordinated_attack = 0.5,
		select_next_breed = "get_random_breed",
		after_safe_zone_delay = {
			5,
			20
		},
		spawn_cooldown = {
			25,
			50
		}
	}
	SpecialsSettings.chaos_beastmen.methods.specials_by_slots = {
		max_of_same = 2,
		coordinated_attack_cooldown_multiplier = 0.5,
		chance_of_coordinated_attack = 0.5,
		select_next_breed = "get_random_breed",
		after_safe_zone_delay = {
			5,
			20
		},
		spawn_cooldown = {
			25,
			50
		}
	}
	SpecialsSettings.beastmen.breeds = {
		"beastmen_standard_bearer",
		"chaos_vortex_sorcerer",
		"chaos_vortex_sorcerer",
		"chaos_corruptor_sorcerer",
		"chaos_corruptor_sorcerer",
		"skaven_gutter_runner",
		"skaven_gutter_runner",
		"skaven_pack_master",
		"skaven_pack_master",
		"skaven_ratling_gunner",
		"skaven_ratling_gunner"
	}
	SpecialsSettings.skaven_beastmen.breeds = {
		"skaven_gutter_runner",
		"skaven_gutter_runner",
		"skaven_pack_master",
		"skaven_pack_master",
		"skaven_ratling_gunner",
		"skaven_ratling_gunner",
		"skaven_poison_wind_globadier",
		"skaven_poison_wind_globadier",
		"skaven_warpfire_thrower",
		"skaven_warpfire_thrower",
		"beastmen_standard_bearer"
	}
	SpecialsSettings.chaos_beastmen.breeds = {
		"skaven_gutter_runner",
		"skaven_gutter_runner",
		"skaven_pack_master",
		"skaven_pack_master",
		"skaven_poison_wind_globadier",
		"skaven_poison_wind_globadier",
		"chaos_vortex_sorcerer",
		"chaos_vortex_sorcerer",
		"chaos_corruptor_sorcerer",
		"chaos_corruptor_sorcerer",
		"skaven_warpfire_thrower",
		"skaven_warpfire_thrower",
		"beastmen_standard_bearer"
	}

	SpecialsSettings.default.difficulty_overrides.hard = nil
	SpecialsSettings.default.difficulty_overrides.harder = nil
	SpecialsSettings.default.difficulty_overrides.hardest = nil
	SpecialsSettings.default.difficulty_overrides.cataclysm = nil
	SpecialsSettings.default.difficulty_overrides.cataclysm_2 = nil
	SpecialsSettings.default.difficulty_overrides.cataclysm_3 = nil
	SpecialsSettings.default_light.difficulty_overrides.hard = nil
	SpecialsSettings.default_light.difficulty_overrides.harder = nil
	SpecialsSettings.default_light.difficulty_overrides.hardest = nil
	SpecialsSettings.default_light.difficulty_overrides.cataclysm = nil
	SpecialsSettings.default_light.difficulty_overrides.cataclysm_2 = nil
	SpecialsSettings.default_light.difficulty_overrides.cataclysm_3 = nil
	SpecialsSettings.skaven.difficulty_overrides.hard = nil
	SpecialsSettings.skaven.difficulty_overrides.harder = nil
	SpecialsSettings.skaven.difficulty_overrides.hardest = nil
	SpecialsSettings.skaven.difficulty_overrides.cataclysm = nil
	SpecialsSettings.skaven.difficulty_overrides.cataclysm_2 = nil
	SpecialsSettings.skaven.difficulty_overrides.cataclysm_3 = nil
	SpecialsSettings.skaven_light.difficulty_overrides.hard = nil
	SpecialsSettings.skaven_light.difficulty_overrides.harder = nil
	SpecialsSettings.skaven_light.difficulty_overrides.hardest = nil
	SpecialsSettings.skaven_light.difficulty_overrides.cataclysm = nil
	SpecialsSettings.skaven_light.difficulty_overrides.cataclysm_2 = nil
	SpecialsSettings.skaven_light.difficulty_overrides.cataclysm_3 = nil
	SpecialsSettings.chaos.difficulty_overrides.hard = nil
	SpecialsSettings.chaos.difficulty_overrides.harder = nil
	SpecialsSettings.chaos.difficulty_overrides.hardest = nil
	SpecialsSettings.chaos.difficulty_overrides.cataclysm = nil
	SpecialsSettings.chaos.difficulty_overrides.cataclysm_2 = nil
	SpecialsSettings.chaos.difficulty_overrides.cataclysm_3 = nil
	SpecialsSettings.chaos_light.difficulty_overrides.hard = nil
	SpecialsSettings.chaos_light.difficulty_overrides.harder = nil
	SpecialsSettings.chaos_light.difficulty_overrides.hardest = nil
	SpecialsSettings.chaos_light.difficulty_overrides.cataclysm = nil
	SpecialsSettings.chaos_light.difficulty_overrides.cataclysm_2 = nil
	SpecialsSettings.chaos_light.difficulty_overrides.cataclysm_3 = nil
	SpecialsSettings.beastmen.difficulty_overrides.hard = nil
	SpecialsSettings.beastmen.difficulty_overrides.harder = nil
	SpecialsSettings.beastmen.difficulty_overrides.hardest = nil
	SpecialsSettings.beastmen.difficulty_overrides.cataclysm = nil
	SpecialsSettings.beastmen.difficulty_overrides.cataclysm_2 = nil
	SpecialsSettings.beastmen.difficulty_overrides.cataclysm_3 = nil
	SpecialsSettings.skaven_beastmen.difficulty_overrides.hard = nil
	SpecialsSettings.skaven_beastmen.difficulty_overrides.harder = nil
	SpecialsSettings.skaven_beastmen.difficulty_overrides.hardest = nil
	SpecialsSettings.skaven_beastmen.difficulty_overrides.cataclysm = nil
	SpecialsSettings.skaven_beastmen.difficulty_overrides.cataclysm_2 = nil
	SpecialsSettings.skaven_beastmen.difficulty_overrides.cataclysm_3 = nil
	SpecialsSettings.chaos_beastmen.difficulty_overrides.hard = nil
	SpecialsSettings.chaos_beastmen.difficulty_overrides.harder = nil
	SpecialsSettings.chaos_beastmen.difficulty_overrides.hardest = nil
	SpecialsSettings.chaos_beastmen.difficulty_overrides.cataclysm = nil
	SpecialsSettings.chaos_beastmen.difficulty_overrides.cataclysm_2 = nil
	SpecialsSettings.chaos_beastmen.difficulty_overrides.cataclysm_3 = nil
	
	Breeds.skaven_rat_ogre.threat_value = 25
	Breeds.skaven_stormfiend.threat_value = 25
	Breeds.chaos_spawn.threat_value = 25
	Breeds.chaos_troll.threat_value = 25
	Breeds.beastmen_minotaur.threat_value = 25
	
	Managers.state.conflict:set_threat_value("skaven_rat_ogre", 25)
	Managers.state.conflict:set_threat_value("skaven_stormfiend", 25)
	Managers.state.conflict:set_threat_value("chaos_spawn", 25)
	Managers.state.conflict:set_threat_value("chaos_troll", 25)
	Managers.state.conflict:set_threat_value("beastmen_minotaur", 25)

	BossSettings.default.boss_events.events = {
		"event_boss",
		"event_patrol"
	}

	BossSettings.default_light.boss_events.events = {
		"event_boss",
		"event_patrol"
	}

	BossSettings.skaven.boss_events.events = {
		"event_boss",
		"event_patrol"
	}

	BossSettings.skaven_light.boss_events.events = {
		"event_boss",
		"event_patrol"
	}

	BossSettings.chaos.boss_events.events = {
		"event_boss",
		"event_patrol"
	}

	BossSettings.chaos_light.boss_events.events = {
		"event_boss",
		"event_patrol"
	}
	
	BossSettings.beastmen.boss_events.events = {
		"event_boss",
		"event_patrol"
	}
	
	BossSettings.skaven_beastmen.boss_events.events = {
		"event_boss",
		"event_patrol"
	}
	
	BossSettings.chaos_beastmen.boss_events.events = {
		"event_boss",
		"event_patrol"
	}
	
	BossSettings.beastmen_light.boss_events.events = {
		"event_boss",
		"event_patrol"
	}

	---------------------
	--Patrol Spice

	GenericTerrorEvents.boss_event_beastmen_spline_patrol = {
		{
			"spawn_patrol",
			patrol_template = "spline_patrol",
			formations = {
				"beastmen_standard"
			}
		}
	}

	GenericTerrorEvents.boss_event_skaven_beastmen_spline_patrol = {
		{
			"spawn_patrol",
			patrol_template = "spline_patrol",
			formations = {
				"beastmen_standard",
				"storm_vermin_shields_infront",
				"storm_vermin_shields_infront"
			}
		}
	}

	GenericTerrorEvents.boss_event_chaos_beastmen_spline_patrol = {
		{
			"spawn_patrol",
			patrol_template = "spline_patrol",
			formations = {
				"beastmen_standard"
			}
		}
	}

	GenericTerrorEvents.boss_event_spline_patrol = {
		{
			"spawn_patrol",
			patrol_template = "spline_patrol",
			formations = {
				"storm_vermin_two_column",
				"storm_vermin_shields_infront",
				"chaos_warrior_default"
			}
		}
	}
	GenericTerrorEvents.boss_event_skaven_spline_patrol = {
		{
			"spawn_patrol",
			patrol_template = "spline_patrol",
			formations = {
				"storm_vermin_shields_infront",
				"storm_vermin_two_column"
			}
		}
	}
	GenericTerrorEvents.boss_event_chaos_spline_patrol = {
		{
			"spawn_patrol",
			patrol_template = "spline_patrol",
			formations = {
				"chaos_warrior_default"
			}
		}
	}


	PatrolFormationSettings.chaos_warrior_default = {
		settings = PatrolFormationSettings.default_marauder_settings,

		normal = {
			{
				"chaos_marauder_with_shield",
				"chaos_marauder_with_shield"
			},
			{
				"chaos_raider"
			},
			{
				"chaos_raider"
			},
			{
				"chaos_marauder",
				"chaos_marauder"
			},
			{
				"chaos_marauder",
				"chaos_marauder"
			},
			{
				"chaos_warrior"
			},
			{
				"chaos_marauder",
				"chaos_marauder"
			}
		},
		hard = {
			{
				"chaos_marauder_with_shield",
				"chaos_marauder_with_shield"
			},
			{
				"chaos_warrior"
			},
			{
				"chaos_marauder",
				"chaos_marauder"
			},
			{
				"chaos_raider",
				"chaos_raider"
			},
			{
				"chaos_marauder",
				"chaos_marauder"
			},
			{
				"chaos_warrior"
			},
			{
				"chaos_marauder_with_shield",
				"chaos_marauder_with_shield"
			}
		},
		harder = {
			{
				"chaos_marauder_with_shield",
				"chaos_marauder_with_shield"
			},
			{
				"chaos_raider",
				"chaos_raider"
			},
			{
				"chaos_marauder_with_shield",
				"chaos_marauder_with_shield"
			},
			{
				"chaos_warrior",
				"chaos_warrior"
			},
			{
				"chaos_marauder_with_shield",
				"chaos_marauder_with_shield"
			},
			{
				"chaos_warrior",
				"chaos_warrior"
			},
			{
				"chaos_marauder_with_shield",
				"chaos_marauder_with_shield"
			}
		},
		hardest = {
			{
				"chaos_raider"
			},
			{
				"chaos_marauder_with_shield",
				"chaos_marauder_with_shield"
			},
			{
				"chaos_warrior",
				"chaos_warrior"
			},
			{
				"chaos_marauder_with_shield",
				"chaos_marauder_with_shield"
			},
			{
				"chaos_raider",
				"chaos_raider"
			},
			{
				"chaos_warrior",
				"chaos_warrior"
			},
			{
				"chaos_marauder_tutorial",
				"chaos_marauder_tutorial"
			},
			{
				"chaos_raider_tutorial",
				"chaos_raider_tutorial"
			},
			{
				"chaos_marauder_tutorial",
				"chaos_marauder_tutorial"
			}
		},
		cataclysm = {
			{
				"chaos_raider"
			},
			{
				"chaos_warrior",
				"chaos_warrior"
			},
			{
				"chaos_berzerker",
				"chaos_berzerker"
			},
			{
				"chaos_warrior",
				"chaos_warrior"
			},
			{
				"chaos_berzerker",
				"chaos_berzerker"
			},
			{
				"chaos_warrior",
				"chaos_warrior"
			},
			{
				"chaos_raider",
				"chaos_raider"
			},
			{
				"chaos_warrior",
				"chaos_warrior"
			},
			{
				"chaos_warrior",
				"chaos_warrior"
			},
			{
				"chaos_berzerker",
				"chaos_berzerker"
			},
			{
				"chaos_raider",
				"chaos_raider"
			},
			{
				"chaos_warrior",
				"chaos_warrior"
			},
			{
				"chaos_berzerker",
				"chaos_berzerker"
			},
			{
				"chaos_warrior",
				"chaos_warrior"
			}
		}
	}


	PatrolFormationSettings.storm_vermin_two_column = {
		settings = {
			extra_breed_name = "skaven_storm_vermin_with_shield",
			use_controlled_advance = true,
			sounds = {
				PLAYER_SPOTTED = "storm_vermin_patrol_player_spotted",
				FORMING = "Play_stormvermin_patrol_forming",
				FOLEY = "Play_stormvermin_patrol_foley",
				FORMATED = "Play_stormvemin_patrol_formated",
				FOLEY_EXTRA = "Play_stormvermin_patrol_shield_foley",
				FORMATE = "storm_vermin_patrol_formate",
				CHARGE = "storm_vermin_patrol_charge",
				VOICE = "Play_stormvermin_patrol_voice"
			},
			offsets = PatrolFormationSettings.default_settings.offsets,
			speeds = PatrolFormationSettings.default_settings.speeds
		},
		normal = {
			{
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_clan_rat",
				"skaven_clan_rat"
			},
			{
				"skaven_clan_rat",
				"skaven_clan_rat"
			},
			{
				"skaven_clan_rat",
				"skaven_clan_rat"
			}
		},
		hard = {
			{
				"skaven_storm_vermin_with_shield",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			}
		},
		harder = {
			{
				"skaven_storm_vermin_with_shield",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin_with_shield",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			}
		},
		hardest = {
			{
				"skaven_storm_vermin_with_shield",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin_with_shield",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			}
		},
		cataclysm = {
			{
				"skaven_storm_vermin_with_shield",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin_with_shield",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin_with_shield",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			}
		}
	}


	PatrolFormationSettings.storm_vermin_shields_infront = {
		settings = {
			extra_breed_name = "skaven_storm_vermin_with_shield",
			use_controlled_advance = true,
			sounds = {
				PLAYER_SPOTTED = "storm_vermin_patrol_player_spotted",
				FORMING = "Play_stormvermin_patrol_forming",
				FOLEY = "Play_stormvermin_patrol_foley",
				FORMATED = "Play_stormvemin_patrol_formated",
				FOLEY_EXTRA = "Play_stormvermin_patrol_shield_foley",
				FORMATE = "storm_vermin_patrol_formate",
				CHARGE = "storm_vermin_patrol_charge",
				VOICE = "Play_stormvermin_patrol_voice"
			},
			offsets = PatrolFormationSettings.default_settings.offsets,
			speeds = PatrolFormationSettings.default_settings.speeds
		},
		normal = {
			{
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_clan_rat",
				"skaven_clan_rat",
				"skaven_clan_rat",
				"skaven_clan_rat"
			}
		},
		hard = {
			{
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin_with_shield",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			}
		},
		harder = {
			{
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin_with_shield",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin_with_shield",
				"skaven_storm_vermin",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				EMPTY,
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				EMPTY
			}
		},
		hardest = {
			{
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin_with_shield",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin_with_shield",
				"skaven_storm_vermin",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			{
				"skaven_storm_vermin",
				EMPTY,
				EMPTY,
				"skaven_storm_vermin"
			}
		},
		cataclysm = {
			{
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_dummy_slave",
				"skaven_dummy_slave"
			},
			{
				"skaven_storm_vermin_with_shield",
				"skaven_dummy_slave",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin_with_shield",
				"skaven_dummy_slave",
				"skaven_dummy_slave",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_dummy_slave",
				"skaven_dummy_slave",
				"skaven_dummy_slave",
				"skaven_dummy_slave"
			},
			{
				"skaven_storm_vermin_with_shield",
				"skaven_dummy_slave",
				"skaven_dummy_slave",
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin_with_shield",
				EMPTY,
				EMPTY,
				"skaven_storm_vermin_with_shield"
			},
			{
				"skaven_storm_vermin_with_shield",
				EMPTY,
				EMPTY,
				"skaven_storm_vermin_with_shield"
			}
		}
	}



	PatrolFormationSettings.beastmen_standard = {
			settings = {
				sounds = {
					PLAYER_SPOTTED = "beastmen_patrol_player_spotted",
					FORMING = "beastmen_patrol_forming",
					FOLEY = "beastmen_patrol_foley",
					FORMATED = "beastmen_patrol_formated",
					FORMATE = "beastmen_patrol_formate",
					CHARGE = "beastmen_patrol_charge",
					VOICE = "beastmen_patrol_voice"
				},
				offsets = {
					ANCHOR_OFFSET = {
						x = 1.4,
						y = 0.6
					}
				},
				speeds = {
					FAST_WALK_SPEED = 2.6,
					MEDIUM_WALK_SPEED = 2.35,
					WALK_SPEED = 2.12,
					SPLINE_SPEED = 2.22,
					SLOW_SPLINE_SPEED = 0.1
				},
			},
			normal = {
				{
					"beastmen_standard_bearer"
				},
				{
					"beastmen_bestigor"
				},
				{
					"beastmen_bestigor"
				},
				{
					"beastman_ungor",
					"beastman_ungor"
				},
				{
					"beastmen_gor_dummy",
					"beastmen_gor_dummy"
				},
				{
					"beastmen_bestigor_dummy",
					"beastmen_bestigor_dummy"
				},
				{
					"beastmen_gor_dummy",
					"beastmen_gor_dummy"
				}
			},
			hard = {
				{
					"beastmen_standard_bearer"
				},
				{
					"beastmen_bestigor"
				},
				{
					"beastman_ungor",
					"beastman_ungor"
				},
				{
					"beastmen_bestigor",
					"beastmen_bestigor"
				},
				{
					"beastman_ungor",
					"beastman_ungor"
				},
				{
					"beastmen_bestigor"
				},
				{
					"beastmen_gor",
					"beastmen_gor"
				}
			},
			harder = {
				{
					"beastmen_standard_bearer"
				},
				{
					"beastmen_bestigor",
					"beastmen_bestigor"
				},
				{
					"beastmen_gor",
					"beastmen_gor"
				},
				{
					"beastmen_bestigor",
					"beastmen_bestigor"
				},
				{
					"beastmen_gor",
					"beastmen_gor"
				},
				{
					"beastmen_bestigor",
					"beastmen_bestigor"
				},
				{
					"beastmen_gor",
					"beastmen_gor"
				}
			},
			hardest = {
				{
					"beastmen_standard_bearer"
				},
				{
					"beastmen_gor",
					"beastmen_gor"
				},
				{
					"beastmen_bestigor",
					"beastmen_bestigor"
				},
				{
					"beastmen_gor",
					"beastmen_gor"
				},
				{
					"beastmen_bestigor",
					"beastmen_bestigor"
				},
				{
					"beastmen_bestigor",
					"beastmen_bestigor"
				},
				{
					"beastmen_gor",
					"beastmen_gor"
				},
				{
					"beastmen_gor",
					"beastmen_gor"
				},
				{
					"beastmen_gor",
					"beastmen_gor"
				}
			},
			cataclysm = {
				{
					"beastmen_standard_bearer"
				},
				{
					"beastmen_bestigor",
					"beastmen_bestigor"
				},
				{
					"beastmen_bestigor_dummy",
					"beastmen_bestigor_dummy"
				},
				{
					"beastmen_bestigor",
					"beastmen_bestigor"
				},
				{
					"beastmen_bestigor",
					"beastmen_bestigor"
				},
				{
					"beastmen_bestigor",
					"beastmen_bestigor"
				},
				{
					"beastmen_standard_bearer",
					"beastmen_standard_bearer"
				},
				{
					"beastmen_bestigor",
					"beastmen_bestigor"
				},
				{
					"beastmen_bestigor_dummy",
					"beastmen_bestigor_dummy"
				},
				{
					"beastmen_bestigor",
					"beastmen_bestigor"
				},
				{
					"beastmen_bestigor",
					"beastmen_bestigor"
				}
			}
		}
	



	---------------------
	--Generic event spawnsets

	HordeCompositions.event_smaller = {
		{
			name = "plain",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					5,
					7
				},
				"skaven_clan_rat",
				{
					7,
					9
				}
			}
		},
		{
			name = "mixed",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					4,
					6
				},
				"skaven_clan_rat",
				{
					6,
					7
				},
				"skaven_clan_rat_with_shield",
				{
					1,
					2
				}
			}
		},
		{
			name = "leader",
			weight = 3,
			breeds = {
				"skaven_slave",
				{
					7,
					9
				},
				"skaven_storm_vermin_commander",
				{
					1,
					2
				}
			}
		}
	}

	HordeCompositions.event_small = {
		{
			name = "plain",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					8,
					10
				},
				"skaven_clan_rat",
				{
					13,
					15
				}
			}
		},
		{
			name = "mixed",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					9,
					10
				},
				"skaven_clan_rat",
				{
					8,
					9
				},
				"skaven_clan_rat_with_shield",
				{
					3,
					4
				}
			}
		},
		{
			name = "leader",
			weight = 3,
			breeds = {
				"skaven_slave",
				{
					13,
					15
				},
				"skaven_clan_rat_with_shield",
				{
					1,
					2
				},
				"skaven_storm_vermin_commander",
				{
					1,
					1
				}
			}
		}
	}

	HordeCompositions.event_medium = {
		{
			name = "plain",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					12,
					13
				},
				"skaven_clan_rat",
				{
					28,
					31
				}
			}
		},
		{
			name = "mixed",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					16,
					18
				},
				"skaven_clan_rat",
				{
					15,
					16
				},
				"skaven_clan_rat_with_shield",
				{
					5,
					6
				}
			}
		},
		{
			name = "leader",
			weight = 3,
			breeds = {
				"skaven_slave",
				{
					14,
					17
				},
				"skaven_clan_rat",
				{
					14,
					18
				},
				"skaven_clan_rat_with_shield",
				{
					5,
					6
				},
				"skaven_storm_vermin_commander",
				{
					2,
					3
				}
			}
		}
	}

	HordeCompositions.event_large = {
		{
			name = "plain",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					22,
					26
				},
				"skaven_clan_rat",
				{
					34,
					38
				}
			}
		},
		{
			name = "mixed",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					14,
					17
				},
				"skaven_clan_rat",
				{
					30,
					35
				},
				"skaven_clan_rat_with_shield",
				{
					8,
					13
				}
			}
		},
		{
			name = "leader",
			weight = 3,
			breeds = {
				"skaven_slave",
				{
					12,
					14
				},
				"skaven_clan_rat",
				{
					20,
					22
				},
				"skaven_clan_rat_with_shield",
				{
					7,
					11
				},
				"skaven_storm_vermin_commander",
				{
					3,
					4
				}
			}
		},
		{
			name = "shielders",
			weight = 3,
			breeds = {
				"skaven_slave",
				{
					14,
					16
				},
				"skaven_clan_rat",
				{
					20,
					21
				},
				"skaven_clan_rat_with_shield",
				{
					10,
					14
				},
				"skaven_storm_vermin_with_shield",
				{
					2,
					2
				}
			}
		}
	}

	HordeCompositions.event_small_chaos = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_marauder",
				{
					10,
					13
				}
			}
		},
		{
			name = "shielders",
			weight = 3,
			breeds = {
				"chaos_marauder_with_shield",
				{
					5,
					7
				},
				"chaos_marauder",
				{
					4,
					5
				}
			}
		}
	}

	HordeCompositions.event_medium_chaos = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_marauder",
				{
					14,
					16
				},
				"chaos_fanatic",
				{
					20,
					25
				}
			}
		},
		{
			name = "shielders",
			weight = 3,
			breeds = {
				"chaos_marauder_with_shield",
				{
					5,
					6
				},
				"chaos_marauder",
				{
					4,
					5
				},
				"chaos_fanatic",
				{
					20,
					25
				}
			}
		},
		{
			name = "leader",
			weight = 5,
			breeds = {
				"chaos_marauder",
				{
					4,
					5
				},
				"chaos_fanatic",
				{
					20,
					25
				},
				"chaos_raider",
				{
					2,
					2
				}
			}
		},
		{
			name = "zerker",
			weight = 3,
			breeds = {
				"chaos_marauder",
				{
					5,
					6
				},
				"chaos_fanatic",
				{
					20,
					25
				},
				"chaos_berzerker",
				{
					1,
					2
				}
			}
		}
	}

	HordeCompositions.event_large_chaos = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_marauder",
				{
					22,
					26
				},
				"chaos_fanatic",
				{
					22,
					26
				}
			}
		},
		{
			name = "shielders",
			weight = 3,
			breeds = {
				"chaos_marauder_with_shield",
				{
					9,
					13
				},
				"chaos_marauder",
				{
					8,
					11
				},
				"chaos_fanatic",
				{
					22,
					26
				}
			}
		},
		{
			name = "leader",
			weight = 5,
			breeds = {
				"chaos_marauder",
				{
					8,
					11
				},
				"chaos_fanatic",
				{
					22,
					26
				},
				"chaos_raider",
				{
					3,
					4
				}
			}
		},
		{
			name = "zerker",
			weight = 3,
			breeds = {
				"chaos_marauder",
				{
					8,
					11
				},
				"chaos_fanatic",
				{
					22,
					26
				},
				"chaos_berzerker",
				{
					3,
					4
				}
			}
		}
	}
	
	HordeCompositions.event_extra_spice_small = {
		{
			name = "few_clanrats",
			weight = 20,
			breeds = {
				"skaven_clan_rat",
				{
					4,
					5
				},
				"skaven_clan_rat_with_shield",
				{
					6,
					7
				},
				"skaven_storm_vermin_commander",
				1
			}
		},
		{
			name = "storm_clanrats",
			weight = 2,
			breeds = {
				"skaven_clan_rat",
				{
					6,
					7
				},
				"skaven_clan_rat_with_shield",
				{
					4,
					5
				},
				"skaven_storm_vermin_with_shield",
				1
			}
		}
	}
	
	HordeCompositions.event_extra_spice_medium = {
		{
			name = "few_clanrats",
			weight = 10,
			breeds = {
				"skaven_clan_rat",
				{
					8,
					13
				},
				"skaven_clan_rat_with_shield",
				{
					10,
					15
				},
				"skaven_storm_vermin_commander",
				{
					2,
					3
				}
			}
		},
		{
			name = "storm_clanrats",
			weight = 3,
			breeds = {
				"skaven_clan_rat",
				{
					10,
					15
				},
				"skaven_clan_rat_with_shield",
				{
					8,
					13
				},
				"skaven_storm_vermin_with_shield",
				{
					1,
					2
				}
			}
		}
	}
	
	HordeCompositions.event_extra_spice_large = {
		{
			name = "plain",
			weight = 10,
			breeds = {
				"skaven_clan_rat",
				{
					17,
					19
				},
				"skaven_clan_rat_with_shield",
				{
					20,
					24
				},
				"skaven_storm_vermin_commander",
				{
					3,
					4
				}
			}
		},
		{
			name = "lotsofvermin",
			weight = 3,
			breeds = {
				"skaven_clan_rat",
				{
					20,
					24
				},
				"skaven_clan_rat_with_shield",
				{
					17,
					19
				},
				"skaven_storm_vermin_with_shield",
				{
					2,
					3
				}
			}
		}
	}

	TerrorEventBlueprints.generic_disable_pacing = {
		{
			"text",
			text = "",
			duration = 0
		}
	}
	TerrorEventBlueprints.generic_enable_specials = {
		{
			"text",
			text = "",
			duration = 0
		}
	}

	---------------------
	--Unscaled Onslaught variants of generic compositions
	
	HordeCompositions.onslaught_chaos_shields = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_marauder_with_shield",
				{
					3,
					4
				}
			}
		}
	}
	
	HordeCompositions.onslaught_chaos_berzerkers_small = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_berzerker",
				{
					2,
					3
				}
			}
		}
	}
	
	HordeCompositions.onslaught_chaos_berzerkers_medium = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_berzerker",
				{
					3,
					4
				}
			}
		}
	}
	
	HordeCompositions.onslaught_chaos_warriors = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_warrior",
				{
					2,
					3
				}
			}
		}
	}
	
	HordeCompositions.onslaught_event_small_fanatics = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_fanatic",
				{
					5,
					6
				}
			}
		}
	}
	
	HordeCompositions.onslaught_plague_monks_small = {
		{
			name = "mines_plague_monks",
			weight = 1,
			breeds = {
				"skaven_plague_monk",
				{
					3,
					4
				}
			}
		}
	}
	
	HordeCompositions.onslaught_plague_monks_medium = {
		{
			name = "mines_plague_monks",
			weight = 1,
			breeds = {
				"skaven_plague_monk",
				{
					4,
					5
				}
			}
		}
	}
	
	HordeCompositions.onslaught_storm_vermin_small = {
		{
			name = "somevermin",
			weight = 3,
			breeds = {
				"skaven_storm_vermin_commander",
				{
					2,
					3
				}
			}
		}
	}
	
	HordeCompositions.onslaught_storm_vermin_medium = {
		{
			name = "somevermin",
			weight = 3,
			breeds = {
				"skaven_storm_vermin_commander",
				{
					3,
					4
				}
			}
		}
	}

	HordeCompositions.onslaught_storm_vermin_white_medium = {
		{
			name = "somevermin",
			weight = 3,
			breeds = {
				"skaven_storm_vermin",
				{
					3,
					4
				}
			}
		}
	}
	
	HordeCompositions.onslaught_storm_vermin_shields_small = {
		{
			name = "somevermin",
			weight = 3,
			breeds = {
				"skaven_storm_vermin_with_shield",
				{
					2,
					3
				}
			}
		}
	}

	HordeCompositions.onslaught_storm_vermin_shields_large = {
		{
			name = "somevermin",
			weight = 3,
			breeds = {
				"skaven_storm_vermin_with_shield",
				{
					2,
					3
				},
				"skaven_dummy_slave",
				{
					2,
					3
				}
			},
		}
	}
	
	HordeCompositions.onslaught_event_military_courtyard_plague_monks = {
		{
			name = "mixed",
			weight = 1,
			breeds = {
				"skaven_plague_monk",
				{
					3,
					3
				},
				"skaven_clan_rat",
				{
					4,
					6
				}
			}
		}
	}
	
	HordeCompositions.onslaught_military_end_event_plague_monks = {
		{
			name = "military_plague_monks",
			weight = 1,
			breeds = {
				"skaven_plague_monk",
				{
					3,
					4
				}
			}
		}
	}

	HordeCompositions.event_large_chaos_dutch = {
		{
			name = "armour",
			weight = 3,
			breeds = {
				"chaos_marauder_with_shield",
				{
					9,
					13
				},
				"chaos_marauder",
				{
					8,
					11
				},
				"chaos_fanatic",
				{
					10,
					12
				},
				"skaven_dummy_clan_rat",
				{
					18,
					20
				},
				"chaos_warrior",
				{
					2,
					2
				},
				"chaos_raider",
				{
					5,
					6
				},
			}
		},
		{
			name = "zerker",
			weight = 3,
			breeds = {
				"chaos_marauder_with_shield",
				{
					12,
					14
				},
				"chaos_marauder",
				{
					20,
					22
				},
				"chaos_fanatic",
				{
					14,
					16
				},
				"chaos_marauder_tutorial",
				{
					5,
					6
				},
				"chaos_berzerker",
				{
					5,
					6
				}
			}
		},
		{
			name = "raider",
			weight = 3,
			breeds = {
				"chaos_marauder_with_shield",
				{
					9,
					13
				},
				"chaos_marauder",
				{
					18,
					20
				},
				"chaos_fanatic",
				{
					10,
					12
				},
				"skaven_dummy_clan_rat",
				{
					10,
					12
				},
				"chaos_warrior",
				{
					2,
					2
				},
				"chaos_raider",
				{
					7,
					8
				}
			}
		}
	}

	HordeCompositions.event_large_skaven_dutch = {
		{
			name = "armour",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					10,
					12
				},
				"skaven_clan_rat",
				{
					20,
					22
				},
				"skaven_clan_rat_with_shield",
				{
					10,
					12
				},
				"skaven_storm_vermin_commander",
				{
					5,
					6
				},
				"skaven_storm_vermin",
				{
					5,
					6
				},
			}
		},
		{
			name = "mixed",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					10,
					12
				},
				"skaven_clan_rat",
				{
					20,
					22
				},
				"skaven_clan_rat_with_shield",
				{
					10,
					12
				},
				"skaven_storm_vermin_commander",
				{
					5,
					6
				},
				"skaven_plague_monk",
				{
					7,
					8
				},
			}
		},
		{
			name = "leader",
			weight = 3,
			breeds = {
				"skaven_slave",
				{
					10,
					12
				},
				"skaven_clan_rat",
				{
					20,
					22
				},
				"skaven_clan_rat_with_shield",
				{
					10,
					12
				},
				"skaven_storm_vermin_with_shield",
				{
					5,
					6
				},
				"skaven_storm_vermin",
				{
					7,
					8
				},
			}
		},
		{
			name = "shielders",
			weight = 3,
			breeds = {
				"skaven_slave",
				{
					10,
					12
				},
				"skaven_clan_rat",
				{
					20,
					22
				},
				"skaven_clan_rat_with_shield",
				{
					10,
					12
				},
				"skaven_storm_vermin_commander",
				{
					7,
					8
				},
				"skaven_dummy_slave",
				{
					5,
					6
				},
			}
		}
	}

	---------------------
	--Custom compositions

	HordeCompositions.event_extra_spice_unshielded = {
		{
			name = "few_clanrats",
			weight = 10,
			breeds = {
				"skaven_clan_rat",
				{
					18,
					22
				},
				"skaven_clan_rat_with_shield",
				{
					5,
					7
				}
			}
		},
		{
			name = "storm_clanrats",
			weight = 5,
			breeds = {
				"skaven_clan_rat",
				{
					18,
					22
				},
				"skaven_storm_vermin_commander",
				{
					2,
					3
				}
			}
		}
	}

	HordeCompositions.skaven_shields = {
		{
			name = "plain",
			weight = 5,
			breeds = {
				"skaven_clan_rat_with_shield",
				{
					7,
					9
				}
			}
		},
		{
			name = "somevermin",
			weight = 5,
			breeds = {
				"skaven_clan_rat_with_shield",
				{
					4,
					5
				},
				"skaven_storm_vermin_with_shield",
				{
					1,
					1
				}
			}
		}
	}
	
	HordeCompositions.event_stormvermin_shielders = {
		{
			name = "plain",
			weight = 10,
			breeds = {
				"skaven_storm_vermin_commander",
				2,
				"skaven_storm_vermin_with_shield",
				{
					2,
					3
				}
			}
		}
	}

	HordeCompositions.event_stormvermin_special = {
		{
			name = "plain",
			weight = 10,
			breeds = {
				"skaven_storm_vermin",
				3,
			}
		}
	}
	
	HordeCompositions.event_maulers_small = {
		{
			name = "plain",
			weight = 10,
			breeds = {
				"chaos_raider",
				{
					2,
					3
				}
			}
		}
	}
	
	HordeCompositions.event_maulers_medium = {
		{
			name = "plain",
			weight = 10,
			breeds = {
				"chaos_raider",
				{
					5,
					6
				}
			}
		}
	}

	HordeCompositions.event_marauder_special = {
		{
			name = "plain",
			weight = 10,
			breeds = {
				"chaos_marauder_tutorial",
				{
					5,
					6
				}
			}
		}
	}
	
	HordeCompositions.event_bestigors_medium = {
		{
			name = "plain",
			weight = 10,
			breeds = {
				"beastmen_bestigor",
				{
					5,
					6
				}
			}
		}
	}

	---------------------
	--Custom specials & bosses

	HordeCompositions.onslaught_custom_special_denial = {
		{
			name = "gasrat",
			weight = 10,
			breeds = {
				"skaven_poison_wind_globadier",
				{
					1,
					1
				}
			}
		},
		{
			name = "gunner",
			weight = 10,
			breeds = {
				"skaven_ratling_gunner",
				{
					1,
					1
				}
			}
		},
		{
			name = "stormer",
			weight = 10,
			breeds = {
				"chaos_vortex_sorcerer",
				{
					1,
					1
				}
			}
		},
	}

	HordeCompositions.onslaught_custom_specials_heavy_denial = {
		{
			name = "gasrat",
			weight = 10,
			breeds = {
				"skaven_poison_wind_globadier",
				{
					2,
					2
				},
				"skaven_ratling_gunner",
				{
					1,
					1
				},
				"chaos_vortex_sorcerer",
				{
					1,
					1
				}
			}
		},
		{
			name = "gunner",
			weight = 10,
			breeds = {
				"skaven_poison_wind_globadier",
				{
					1,
					1
				},
				"skaven_ratling_gunner",
				{
					2,
					2
				},
				"chaos_vortex_sorcerer",
				{
					1,
					1
				}
			}
		},
		{
			name = "stormer",
			weight = 10,
			breeds = {
				"skaven_poison_wind_globadier",
				{
					1,
					1
				},
				"skaven_ratling_gunner",
				{
					1,
					1
				},
				"chaos_vortex_sorcerer",
				{
					2,
					2
				}
			}
		},
	}

	HordeCompositions.onslaught_custom_special_disabler = {
		{
			name = "assassin",
			weight = 10,
			breeds = {
				"skaven_gutter_runner",
				{
					1,
					1
				}
			}
		},
		{
			name = "packmaster",
			weight = 10,
			breeds = {
				"skaven_pack_master",
				{
					1,
					1
				}
			}
		},
		{
			name = "leech",
			weight = 10,
			breeds = {
				"chaos_corruptor_sorcerer",
				{
					1,
					1
				}
			}
		},
	}

	HordeCompositions.onslaught_custom_specials_heavy_disabler = {
		{
			name = "assassin",
			weight = 10,
			breeds = {
				"skaven_gutter_runner",
				{
					2,
					2
				},
				"skaven_pack_master",
				{
					1,
					1
				}
			}
		},
		{
			name = "packmaster",
			weight = 10,
			breeds = {
				"skaven_pack_master",
				{
					2,
					2
				},
				"chaos_corruptor_sorcerer",
				{
					1,
					1
				}
			}
		},
		{
			name = "leech",
			weight = 10,
			breeds = {
				"chaos_corruptor_sorcerer",
				{
					2,
					2
				},
				"skaven_gutter_runner",
				{
					1,
					1
				}
			}
		},
		{
			name = "mixed",
			weight = 10,
			breeds = {
				"skaven_gutter_runner",
				{
					1,
					1
				},
				"skaven_pack_master",
				{
					1,
					1
				},
				"chaos_corruptor_sorcerer",
				{
					1,
					1
				}
			}
		}
	}

	HordeCompositions.onslaught_custom_special_skaven = {
		{
			name = "assassin",
			weight = 10,
			breeds = {
				"skaven_gutter_runner",
				{
					1,
					1
				}
			}
		},
		{
			name = "packmaster",
			weight = 10,
			breeds = {
				"skaven_pack_master",
				{
					1,
					1
				}
			}
		},
		{
			name = "gasrat",
			weight = 10,
			breeds = {
				"skaven_poison_wind_globadier",
				{
					1,
					1
				}
			}
		},
		{
			name = "gunner",
			weight = 10,
			breeds = {
				"skaven_ratling_gunner",
				{
					1,
					1
				}
			}
		},
		{
			name = "warpfire",
			weight = 10,
			breeds = {
				"skaven_warpfire_thrower",
				{
					1,
					1
				}
			}
		}
	}

	HordeCompositions.onslaught_custom_boss_ogre = {
		{
			name = "ogre",
			weight = 10,
			breeds = {
				"skaven_rat_ogre",
				{
					1,
					1
				}
			}
		},
	}

	HordeCompositions.onslaught_custom_boss_stormfiend = {
		{
			name = "fiend",
			weight = 10,
			breeds = {
				"skaven_stormfiend",
				{
					1,
					1
				}
			}
		},
	}

	HordeCompositions.onslaught_custom_boss_spawn = {
		{
			name = "spawn",
			weight = 10,
			breeds = {
				"chaos_spawn",
				{
					1,
					1
				}
			}
		},
	}

	HordeCompositions.onslaught_custom_boss_troll = {
		{
			name = "troll",
			weight = 10,
			breeds = {
				"chaos_troll",
				{
					1,
					1
				}
			}
		},
	}
	
	HordeCompositions.onslaught_custom_boss_minotaur = {
		{
			name = "mino",
			weight = 10,
			breeds = {
				"beastmen_minotaur",
				{
					1,
					1
				}
			}
		},
	}

	HordeCompositions.onslaught_custom_boss_random = {
		{
			name = "ogre",
			weight = 5,
			breeds = {
				"skaven_rat_ogre",
				{
					1,
					1
				}
			}
		},
		{
			name = "fiend",
			weight = 5,
			breeds = {
				"skaven_stormfiend",
				{
					1,
					1
				}
			}
		},
		{
			name = "spawn",
			weight = 5,
			breeds = {
				"chaos_spawn",
				{
					1,
					1
				}
			}
		},
		{
			name = "troll",
			weight = 5,
			breeds = {
				"chaos_troll",
				{
					1,
					1
				}
			}
		}
	}
	
	HordeCompositions.onslaught_custom_boss_random = {
		{
			name = "ogre",
			weight = 5,
			breeds = {
				"skaven_rat_ogre",
				{
					1,
					1
				}
			}
		},
		{
			name = "fiend",
			weight = 5,
			breeds = {
				"skaven_stormfiend",
				{
					1,
					1
				}
			}
		},
		{
			name = "spawn",
			weight = 5,
			breeds = {
				"chaos_spawn",
				{
					1,
					1
				}
			}
		},
		{
			name = "troll",
			weight = 5,
			breeds = {
				"chaos_troll",
				{
					1,
					1
				}
			}
		}
	}
	
	HordeCompositions.onslaught_custom_boss_random_no_fiend = {
		{
			name = "ogre",
			weight = 5,
			breeds = {
				"skaven_rat_ogre",
				{
					1,
					1
				}
			}
		},
		{
			name = "spawn",
			weight = 5,
			breeds = {
				"chaos_spawn",
				{
					1,
					1
				}
			}
		},
		{
			name = "troll",
			weight = 5,
			breeds = {
				"chaos_troll",
				{
					1,
					1
				}
			}
		}
	}

	local function spawned_during_event()
		return Managers.state.conflict:enemies_spawned_during_event()
	end
	---------------------
	--Righteous Stand

	TerrorEventBlueprints.military.military_courtyard_event_01 = {
		{
			"set_master_event_running",
			name = "military_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return (count_event_breed("chaos_marauder") + count_event_breed("chaos_marauder_with_shield")) < 20 and count_event_breed("chaos_fanatic") < 26
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "event_extra_spice_unshielded"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 27 and count_event_breed("skaven_storm_vermin_commander") < 8 and count_event_breed("skaven_slave") < 40
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard_hidden",
			composition_type = "onslaught_event_military_courtyard_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard_hidden",
			composition_type = "onslaught_event_military_courtyard_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "onslaught_courtyard_roof_middle",
			composition_type = "onslaught_custom_boss_random_no_fiend"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 8
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return count_event_breed("skaven_plague_monk") < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 8
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return (count_event_breed("chaos_marauder") + count_event_breed("chaos_marauder_with_shield")) < 24 and count_event_breed("chaos_fanatic") < 32
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "event_extra_spice_unshielded"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 30 and count_event_breed("skaven_storm_vermin_commander") < 10 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_plague_monk") < 12
			end
		},
				{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "onslaught_event_military_courtyard_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "event_extra_spice_unshielded"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 30 and count_event_breed("skaven_storm_vermin_commander") < 10 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_plague_monk") < 12
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "event_extra_spice_unshielded"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 30 and count_event_breed("skaven_storm_vermin_commander") < 10 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_plague_monk") < 12
			end
		},
		{
			"flow_event",
			flow_event_name = "military_courtyard_event_done"
		}
	}
	
	TerrorEventBlueprints.military.military_courtyard_event_02 = TerrorEventBlueprints.military.military_courtyard_event_01

	TerrorEventBlueprints.military.military_courtyard_event_specials_01 = {
		{
			"set_master_event_running",
			name = "military_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard_hidden",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard_hidden",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"flow_event",
			flow_event_name = "military_courtyard_event_specials_done"
		}
	}

	TerrorEventBlueprints.military.military_courtyard_event_specials_02 = {
		{
			"set_master_event_running",
			name = "military_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_courtyard_roof_left",
			composition_type = "onslaught_chaos_berzerkers_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_courtyard_roof_right",
			composition_type = "onslaught_chaos_berzerkers_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_courtyard_roof_left",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_courtyard_roof_right",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard_hidden",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"delay",
			duration = 15
		},
		{
			"flow_event",
			flow_event_name = "military_courtyard_event_specials_done"
		}
	}

	TerrorEventBlueprints.military.military_courtyard_event_specials_03 = {
		{
			"set_master_event_running",
			name = "military_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_courtyard_roof_left",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_courtyard_roof_left",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_courtyard_roof_right",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "onslaught_courtyard_roof_left",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "onslaught_courtyard_roof_right",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "onslaught_courtyard_roof_right",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_courtyard_roof_right",
			composition_type = "onslaught_chaos_berzerkers_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "onslaught_plague_monks_medium"
		},		
		{
			"delay",
			duration = 15
		},
		{
			"flow_event",
			flow_event_name = "military_courtyard_event_specials_done"
		}
	}

	TerrorEventBlueprints.military.military_courtyard_event_specials_04 = {
		{
			"set_master_event_running",
			name = "military_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_courtyard_roof_left",
			composition_type = "onslaught_custom_specials_heavy_disabler"
		},		
		{
			"delay",
			duration = 15
		},
		{
			"flow_event",
			flow_event_name = "military_courtyard_event_specials_done"
		}
	}

	TerrorEventBlueprints.military.military_courtyard_event_specials_05 = {
		{
			"set_master_event_running",
			name = "military_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_courtyard_roof_right",
			composition_type = "onslaught_custom_specials_heavy_disabler"
		},
		{
			"delay",
			duration = 15
		},
		{
			"flow_event",
			flow_event_name = "military_courtyard_event_specials_done"
		}
	}

	--01	Warriors & Plague Monks
	--02	Berzerkers & Stormvermins
	--03	Mixed Shielders
	--04	Extra Denial
	--05	Extra Disablers
	
	HordeCompositions.onslaught_military_mauler_assault = {
		{
			name = "plain",
			weight = 1,
			breeds = {
				"chaos_raider",
				{
				15,
				16
				},
				"chaos_warrior",
				{
				5,
				6
				},
			}
		}
	}
	
	HordeCompositions.military_end_event_chaos_01 = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_raider",
				{
					10,
					13,
				},
				"chaos_marauder",
				{
					20,
					22
				},
				"chaos_fanatic",
				{
					20,
					22
				}
			}
		},
		{
			name = "mixed",
			weight = 3,
			breeds = {
				"chaos_raider",
				{
					10,
					13,
				},
				"chaos_marauder_with_shield",
				{
					10,
					12
				},
				"chaos_marauder",
				{
					8,
					9
				},
				"chaos_fanatic",
				{
					18,
					19
				}
			}
		}
	}
	
	HordeCompositions.military_end_event_berzerkers = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_berzerker",
				15,
				"chaos_marauder_with_shield",
				20
			}
		}
	}
	
	TerrorEventBlueprints.military.military_temple_guards = {
		{
			"disable_kick"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards02",
			breed_name = "chaos_raider"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards05",
			breed_name = "chaos_marauder_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards06",
			breed_name = "chaos_raider"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards07",
			breed_name = "chaos_marauder_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards09",
			breed_name = "chaos_warrior"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_temple_guard_assault",
			composition_type = "onslaught_military_mauler_assault"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_start = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"disable_kick"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "end_event_start",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "end_event_back_hidden",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back_hidden",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back_hidden",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_custom_boss_troll"
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 25 and count_event_breed("skaven_clan_rat_with_shield") < 24 and count_event_breed("skaven_slave") < 30 and count_event_breed("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_start_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_01_back = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "military_end_event_chaos_01"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 50,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 9 and count_event_breed("skaven_clan_rat_with_shield") < 9 and count_event_breed("skaven_slave") < 15 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("chaos_marauder") < 8 and count_event_breed("chaos_marauder_with_shield") < 6 and count_event_breed("chaos_fanatic") < 12 and count_event_breed("chaos_raider") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_01_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_01_right = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right_hidden",
			composition_type = "military_end_event_chaos_01"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 50,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 9 and count_event_breed("skaven_clan_rat_with_shield") < 9 and count_event_breed("skaven_slave") < 15 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("chaos_marauder") < 8 and count_event_breed("chaos_marauder_with_shield") < 6 and count_event_breed("chaos_fanatic") < 12 and count_event_breed("chaos_raider") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_01_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_02_left = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_left",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_left",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_left",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_left_hidden",
			composition_type = "military_end_event_chaos_01"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_custom_boss_spawn"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 9 and count_event_breed("skaven_clan_rat_with_shield") < 9 and count_event_breed("skaven_slave") < 15 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("chaos_marauder") < 8 and count_event_breed("chaos_marauder_with_shield") < 6 and count_event_breed("chaos_fanatic") < 12 and count_event_breed("chaos_raider") < 6 and count_event_breed("skaven_plague_monk") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_02_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_02_right = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right_hidden",
			composition_type = "military_end_event_chaos_01"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_custom_boss_spawn"
		},
		{
			"delay",
			duration = 10
		},		
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 9 and count_event_breed("skaven_clan_rat_with_shield") < 9 and count_event_breed("skaven_slave") < 15 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("chaos_marauder") < 8 and count_event_breed("chaos_marauder_with_shield") < 6 and count_event_breed("chaos_fanatic") < 12 and count_event_breed("chaos_raider") < 6 and count_event_breed("skaven_plague_monk") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_02_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_02_middle = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_middle",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_middle",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_middle",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "military_end_event_chaos_01"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_custom_boss_spawn"
		},
		{
			"delay",
			duration = 10
		},		
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 9 and count_event_breed("skaven_clan_rat_with_shield") < 9 and count_event_breed("skaven_slave") < 15 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("chaos_marauder") < 8 and count_event_breed("chaos_marauder_with_shield") < 6 and count_event_breed("chaos_fanatic") < 12 and count_event_breed("chaos_raider") < 6 and count_event_breed("skaven_plague_monk") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_02_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_02_back = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "military_end_event_chaos_01"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_custom_boss_spawn"
		},
		{
			"delay",
			duration = 10
		},		
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 9 and count_event_breed("skaven_clan_rat_with_shield") < 9 and count_event_breed("skaven_slave") < 15 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("chaos_marauder") < 8 and count_event_breed("chaos_marauder_with_shield") < 6 and count_event_breed("chaos_fanatic") < 12 and count_event_breed("chaos_raider") < 6 and count_event_breed("skaven_plague_monk") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_02_done"
		}
	}

	TerrorEventBlueprints.military.military_end_event_survival_03_left = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_left_hidden",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_left_hidden",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_left",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 25 and count_event_breed("skaven_slave") < 28 and count_event_breed("skaven_storm_vermin_commander") < 8 and count_event_breed("skaven_storm_vermin_with_shield") < 8 and count_event_breed("skaven_plague_monk") < 8
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_03_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_03_right = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 25 and count_event_breed("skaven_slave") < 28 and count_event_breed("skaven_storm_vermin_commander") < 8 and count_event_breed("skaven_storm_vermin_with_shield") < 8 and count_event_breed("skaven_plague_monk") < 8
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_03_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_03_middle = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_middle",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_middle",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_middle",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 25 and count_event_breed("skaven_slave") < 28 and count_event_breed("skaven_storm_vermin_commander") < 8 and count_event_breed("skaven_storm_vermin_with_shield") < 8 and count_event_breed("skaven_plague_monk") < 8
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_03_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_03_back = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 15 and count_event_breed("skaven_slave") < 18 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("skaven_storm_vermin_with_shield") < 5 and count_event_breed("skaven_plague_monk") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_03_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_04_left = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_left_hidden",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_left",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 9 and count_event_breed("skaven_clan_rat_with_shield") < 9 and count_event_breed("skaven_slave") < 15 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("chaos_marauder") < 8 and count_event_breed("chaos_marauder_with_shield") < 6 and count_event_breed("chaos_fanatic") < 12 and count_event_breed("chaos_raider") < 6 and count_event_breed("chaos_berzerker") < 6 and count_event_breed("skaven_plague_monk") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_04_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_04_right = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right_hidden",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 9 and count_event_breed("skaven_clan_rat_with_shield") < 9 and count_event_breed("skaven_slave") < 15 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("chaos_marauder") < 8 and count_event_breed("chaos_marauder_with_shield") < 6 and count_event_breed("chaos_fanatic") < 12 and count_event_breed("chaos_raider") < 6 and count_event_breed("chaos_berzerker") < 6 and count_event_breed("skaven_plague_monk") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_04_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_04_middle = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back_hidden",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_middle",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 9 and count_event_breed("skaven_clan_rat_with_shield") < 9 and count_event_breed("skaven_slave") < 15 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("chaos_marauder") < 8 and count_event_breed("chaos_marauder_with_shield") < 6 and count_event_breed("chaos_fanatic") < 12 and count_event_breed("chaos_raider") < 6 and count_event_breed("chaos_berzerker") < 6 and count_event_breed("skaven_plague_monk") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_04_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_04_back = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back_hidden",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 9 and count_event_breed("skaven_clan_rat_with_shield") < 9 and count_event_breed("skaven_slave") < 15 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("chaos_marauder") < 8 and count_event_breed("chaos_marauder_with_shield") < 6 and count_event_breed("chaos_fanatic") < 12 and count_event_breed("chaos_raider") < 6 and count_event_breed("chaos_berzerker") < 6 and count_event_breed("skaven_plague_monk") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_04_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_05_left = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_left",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "end_event_left",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_left_hidden",
			composition_type = "onslaught_plague_monks_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_left_hidden",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_left_hidden",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 6 and count_event_breed("skaven_clan_rat_with_shield") < 5 and count_event_breed("skaven_slave") < 12 and count_event_breed("skaven_storm_vermin_commander") < 3 and count_event_breed("skaven_storm_vermin_with_shield") < 2 and count_event_breed("skaven_plague_monk") < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_05_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_05_right = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "end_event_right",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right_hidden",
			composition_type = "onslaught_plague_monks_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right_hidden",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right_hidden",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 6 and count_event_breed("skaven_clan_rat_with_shield") < 5 and count_event_breed("skaven_slave") < 12 and count_event_breed("skaven_storm_vermin_commander") < 3 and count_event_breed("skaven_storm_vermin_with_shield") < 2 and count_event_breed("skaven_plague_monk") < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_05_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_05_middle = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_middle",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "end_event_middle",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_plague_monks_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 6 and count_event_breed("skaven_clan_rat_with_shield") < 5 and count_event_breed("skaven_slave") < 12 and count_event_breed("skaven_storm_vermin_commander") < 3 and count_event_breed("skaven_storm_vermin_with_shield") < 2 and count_event_breed("skaven_plague_monk") < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_05_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_05_back = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "end_event_back",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_plague_monks_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_military_end_event_plague_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 6 and count_event_breed("skaven_clan_rat_with_shield") < 5 and count_event_breed("skaven_slave") < 12 and count_event_breed("skaven_storm_vermin_commander") < 3 and count_event_breed("skaven_storm_vermin_with_shield") < 2 and count_event_breed("skaven_plague_monk") < 3
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_05_done"
		}
	}

	TerrorEventBlueprints.military.military_end_event_survival_06_right = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_right_hidden",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right_hidden",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_right_hidden",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 3 and count_event_breed("skaven_slave") < 5 and count_event_breed("skaven_storm_vermin_commander") < 1 and count_event_breed("chaos_marauder") < 2 and count_event_breed("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_06_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_06_middle = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_middle",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_left_hidden",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_left_hidden",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 3 and count_event_breed("skaven_slave") < 5 and count_event_breed("skaven_storm_vermin_commander") < 1 and count_event_breed("chaos_marauder") < 2 and count_event_breed("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_06_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_survival_06_back = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_back_hidden",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back_hidden",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_back_hidden",
			composition_type = "military_end_event_berzerkers"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 3 and count_event_breed("skaven_slave") < 5 and count_event_breed("skaven_storm_vermin_commander") < 1 and count_event_breed("chaos_marauder") < 2 and count_event_breed("chaos_marauder_with_shield") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_06_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_specials_01 = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"event_horde",
			spawner_id = "end_event_left_hidden",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			spawner_id = "end_event_right_hidden",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("skaven_gutter_runner") < 2 and count_event_breed("skaven_pack_master") < 2 and count_event_breed("skaven_ratling_gunner") < 2 and count_event_breed("skaven_warpfire_thrower") and count_event_breed("skaven_poison_wind_globadier") < 2 and count_event_breed("chaos_vortex_sorcerer") < 3 and count_event_breed("chaos_corruptor_sorcerer") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_specials_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_specials_02 = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"event_horde",
			spawner_id = "end_event_left_hidden",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			spawner_id = "end_event_right_hidden",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_custom_special_disabler"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("skaven_gutter_runner") < 2 and count_event_breed("skaven_pack_master") < 2 and count_event_breed("skaven_ratling_gunner") < 2 and count_event_breed("skaven_warpfire_thrower") and count_event_breed("skaven_poison_wind_globadier") < 2 and count_event_breed("chaos_vortex_sorcerer") < 3 and count_event_breed("chaos_corruptor_sorcerer") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_specials_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_specials_03 = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"event_horde",
			spawner_id = "end_event_left_hidden",
			composition_type = "onslaught_custom_special_disabler"
		},
		{
			"event_horde",
			spawner_id = "end_event_right_hidden",
			composition_type = "onslaught_custom_special_disabler"
		},
		{
			"event_horde",
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("skaven_gutter_runner") < 2 and count_event_breed("skaven_pack_master") < 2 and count_event_breed("skaven_ratling_gunner") < 2 and count_event_breed("skaven_warpfire_thrower") and count_event_breed("skaven_poison_wind_globadier") < 2 and count_event_breed("chaos_vortex_sorcerer") < 3 and count_event_breed("chaos_corruptor_sorcerer") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_specials_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_specials_04 = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"event_horde",
			spawner_id = "end_event_left_hidden",
			composition_type = "onslaught_custom_special_disabler"
		},
		{
			"event_horde",
			spawner_id = "end_event_right_hidden",
			composition_type = "onslaught_custom_special_disabler"
		},
		{
			"event_horde",
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("skaven_gutter_runner") < 2 and count_event_breed("skaven_pack_master") < 2 and count_event_breed("skaven_ratling_gunner") < 2 and count_event_breed("skaven_warpfire_thrower") and count_event_breed("skaven_poison_wind_globadier") < 2 and count_event_breed("chaos_vortex_sorcerer") < 3 and count_event_breed("chaos_corruptor_sorcerer") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_specials_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_specials_05 = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"event_horde",
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_custom_specials_heavy_denial"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("skaven_gutter_runner") < 2 and count_event_breed("skaven_pack_master") < 2 and count_event_breed("skaven_ratling_gunner") < 2 and count_event_breed("skaven_warpfire_thrower") and count_event_breed("skaven_poison_wind_globadier") < 2 and count_event_breed("chaos_vortex_sorcerer") < 3 and count_event_breed("chaos_corruptor_sorcerer") < 2
			end	
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_specials_done"
		}
	}
	
	TerrorEventBlueprints.military.military_end_event_specials_06 = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"event_horde",
			spawner_id = "end_event_left_hidden",
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"event_horde",
			spawner_id = "end_event_right_hidden",
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"event_horde",
			spawner_id = "end_event_back_hidden",
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"delay",
			duration = 8
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("skaven_gutter_runner") < 2 and count_event_breed("skaven_pack_master") < 2 and count_event_breed("skaven_ratling_gunner") < 2 and count_event_breed("skaven_warpfire_thrower") and count_event_breed("skaven_poison_wind_globadier") < 2 and count_event_breed("chaos_vortex_sorcerer") < 3 and count_event_breed("chaos_corruptor_sorcerer") < 2
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_specials_done"
		}
	}
	
	--01 2x denial 1x skaven
	--02 2x denial 1x disabler
	--03 2x disabler 1x denial
	--04 2x disabler 1x skaven
	--05 Mass denial
	--06 3x skaven
	
	TerrorEventBlueprints.military.military_end_event_survival_escape = {
		{
			"set_master_event_running",
			name = "military_end_event_survival"
		},
		{
			"control_specials",
			enable = true
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_start",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 10 and count_event_breed("skaven_slave") < 12
			end
		},
		{
			"flow_event",
			flow_event_name = "military_end_event_survival_escape_done"
		}
	}
	
	---------------------
	--Convocation of Decay
	
	TerrorEventBlueprints.catacombs.catacombs_puzzle_event_loop = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "catacombs_puzzle_event_loop"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "puzzle_event_loop",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "puzzle_event_loop",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "puzzle_event_loop",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "puzzle_event_loop",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "puzzle_event_loop",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "puzzle_event_loop",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 50,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 30 and count_event_breed("skaven_slave") < 36 and (count_event_breed("skaven_storm_vermin_commander") + count_event_breed("skaven_storm_vermin_with_shield")) < 12
			end
		},
		{
			"delay",
			duration = 7
		},
		{
			"flow_event",
			flow_event_name = "catacombs_puzzle_event_loop_done"
		}
	}
	
	TerrorEventBlueprints.catacombs.catacombs_puzzle_event_a = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "catacombs_puzzle_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "enemy_door",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "enemy_door",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "enemy_door",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "enemy_door",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"flow_event",
			flow_event_name = "catacombs_puzzle_event_a_done"
		}
	}
	
	TerrorEventBlueprints.catacombs.catacombs_puzzle_event_b = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "catacombs_puzzle_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "enemy_door",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "enemy_door",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "enemy_door",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"flow_event",
			flow_event_name = "catacombs_puzzle_event_b_done"
		}
	}
	
	TerrorEventBlueprints.catacombs.catacombs_puzzle_event_c = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "catacombs_puzzle_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "enemy_door",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "enemy_door",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "enemy_door",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "enemy_door",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "enemy_door",
			composition_type = "event_maulers_medium"
		},
		{
			"flow_event",
			flow_event_name = "catacombs_puzzle_event_c_done"
		}
	}
	
	TerrorEventBlueprints.catacombs.catacombs_special_event_a = {
		{
			"spawn_at_raw",
			spawner_id = "puzzle_special_01",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "puzzle_special_01",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "puzzle_event_loop",
			composition_type = "onslaught_storm_vermin_shields_small"
		}
	}
	
	TerrorEventBlueprints.catacombs.catacombs_special_event_b = {
		{
			"spawn_at_raw",
			spawner_id = "puzzle_special_02",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"spawn_at_raw",
			spawner_id = "puzzle_special_02",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "puzzle_event_loop",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "puzzle_event_loop",
			composition_type = "onslaught_plague_monks_medium"
		}
	}
	
	TerrorEventBlueprints.catacombs.catacombs_special_event_c = {
		{
			"spawn_at_raw",
			spawner_id = "puzzle_special_01",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"spawn_at_raw",
			spawner_id = "puzzle_special_02",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"spawn_at_raw",
			spawner_id = "puzzle_special_03",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "puzzle_event_loop",
			composition_type = "onslaught_plague_monks_medium"
		},
	}
	
	--a shields & warriors 
	--b maulers
	--c berzerkers

	--a special shielded storm
	--b special monk
	--c special mass warpfire
	
	--Because otherwise triple boss event is triggered early by respawning player..
	local function living_player_has_dropped()
		for i, player in pairs(Managers.player:players()) do
			if player.player_unit then
				local status_extension = ScriptUnit.has_extension(player.player_unit, "status_system")
				if status_extension and not status_extension.is_ready_for_assisted_respawn(status_extension) then
					if POSITION_LOOKUP[player.player_unit].z < -15 then
						return true
					end
				end
			end
		end
		return false
	end
	
	TerrorEventBlueprints.catacombs.catacombs_load_sorcerers = {
		{
			"force_load_breed_package",
			breed_name = "chaos_dummy_sorcerer"
		},
		{
			"continue_when",
			condition = function (t)
				return living_player_has_dropped()
			end
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_pool_boss_1",
			breed_name = {
				"chaos_spawn",
				"beastmen_minotaur"
			},
			optional_data = {
				max_health_modifier = 1,
				enhancements = life_leach,
				spawned_func = degenerating_times_2
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_pool_boss_3",
			breed_name = {
				"skaven_rat_ogre"
			},
			optional_data = {
				max_health_modifier = 1,
				enhancements = life_leach,
				spawned_func = degenerating_times_2
			}
		},
		{
			"delay",
			duration = 20
		},
		{
			"control_pacing",
			enable = true
		},
	}
	
	TerrorEventBlueprints.catacombs.catacombs_end_event_01 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "catacombs_end_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "end_event",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "onslaught_chaos_warriors"
		},	
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"flow_event",
			flow_event_name = "catacombs_end_event_01_done"
		}
	}
	
	TerrorEventBlueprints.catacombs.catacombs_end_event_02 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "catacombs_end_event"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "end_event",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},		
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "end_event",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"flow_event",
			flow_event_name = "catacombs_end_event_02_done"
		}
	}
	
	TerrorEventBlueprints.catacombs.catacombs_end_event_specials_01 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "catacombs_end_event_specials"
		},
		{
			"spawn_special",
			amount = 2,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_special",
			amount = 2,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_special",
			amount = 2,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 2,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return count_event_breed("skaven_poison_wind_globadier") + count_event_breed("skaven_ratling_gunner") + count_event_breed("skaven_warpfire_thrower") + count_event_breed("skaven_pack_master") + count_event_breed("skaven_gutter_runner") + count_event_breed("chaos_corruptor_sorcerer") < 7
			end
		},
		{
			"flow_event",
			flow_event_name = "catacombs_end_event_specials_done"
		}
	}
	
	TerrorEventBlueprints.catacombs.catacombs_end_event_specials_02 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "catacombs_end_event_specials"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("skaven_poison_wind_globadier") + count_event_breed("skaven_ratling_gunner") + count_event_breed("skaven_warpfire_thrower") + count_event_breed("skaven_pack_master") + count_event_breed("skaven_gutter_runner") + count_event_breed("chaos_corruptor_sorcerer") < 9
			end
		},
		{
			"flow_event",
			flow_event_name = "catacombs_end_event_specials_done"
		}
	}
	
	TerrorEventBlueprints.catacombs.catacombs_end_event_specials_03 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "catacombs_end_event_specials"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("skaven_poison_wind_globadier") + count_event_breed("skaven_ratling_gunner") + count_event_breed("skaven_warpfire_thrower") + count_event_breed("skaven_pack_master") + count_event_breed("skaven_gutter_runner") + count_event_breed("chaos_corruptor_sorcerer") < 9
			end
		},
		{
			"flow_event",
			flow_event_name = "catacombs_end_event_specials_done"
		}
	}
	
	---------------------
	--Hunger in the Dark
	
	TerrorEventBlueprints.mines.mines_end_event_start = {
		{
			"disable_kick"
		},
		{
			"enable_bots_in_carry_event"
		}
	}
	
	TerrorEventBlueprints.mines.mines_end_event_first_wave = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_mines_extra_troll_3",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_mines_extra_troll_1",
			breed_name = "chaos_troll",
			optional_data = {
				enhancements = enhancement_1
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 30 and count_event_breed("skaven_slave") < 30 and (count_event_breed("skaven_storm_vermin") + count_event_breed("skaven_storm_vermin_with_shield")) < 12
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_first_wave_done"
		}
	}
	
	TerrorEventBlueprints.mines.mines_end_event_loop = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_mines_extra_troll_3",
			breed_name = "chaos_troll",
			optional_data = {
				enhancements = enhancement_1
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return (count_event_breed("chaos_marauder") + count_event_breed("chaos_marauder_with_shield")) < 25 and count_event_breed("chaos_berzerker") < 12
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "event_small"
		},	
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 5,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 5,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "event_maulers_small"
		},
		{
			"delay",
			duration = 25
		},
		{
			"continue_when",
			duration = 5,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stingers_plague_monk"
		},
		{
			"delay",
			duration = 2
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stingers_plague_monk"
		},
		{
			"delay",
			duration = 2
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stingers_plague_monk"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stingers_plague_monk"
		},
		{
			"delay",
			duration = 25
		},
		{
			"continue_when",
			duration = 5,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_loop_done"
		}
	}
	
	TerrorEventBlueprints.mines.mines_end_event_loop_02 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "event_maulers_medium"
		},	
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 5,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_small"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 5,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "event_maulers_small"
		},	
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "event_maulers_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 5,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event",
			composition_type = "event_medium"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stingers_plague_monk"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "onslaught_plague_monks_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_plague_monks_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 5,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_loop_02_done"
		}
	}
	
	TerrorEventBlueprints.mines.mines_end_event_specials_01 = {
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return (count_event_breed("skaven_poison_wind_globadier") + count_event_breed("skaven_ratling_gunner") + count_event_breed("skaven_warpfire_thrower") + count_event_breed("skaven_pack_master") + count_event_breed("skaven_gutter_runner") + count_event_breed("chaos_corruptor_sorcerer") + count_event_breed("chaos_vortex_sorcerer")) < 8 and (count_event_breed("skaven_gutter_runner") + count_event_breed("skaven_pack_master") + count_event_breed("chaos_corruptor_sorcerer")) < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_specials_done"
		}
	}
	
	TerrorEventBlueprints.mines.mines_end_event_specials_02 = {
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return (count_event_breed("skaven_poison_wind_globadier") + count_event_breed("skaven_ratling_gunner") + count_event_breed("skaven_warpfire_thrower") + count_event_breed("skaven_pack_master") + count_event_breed("skaven_gutter_runner") + count_event_breed("chaos_corruptor_sorcerer") + count_event_breed("chaos_vortex_sorcerer")) < 8 and (count_event_breed("skaven_gutter_runner") + count_event_breed("skaven_pack_master") + count_event_breed("chaos_corruptor_sorcerer")) < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_specials_done"
		}
	}
	
	TerrorEventBlueprints.mines.mines_end_event_specials_03 = {
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return (count_event_breed("skaven_poison_wind_globadier") + count_event_breed("skaven_ratling_gunner") + count_event_breed("skaven_warpfire_thrower") + count_event_breed("skaven_pack_master") + count_event_breed("skaven_gutter_runner") + count_event_breed("chaos_corruptor_sorcerer") + count_event_breed("chaos_vortex_sorcerer")) < 8 and (count_event_breed("skaven_gutter_runner") + count_event_breed("skaven_pack_master") + count_event_breed("chaos_corruptor_sorcerer")) < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_specials_done"
		}
	}
	
	TerrorEventBlueprints.mines.mines_end_event_stop = {
		{
			"control_specials",
			enable = true
		}
	}
	
	TerrorEventBlueprints.mines.mines_end_event_trolls = {
		{
			"force_load_breed_package",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_01",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_02",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_03",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_04",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_05",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_06",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_07",
			breed_name = "chaos_dummy_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "troll_08",
			breed_name = "chaos_dummy_troll"
		},
		{
			"stop_event",
			stop_event_name = "mines_end_event_loop"
		},
		{
			"stop_event",
			stop_event_name = "mines_end_event_loop_02"
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_trolls_done"
		}
	}
	
	TerrorEventBlueprints.mines.mines_troll_boss = {
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_bell_boss",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},			
		{
			"spawn_at_raw",
			spawner_id = "troll_boss",
			breed_name = "chaos_troll"
		},
		{
			"set_time_challenge",
			time_challenge_name = "mines_speed_event"
		},
		{
			"set_time_challenge",
			time_challenge_name = "mines_speed_event_cata"
		},
		{
			"continue_when",
			duration = 90,
			condition = function (t)
				return count_event_breed("chaos_troll") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_troll_boss_done"
		},
		{
			"has_completed_time_challenge",
			time_challenge_name = "mines_speed_event"
		},
		{
			"has_completed_time_challenge",
			time_challenge_name = "mines_speed_event_cata"
		}
	}
	
	TerrorEventBlueprints.mines.mines_end_event_escape = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "end_event"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "escape",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "escape",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "escape",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return (count_event_breed("chaos_marauder") + count_event_breed("chaos_marauder_with_shield")) < 15 and count_event_breed("chaos_berzerker") < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "escape",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 12 and count_event_breed("skaven_slave") < 15 and (count_event_breed("skaven_storm_vermin") + count_event_breed("skaven_storm_vermin_with_shield")) < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "mines_end_event_escape_done"
		}
	}
	
	---------------------
	--Halescourge

	TerrorEventBlueprints.ground_zero.gz_elevator_guards_a = {
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_a_1",
			breed_name = "skaven_storm_vermin_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_a_2",
			breed_name = "skaven_storm_vermin_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_a_3",
			breed_name = "chaos_warrior"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_a_4",
			breed_name = "chaos_warrior"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_a_5",
			breed_name = "skaven_storm_vermin_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_a_6",
			breed_name = "skaven_storm_vermin_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_1",
			breed_name = "skaven_clan_rat_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_2",
			breed_name = "skaven_clan_rat_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_3",
			breed_name = "skaven_clan_rat_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_4",
			breed_name = "skaven_clan_rat_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_5",
			breed_name = "skaven_clan_rat_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_6",
			breed_name = "skaven_clan_rat_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_7",
			breed_name = "skaven_clan_rat_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "ele_guard_b_8",
			breed_name = "skaven_clan_rat_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_ele_guard_c_1",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_ele_guard_c_2",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_ele_guard_c_3",
			breed_name = "chaos_warrior"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_ele_guard_c_4",
			breed_name = "chaos_warrior"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_ele_guard_c_5",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_ele_guard_c_6",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"delay",
			duration = 5
		}
	}

	local ACTIONS = BreedActions.chaos_exalted_sorcerer
	local restore_bubbledude = {
		"BTSpawnAllies",
		enter_hook = "sorcerer_spawn_horde",
		name = "sorcerer_spawn_horde",
		action_data = ACTIONS.spawn_allies_horde
	}

	table.insert(BreedBehaviors.chaos_exalted_sorcerer[7], 2, restore_bubbledude)

	TerrorEventBlueprints.ground_zero.gz_chaos_boss = {
		{
			"set_master_event_running",
			name = "gz_chaos_boss"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"spawn_at_raw",
			spawner_id = "warcamp_chaos_boss",
			breed_name = "chaos_exalted_sorcerer",
			optional_data = {
				spawned_func = degenerating
			}
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("chaos_exalted_sorcerer") == 1
			end
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 1,
			condition = function (t)
				return activate_lightning_strike()
			end
		},
		{
			"delay",
			duration = 60
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 60
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("chaos_exalted_sorcerer") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "gz_chaos_boss_dead"
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	}

	HordeCompositions.sorcerer_boss_event_defensive = {
		{
			name = "wave_a",
			weight = 9,
			breeds = {
				"chaos_fanatic",
				{
					20,
					22
				},
				"chaos_marauder",
				{
					12,
					14
				},
				"chaos_marauder_with_shield",
				{
					6,
					8
				},
				"chaos_raider",
				{
					3,
					4
				},
				"chaos_warrior",
				1,
				"chaos_plague_sorcerer",
				2
			}
		},
		{
			name = "wave_b",
			weight = 6,
			breeds = {
				"chaos_fanatic",
				{
					20,
					22
				},
				"chaos_marauder",
				{
					12,
					14
				},
				"chaos_marauder_with_shield",
				{
					6,
					8
				},
				"chaos_berzerker",
				{
					4,
					5
				},
				"chaos_warrior",
				2,
			}
		},
		{
			name = "wave_c",
			weight = 9,
			breeds = {
				"chaos_fanatic",
				{
					20,
					22
				},
				"chaos_marauder",
				{
					12,
					14
				},
				"skaven_dummy_clan_rat",
				{
					7,
					9
				},
				"chaos_berzerker",
				{
					3,
					4
				},
				"chaos_raider",
				{
					3,
					4
				},
				"chaos_plague_sorcerer",
				2
			}
		},
		{
			name = "wave_d",
			weight = 6,
			breeds = {
				"chaos_fanatic",
				{
					20,
					22
				},
				"chaos_marauder",
				{
					12,
					14
				},
				"chaos_marauder_tutorial",
				{
					4,
					5
				},
				"chaos_raider",
				{
					4,
					5
				},
				"chaos_berzerker",
				{
					2,
					3
				},
			}
		},
		{
			name = "wave_e",
			weight = 6,
			breeds = {
				"chaos_fanatic",
				{
					20,
					22
				},
				"chaos_marauder",
				{
					12,
					14
				},
				"chaos_marauder_with_shield",
				{
					6,
					8
				},
				"chaos_berzerker",
				{
					6,
					7
				},
				"chaos_warrior",
				1,
			}
		},
		start_time = 0
	}

	HordeCompositions.sorcerer_extra_spawn = HordeCompositions.sorcerer_boss_event_defensive

	---------------------
	--Athel Yenlui

	TerrorEventBlueprints.elven_ruins.elven_ruins_end_event = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_time_challenge",
			time_challenge_name = "elven_ruins_speed_event"
		},
		{
			"set_time_challenge",
			time_challenge_name = "elven_ruins_speed_event_cata"
		},
		{
			"set_master_event_running",
			name = "ruins_end_event"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"disable_kick"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_specials_heavy_denial"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_specials_heavy_denial"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_chaos",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "event_small"
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_custom_specials_heavy_denial"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_custom_specials_heavy_denial"
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_custom_specials_heavy_denial"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"delay",
			duration = {
				2,
				3
			}
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_custom_specials_heavy_denial"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_specials_heavy_denial"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_custom_specials_heavy_denial"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_custom_specials_heavy_denial"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "chaos_vortex_sorcerer"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_bottomtier",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_special_denial"
		},
		{
			"delay",
			duration = {
				5,
				7
			}
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_slave") < 40 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 9 and count_event_breed("skaven_storm_vermin_with_shield") < 9
			end
		}
	}

	TerrorEventBlueprints.elven_ruins.elven_ruins_end_event_flush = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"has_completed_time_challenge",
			time_challenge_name = "elven_ruins_speed_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "elven_ruins_toptier",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = {
				1,
				2
			}
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_boss_ogre"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_boss_stormfiend"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "onslaught_mines_horde_front",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_custom_boss_ogre"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_storm_vermin_medium"
		}
	}

	TerrorEventBlueprints.elven_ruins.elven_ruins_end_event_device_fiddlers = {
		{
			"control_specials",
			enable = false
		},
		{
			"spawn_at_raw",
			spawner_id = "device_skaven_1",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "device_skaven_2",
			breed_name = "skaven_clan_rat"
		},
		{
			"spawn_at_raw",
			spawner_id = "device_skaven_3",
			breed_name = "skaven_clan_rat"
		}
	}

	---------------------
	--Screaming Bell

	HordeCompositions.event_bell_monks = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"skaven_plague_monk",
				{
					4,
					5
				}
			}
		}
	}
	
	HordeCompositions.event_bell_warriors = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"chaos_warrior",
				10
			}
		}	
	}

	TerrorEventBlueprints.bell.canyon_bell_event = {
		{
			"set_master_event_running",
			name = "canyon_bell_event"
		},
		{
			"set_time_challenge",
			time_challenge_name = "bell_speed_event"
		},
		{
			"set_time_challenge",
			time_challenge_name = "bell_speed_event_cata"
		},
		{
			"disable_kick"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "canyon_bell_event",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "canyon_bell_event",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"control_specials",
			enable = true
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			spawner_id = "canyon_bell_event",
			composition_type = "event_bell_monks"
		},
		{
			"event_horde",
			spawner_id = "canyon_bell_event",
			composition_type = "event_bell_monks"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("skaven_slave") < 25 and count_event_breed("skaven_clan_rat") < 20 and count_event_breed("skaven_clan_rat_with_shield") < 15 and count_event_breed("skaven_storm_vermin_commander") < 8 and count_event_breed("skaven_plague_monk") < 12
			end
		},
		{
			"flow_event",
			flow_event_name = "canyon_bell_event_done"
		}
	}

	TerrorEventBlueprints.bell.canyon_ogre_boss = {
		{
			"control_specials",
			enable = true
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"spawn_at_raw",
			spawner_id = "canyon_ogre_boss",
			breed_name = "chaos_troll"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_second_ogre",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "canyon_ogre_boss",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_second_ogre",
			breed_name = "skaven_rat_ogre"
		},
		{
			"delay",
			duration = 40
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "canyon_bell_event",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "canyon_bell_event",
			composition_type = "event_bell_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_slave") < 25 and count_event_breed("skaven_clan_rat") < 20 and count_event_breed("skaven_clan_rat_with_shield") < 15 and count_event_breed("skaven_storm_vermin_commander") < 8 and count_event_breed("skaven_plague_monk") < 12
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "canyon_bell_event",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "canyon_bell_event",
			composition_type = "event_bell_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_slave") < 25 and count_event_breed("skaven_clan_rat") < 20 and count_event_breed("skaven_clan_rat_with_shield") < 15 and count_event_breed("skaven_storm_vermin_commander") < 8 and count_event_breed("skaven_plague_monk") < 12
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "canyon_bell_event",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "canyon_bell_event",
			composition_type = "event_bell_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_slave") < 25 and count_event_breed("skaven_clan_rat") < 20 and count_event_breed("skaven_clan_rat_with_shield") < 15 and count_event_breed("skaven_storm_vermin_commander") < 8 and count_event_breed("skaven_plague_monk") < 12
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "canyon_bell_event",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "canyon_bell_event",
			composition_type = "event_bell_monks"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_slave") < 25 and count_event_breed("skaven_clan_rat") < 20 and count_event_breed("skaven_clan_rat_with_shield") < 15 and count_event_breed("skaven_storm_vermin_commander") < 8 and count_event_breed("skaven_plague_monk") < 12
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "canyon_bell_event",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "canyon_bell_event",
			composition_type = "event_bell_monks"
		},
		{
			"delay",
			duration = 10
		}
	}

	TerrorEventBlueprints.bell.canyon_escape_event = {
		{
			"set_master_event_running",
			name = "canyon_escape_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "canyon_escape_event",
			composition_type = "onslaught_custom_specials_heavy_disabler"
		},		
		{
			"event_horde",
			spawner_id = "canyon_escape_event",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"control_specials",
			enable = true
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("skaven_slave") < 15 and count_event_breed("skaven_clan_rat") < 10 and count_event_breed("skaven_clan_rat_with_shield") < 8 and count_event_breed("skaven_storm_vermin_commander") < 3 and count_event_breed("skaven_storm_vermin_with_shield") < 3
			end
		}
	}

	---------------------
	--Fort Brachsenbr𣫥

	HordeCompositions.event_fort_pestilen = {
		{
			name = "mixed",
			weight = 5,
			breeds = {
				"skaven_slave",
				{
					17,
					19
				},
				"skaven_clan_rat",
				{
					23,
					25
				},
				"skaven_plague_monk",
				{
					8,
					9
				}
			}
		}
	}
	
	HordeCompositions.event_fort_savagery = {
		{
			name = "mixed",
			weight = 5,
			breeds = {
				"chaos_fanatic",
				{
					19,
					23
				},
				"chaos_marauder",
				{
					10,
					11
				},
				"chaos_berzerker",
				{
					6,
					7
				}
			}
		}
	}

	TerrorEventBlueprints.fort.fort_pacing_off = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = true
		}
	}

	TerrorEventBlueprints.fort.fort_terror_event_climb = {
		{
			"set_freeze_condition",
			max_active_enemies = 125
		},
		{
			"set_master_event_running",
			name = "fort_terror_event_climb"
		},
		{
			"event_horde",
			spawner_id = "terror_event_climb",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("skaven_slave") < 18 and count_event_breed("skaven_clan_rat") < 12 and count_event_breed("skaven_clan_rat_with_shield") < 10 and count_event_breed("skaven_storm_vermin_commander") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "fort_terror_event_climb_done"
		}
	}

	TerrorEventBlueprints.fort.fort_terror_event_inner_yard_skaven = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "fort_terror_event_inner_yard"
		},
		{
			"event_horde",
			spawner_id = "terror_event_inner_yard",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			spawner_id = "terror_event_inner_yard",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("skaven_slave") < 36 and count_event_breed("skaven_clan_rat") < 24 and count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_commander") < 12
			end
		},
		{
			"flow_event",
			flow_event_name = "fort_terror_event_inner_yard_done"
		}
	}
	
	TerrorEventBlueprints.fort.fort_terror_event_inner_yard_chaos = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "fort_terror_event_inner_yard"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "terror_event_inner_yard",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "terror_event_inner_yard",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"delay",
			duration = 7
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("chaos_fanatic") < 40 and count_event_breed("chaos_raider") < 12 and count_event_breed("chaos_marauder") < 30 and count_event_breed("chaos_marauder_with_shield") < 15
			end
		},
		{
			"flow_event",
			flow_event_name = "fort_terror_event_inner_yard_done"
		}
	}

	TerrorEventBlueprints.fort.fort_horde_gate = {
		{
			"set_master_event_running",
			name = "fort_horde_gate"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "fort_horde_gate",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "fort_horde_gate",
			composition_type = "onslaught_chaos_berzerkers_small"
		},
		{
			"event_horde",
			spawner_id = "fort_horde_gate",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			spawner_id = "fort_horde_gate",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "Fort_Big_SV",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				max_health_modifier = 2.5,
				size_variation_range = {
				    1.773,
				    1.774
				},
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_2",
			breed_name = "skaven_rat_ogre",
			optional_data = {
				enhancements = relentless
			}
		},
		{
			"delay",
			duration = 30
		},
		{
			"event_horde",
			spawner_id = "fort_horde_gate",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "fort_horde_gate",
			composition_type = "onslaught_chaos_berzerkers_small"
		},
		{
			"event_horde",
			spawner_id = "fort_horde_gate",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 50,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 16 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("skaven_storm_vermin") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "fort_horde_gate_done"
		}
	}

	-- TerrorEventBlueprints.fort.fort_horde_cannon = {
		-- {
			-- "set_master_event_running",
			-- name = "fort_horde_cannon"
		-- },
		-- {
			-- "set_freeze_condition",
			-- max_active_enemies = 100
		-- },
		-- {
			-- "control_pacing",
			-- enable = false
		-- },
		-- {
			-- "control_specials",
			-- enable = false
		-- },
		-- {
			-- "event_horde",
			-- spawner_id = "fort_horde_cannon",
			-- composition_type = "event_fort_pestilen"
		-- },
		-- {
			-- "delay",
			-- duration = 5
		-- },
		-- {
			-- "spawn_at_raw",
			-- spawner_id = "siege_1",
			-- breed_name = "skaven_warpfire_thrower"
		-- },
		-- {
			-- "spawn_at_raw",
			-- spawner_id = "siege_2",
			-- breed_name = "skaven_poison_wind_globadier"
		-- },
		-- {
			-- "delay",
			-- duration = {
				-- 5,
				-- 9
			-- }
		-- },
		-- {
			-- "spawn_at_raw",
			-- spawner_id = "siege_4",
			-- breed_name = "skaven_poison_wind_globadier"
		-- },
		-- {
			-- "spawn_at_raw",
			-- spawner_id = "siege_6",
			-- breed_name = "skaven_ratling_gunner"
		-- },
		-- {
			-- "continue_when",
			-- condition = function (t)
				-- return count_event_breed("skaven_slave") < 25 and count_event_breed("skaven_plague_monk") < 6 and count_event_breed("skaven_poison_wind_globadier") < 4 and count_event_breed("skaven_warpfire_thrower") < 4 and count_event_breed("skaven_ratling_gunner") < 4
			-- end
		-- },
		-- {
			-- "delay",
			-- duration = 7
		-- },
		-- {
			-- "flow_event",
			-- flow_event_name = "fort_horde_cannon_done"
		-- }
	-- }
	
	TerrorEventBlueprints.fort.fort_horde_cannon_skaven = {
		{
			"set_master_event_running",
			name = "fort_horde_cannon"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "fort_horde_cannon",
			composition_type = "event_fort_pestilen"
		},
		{
			"event_horde",
			spawner_id = "fort_horde_cannon",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "fort_horde_cannon",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual_special_spawners",
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
		},
		{
			"delay",
			duration = 8
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_1",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_2",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = {
				5,
				9
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_4",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_6",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "fort_horde_cannon",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 15
		},
		{
			"spawn_at_raw",
			spawner_id = "manual_special_spawners",
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
		},
		{
			"delay",
			duration = 30
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "fort_horde_cannon",
			composition_type = "event_fort_pestilen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 70,
			condition = function (t)
				return count_event_breed("skaven_slave") < 25 and (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 15 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("skaven_plague_monk") < 6 and count_event_breed("skaven_poison_wind_globadier") < 10 and count_event_breed("skaven_warpfire_thrower") < 6 and count_event_breed("skaven_ratling_gunner") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "fort_horde_cannon_done"
		}
	}
	
	TerrorEventBlueprints.fort.fort_horde_cannon_chaos = {
		{
			"set_master_event_running",
			name = "fort_horde_cannon"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "fort_horde_cannon",
			composition_type = "event_fort_savagery"
		},
		{
			"event_horde",
			spawner_id = "fort_horde_cannon",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			spawner_id = "fort_horde_cannon",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual_special_spawners",
			breed_name = {
				"chaos_corruptor_sorcerer",
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			}
		},
		{
			"delay",
			duration = 8
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_1",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_2",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = {
				5,
				9
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_4",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_6",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 8
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "fort_horde_cannon",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 20
		},
		{
			"spawn_at_raw",
			spawner_id = "manual_special_spawners",
			breed_name = {
				"chaos_corruptor_sorcerer",
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			}
		},
		{
			"delay",
			duration = 45
		},
		{
			"event_horde",
			spawner_id = "fort_horde_cannon",
			composition_type = "event_fort_savagery"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 70,
			condition = function (t)
				return count_event_breed("chaos_fanatic") < 15 and (count_event_breed("chaos_marauder") + count_event_breed("chaos_marauder_with_shield")) < 10 and count_event_breed("chaos_raider") < 6 and count_event_breed("chaos_berzerker") < 6 and count_event_breed("chaos_warrior") < 4 and count_event_breed("skaven_poison_wind_globadier") < 10 and count_event_breed("skaven_warpfire_thrower") < 6 and count_event_breed("chaos_vortex_sorcerer") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "fort_horde_cannon_done"
		}
	}

	TerrorEventBlueprints.fort.fort_siegers = {
		{
			"set_master_event_running",
			name = "fort_siegers"
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_1",
			breed_name = "skaven_stormfiend"
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_2",
			breed_name = "chaos_berzerker"
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_3",
			breed_name = "chaos_marauder"
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_4",
			breed_name = "chaos_marauder"
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_5",
			breed_name = "chaos_berzerker"
		},
		{
			"spawn_at_raw",
			spawner_id = "siege_6",
			breed_name = "chaos_marauder"
		},
		{
			"continue_when",
			duration = 180,
			condition = function (t)
				return count_event_breed("chaos_berzerker") < 2 and count_event_breed("chaos_raider") < 2 and count_event_breed("chaos_marauder") < 2 and count_event_breed("chaos_marauder_with_shield") < 2 and count_event_breed("skaven_stormfiend") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "siege_broken"
		}
	}

	---------------------
	--Into the Nest
	
	TerrorEventBlueprints.skaven_stronghold.stronghold_pacing_off = {
		{
			"text",
			text = "",
			duration = 0
		}
	}
	
	TerrorEventBlueprints.skaven_stronghold.stronghold_pacing_on = {
		{
			"text",
			text = "",
			duration = 0
		}
	}
	
	TerrorEventBlueprints.skaven_stronghold.stronghold_horde_water_wheels = {
		{
			"set_master_event_running",
			name = "stronghold_horde_water_wheels"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "stronghold_horde_water_wheels",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			spawner_id = "stronghold_horde_water_wheels",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			spawner_id = "stronghold_horde_water_wheels",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"event_horde",
			spawner_id = "stronghold_horde_water_wheels",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"event_horde",
			spawner_id = "stronghold_horde_water_wheels",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"event_horde",
			spawner_id = "stronghold_horde_water_wheels",
			composition_type = "onslaught_storm_vermin_white_medium"
		},	
		{
			"event_horde",
			spawner_id = "stronghold_horde_water_wheels",
			composition_type = "onslaught_storm_vermin_white_medium"
		},		
		{
			"event_horde",
			spawner_id = "stronghold_horde_water_wheels",
			composition_type = "onslaught_storm_vermin_white_medium"
		},		
		{
			"event_horde",
			spawner_id = "stronghold_horde_water_wheels",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "stronghold_horde_water_wheels",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"control_specials",
			enable = true
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("skaven_slave") < 12 and count_event_breed("skaven_clan_rat_with_shield") < 8 and count_event_breed("skaven_storm_vermin_with_shield") < 4 and count_event_breed("skaven_storm_vermin") < 8 and count_breed("skaven_storm_vermin_commander") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "stronghold_horde_water_wheels_done"
		}
	}
	
	TerrorEventBlueprints.skaven_stronghold.stronghold_boss = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"disable_kick"
		},
		{
			"set_master_event_running",
			name = "stronghold_boss"
		},
		{
			"spawn_at_raw",
			spawner_id = "stronghold_boss",
			breed_name = "skaven_storm_vermin_warlord",
			optional_data = { 
				max_health_modifier = 1.5,
				enhancements = enhancement_4
			}	
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("skaven_storm_vermin_warlord") == 1
			end
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("skaven_storm_vermin_warlord") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "stronghold_boss_killed"
		},
		{
			"delay",
			duration = 8
		},

		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	}
	
	HordeCompositions.stronghold_boss_event_defensive = {
		{
			name = "plain",
			weight = 6,
			breeds = {
				"skaven_slave",
				{
					5,
					7
				},
				"skaven_clan_rat",
				{
					20,
					22
				},
				"skaven_clan_rat_with_shield",
				{
					15,
					20
				},
				"skaven_plague_monk",
				{
					6,
					8
				},
				"skaven_storm_vermin_with_shield",
				4,
			}
		},
		{
			name = "somevermin",
			weight = 4,
			breeds = {
				"skaven_clan_rat",
				{
					10,
					12
				},
				"skaven_clan_rat_with_shield",
				{
					22,
					24
				},
				"skaven_plague_monk",
				{
					9,
					10
				},
				"skaven_storm_vermin_with_shield",
				4,
			}
		}
	}
	
	HordeCompositions.stronghold_boss_trickle = {
		{
			name = "plain",
			weight = 8,
			breeds = {
				"skaven_slave",
				{
					8,
					10
				},
				"skaven_clan_rat",
				{
					7,
					8
				},
				"skaven_clan_rat_with_shield",
				{
					5,
					6
				}
			}
		},
		{
			name = "plain",
			weight = 2,
			breeds = {
				"skaven_slave",
				{
					5,
					6
				},
				"skaven_clan_rat",
				{
					5,
					6
				},
				"skaven_clan_rat_with_shield",
				{
					4,
					5
				},
				"skaven_storm_vermin_commander",
				3
			}
		}
	}
	
	HordeCompositions.stronghold_boss_initial_wave = {
		{
			name = "plain",
			weight = 6,
			breeds = {
				"skaven_storm_vermin",
				14,
				"skaven_plague_monk",
				8,
				"skaven_clan_rat",
				{
					15,
					17
				}
			}
		}
	}
	
	BreedActions.skaven_storm_vermin_warlord.spawn_allies.difficulty_spawn_list = {
			easy = {
				"skaven_storm_vermin"
			},
			normal = {
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			hard = {
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			survival_hard = {
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			harder = {
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			survival_harder = {
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			hardest = {
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vzermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			},
			survival_hardest = {
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin",
				"skaven_storm_vermin"
			}
	}

	BreedActions.skaven_storm_vermin_warlord.spawn_sequence.considerations.time_since_last.max_value = 800
	
	--See hooks for boss behaviour changes.

	---------------------
	--Against the Grain
	
	TerrorEventBlueprints.farmlands.farmlands_rat_ogre = {
		{
			"set_master_event_running",
			name = "farmlands_boss_barn"
		},
		{
			"spawn_at_raw",
			spawner_id = "farmlands_rat_ogre",
			breed_name = "skaven_rat_ogre",
			optional_data = {
				enhancements = relentless
			}
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("skaven_rat_ogre") == 1
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_spawned"
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_farmlands_extra_boss",
			breed_name = {
				"skaven_rat_ogre",
				"beastmen_minotaur",
				"chaos_troll"
			},
			optional_data = {
				enhancements = enhancement_5
			}
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("skaven_rat_ogre") < 1 and count_event_breed("beastmen_minotaur") < 1 and count_event_breed("chaos_troll") < 1 and count_event_breed("chaos_spawn") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_dead"
		}
	}
	
	TerrorEventBlueprints.farmlands.farmlands_storm_fiend = {
		{
			"set_master_event_running",
			name = "farmlands_boss_barn"
		},
		{
			"spawn_at_raw",
			spawner_id = "farmlands_rat_ogre",
			breed_name = "skaven_rat_ogre",
			optional_data = {
				max_health_modifier = 0.7,
				enhancements = enhancement_5,
				spawned_func = degenerating_rat_ogre
			}
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("skaven_rat_ogre") == 1
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_spawned"
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_farmlands_extra_boss",
			breed_name = {
				"skaven_rat_ogre",
				"beastmen_minotaur",
				"chaos_troll"
			},
			optional_data = {
				max_health_modifier = 0.7,
				enhancements = relentless,
				spawned_func = degenerating_rat_ogre
			}
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("skaven_rat_ogre") < 1 and count_event_breed("beastmen_minotaur") < 1 and count_event_breed("chaos_troll") < 1 and count_event_breed("chaos_spawn") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_dead"
		}
	}
	
	TerrorEventBlueprints.farmlands.farmlands_chaos_troll = {
		{
			"set_master_event_running",
			name = "farmlands_boss_barn"
		},
		{
			"spawn_at_raw",
			spawner_id = "farmlands_rat_ogre",
			breed_name = "chaos_troll",
			optional_data = {
				max_health_modifier = 0.7,
				enhancements = enhancement_5,
				spawned_func = degenerating_rat_ogre
			}
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("chaos_troll") == 1
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_spawned"
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_farmlands_extra_boss",
			breed_name = {
				"skaven_rat_ogre",
				"beastmen_minotaur",
				"chaos_troll"
			},
			optional_data = {
				max_health_modifier = 0.7,
				enhancements = relentless,
				spawned_func = degenerating_rat_ogre
			}
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("skaven_rat_ogre") < 1 and count_event_breed("beastmen_minotaur") < 1 and count_event_breed("chaos_troll") < 1 and count_event_breed("chaos_spawn") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_dead"
		}
	}
	
	TerrorEventBlueprints.farmlands.farmlands_chaos_spawn = {
		{
			"set_master_event_running",
			name = "farmlands_boss_barn"
		},
		{
			"spawn_at_raw",
			spawner_id = "farmlands_rat_ogre",
			breed_name = "beastmen_minotaur",
			optional_data = {
				max_health_modifier = 0.7,
				enhancements = enhancement_5,
				spawned_func = degenerating_rat_ogre
			}
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("beastmen_minotaur") == 1
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_spawned"
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_farmlands_extra_boss",
			breed_name = {
				"skaven_rat_ogre",
				"beastmen_minotaur",
				"chaos_troll"
			},
			optional_data = {
				max_health_modifier = 0.7,
				enhancements = relentless,
				spawned_func = degenerating_rat_ogre
			}
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("skaven_rat_ogre") < 1 and count_event_breed("beastmen_minotaur") < 1 and count_event_breed("chaos_troll") < 1 and count_event_breed("chaos_spawn") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_dead"
		}
	}

	TerrorEventBlueprints.farmlands.farmlands_minotaur_spawn = {
		{
			"set_master_event_running",
			name = "farmlands_boss_barn"
		},
		{
			"spawn_at_raw",
			spawner_id = "farmlands_rat_ogre",
			breed_name = "beastmen_minotaur",
			optional_data = {
				max_health_modifier = 0.7,
				enhancements = enhancement_5,
				spawned_func = degenerating_rat_ogre
			}
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("beastmen_minotaur") == 1
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_spawned"
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_farmlands_extra_boss",
			breed_name = {
				"skaven_rat_ogre",
				"beastmen_minotaur",
				"chaos_troll"
			},
			optional_data = {
				max_health_modifier = 0.7,
				enhancements = relentless,
				spawned_func = degenerating_rat_ogre
			}
		},
		{
			"delay",
			duration = 1
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("skaven_rat_ogre") < 1 and count_event_breed("beastmen_minotaur") < 1 and count_event_breed("chaos_troll") < 1 and count_event_breed("chaos_spawn") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "farmlands_barn_boss_dead"
		}
	}

	TerrorEventBlueprints.farmlands.farmlands_spawn_guards = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = true
		},
		{
			"spawn_at_raw",
			spawner_id = "wall_guard_01",
			breed_name = "chaos_raider"
		},
		{
			"spawn_at_raw",
			spawner_id = "wall_guard_02",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "wall_guard_03",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_wall_guard_extra_1",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "windmill_guard",
			breed_name = "chaos_warrior"
		}
	}

	TerrorEventBlueprints.farmlands.farmlands_prisoner_event_01 = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"set_master_event_running",
			name = "farmlands_prisoner_event_01"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "square_front",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "square_front",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			spawner_id = "square_front",
			composition_type = "skaven_shields"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "Against_the_Grain_1st_event",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function,
				size_variation_range = {
				    1.4,
				    1.45
				}
			}
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			spawner_id = "hay_barn_bridge_invis",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			spawner_id = "hay_barn_bridge_invis",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "hay_barn_bridge_invis",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "hay_barn_bridge_invis",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "hay_barn_bridge_invis",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "hay_barn_bridge_invis",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_specials_heavy_disabler"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			spawner_id = "square_center",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "square_center",
			composition_type = "skaven_shields"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_maulers_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "Against_the_Grain_1st_event",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function,
				size_variation_range = {
				    1.2,
				    1.25
				}
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"event_horde",
			spawner_id = "hay_barn_back",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "hay_barn_back",
			composition_type = "skaven_shields"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_specials_heavy_disabler"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"event_horde",
			spawner_id = "hay_barn_bridge_invis",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			spawner_id = "hay_barn_bridge_invis",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "hay_barn_bridge_invis",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_specials_heavy_disabler"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
	}

	TerrorEventBlueprints.farmlands.farmlands_hay_barn_bridge_guards = {
		{
			"spawn_at_raw",
			spawner_id = "hay_barn_bridge_guards",
			breed_name = "chaos_warrior",
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_hay_barn_bridge_guards_extra_1",
			breed_name = "chaos_warrior"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_hay_barn_bridge_guards_extra_2",
			breed_name = "chaos_warrior",
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_hay_barn_bridge_guards_extra_3",
			breed_name = "chaos_berzerker"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_hay_barn_bridge_guards_extra_4",
			breed_name = "chaos_berzerker"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_hay_barn_bridge_guards_extra_5",
			breed_name = "chaos_berzerker"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"set_time_challenge",
			time_challenge_name = "farmlands_speed_event"
		}
	}

	TerrorEventBlueprints.farmlands.farmlands_prisoner_event_hay_barn = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"disable_kick"
		},
		{
			"continue_when",
			duration = 1,
			condition = function (t)
				return activate_darkness()
			end
		},
		{
			"set_master_event_running",
			name = "farmlands_prisoner_event_hay_barn"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"spawn_at_raw",
			spawner_id = "hay_barn_guards",
			breed_name = "chaos_raider"
		},
		{
			"spawn_at_raw",
			spawner_id = "hay_barn_manual_spawns",
			breed_name = "chaos_marauder"
		},
		{
			"event_horde",
			spawner_id = "hay_barn_cellar_invis",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 25
		},
		{
			"event_horde",
			spawner_id = "hay_barn_cellar_invis",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			spawner_id = "hay_barn_cellar_invis",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			spawner_id = "hay_barn_front_invis",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "hay_barn_front_invis",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			spawner_id = "hay_barn_interior",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_stormvermin_shielders"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_stormvermin_shielders"
		},		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_stormvermin_shielders"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_stormvermin_shielders"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
	}

	TerrorEventBlueprints.farmlands.farmlands_prisoner_event_upper_square = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"set_master_event_running",
			name = "farmlands_prisoner_event_upper_square"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "square_center",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "square_center",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			spawner_id = "square_center",
			composition_type = "skaven_shields"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard_invis",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			spawner_id = "sawmill_creek",
			composition_type = "event_small"
		},
		{
			"event_horde",
			spawner_id = "sawmill_creek",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			spawner_id = "sawmill_creek",
			composition_type = "skaven_shields"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "sawmill_creek",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"event_horde",
			spawner_id = "sawmill_creek",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"event_horde",
			spawner_id = "sawmill_creek",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
	}

	TerrorEventBlueprints.farmlands.farmlands_prisoner_event_sawmill_door = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"set_master_event_running",
			name = "farmlands_prisoner_event_sawmill_door"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior",
			composition_type = "onslaught_event_military_courtyard_plague_monks"
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior",
			composition_type = "onslaught_event_military_courtyard_plague_monks"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
	}

	TerrorEventBlueprints.farmlands.farmlands_prisoner_event_sawmill = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"set_master_event_running",
			name = "farmlands_prisoner_event_sawmill"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior_invis",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior_invis",
			composition_type = "event_maulers_medium"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior_invis",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior_invis",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior_invis",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "sawmill_interior_invis",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"event_horde",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 25
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "elven_ruins_toptier",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard",
			composition_type = "skaven_shields"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "skaven_shields"
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			composition_type = "skaven_shields"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 30 and count_event_breed("skaven_clan_rat_with_shield") < 30 and count_event_breed("skaven_slave") < 40
			end
		}
	}

	TerrorEventBlueprints.farmlands.farmlands_gate_open_event = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"has_completed_time_challenge",
			time_challenge_name = "farmlands_speed_event"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard",
			composition_type = "event_small"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			spawner_id = "sawmill_yard",
			composition_type = "onslaught_event_military_courtyard_plague_monks"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 5
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	}

	---------------------
	--Empire in Flames

	TerrorEventBlueprints.ussingen.ussingen_gate_guards = {
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "onslaught_gate_spawner_1",
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "onslaught_gate_spawner_2",
		},
		{
			"delay",
			duration = 0.8
		},
		{
			"spawn_at_raw",
			spawner_id = "gate_spawner_1",
			breed_name = "chaos_warrior",
		},
		{
			"spawn_at_raw",
			spawner_id = "gate_spawner_2",
			breed_name = "chaos_warrior",
		},
	}

	TerrorEventBlueprints.ussingen.ussingen_payload_event_01 = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = true
		},
		{
			"disable_kick"
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "ussingen_payload_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "ussingen_payload_square",
			composition_type = "event_large_chaos_dutch"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_troll_event_ussingen",
			breed_name = "chaos_troll",
			optional_data = {
				max_health_modifier = 0.7,
				enhancements = regenerating
			}
		},
		{
			"delay",
			duration = 20,
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "ussingen_payload_event_01_done"
		}
	}

	TerrorEventBlueprints.ussingen.ussingen_payload_event_loop_01 = {
		{
			"control_specials",
			enable = true
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "ussingen_payload_transit",
			composition_type = "event_large_chaos_dutch"
		},
		{
			"delay",
			duration = 12,
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "ussingen_payload_transit",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 4
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "ussingen_payload_event_loop_done"
		}
	}

	TerrorEventBlueprints.ussingen.ussingen_payload_event_loop_02 = {
		{
			"control_specials",
			enable = true
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "ussingen_payload_transit",
			composition_type = "event_large_chaos_dutch"
		},
		{
			"delay",
			duration = 12,
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "ussingen_payload_transit",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"delay",
			duration = 4
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "ussingen_payload_event_loop_done"
		}
	}

	TerrorEventBlueprints.ussingen.ussingen_payload_event_loop_03 = {
		{
			"control_specials",
			enable = true
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "ussingen_payload_transit",
			composition_type = "event_large_skaven_dutch"
		},
		{
			"delay",
			duration = 25,
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "ussingen_payload_transit",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 4
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"flow_event",
			flow_event_name = "ussingen_payload_event_loop_done"
		}
	}

	TerrorEventBlueprints.ussingen.ussingen_payload_event_loop_04 = {
		{
			"control_specials",
			enable = true
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "ussingen_payload_transit",
			composition_type = "event_large_skaven_dutch"
		},
		{
			"delay",
			duration = 25,
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "ussingen_payload_transit",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "ussingen_payload_transit",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "ussingen_payload_transit",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 4
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"flow_event",
			flow_event_name = "ussingen_payload_event_loop_done"
		}
	}

	TerrorEventBlueprints.ussingen.ussingen_gate_open_event = {
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "ussingen_gate_open",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_troll_event_ussingen",
			breed_name = "chaos_warrior",
			optional_data = {
				max_health_modifier = 3,
				spawned_func = nurgle_buff_spawn_function,
				size_variation_range = {
					1.4,
					1.45
				}
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	}

	---------------------
	--Festering Ground
	
	TerrorEventBlueprints.nurgle.nurgle_end_event01 = {
		{
			"set_master_event_running",
			name = "nurgle_end_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "event_large"
		},		
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "onslaught_custom_special_disabler"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "onslaught_custom_special_disabler"
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "nurgle_end_event",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_monk",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"flow_event",
			flow_event_name = "nurgle_end_event01_done"
		}
	}
	
	TerrorEventBlueprints.nurgle.nurgle_end_event_specials_01 = {
		{
			"set_master_event_running",
			name = "nurgle_end_event"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"delay",
			duration = 4
		},
		{
			"continue_when",
			duration = 7,
			condition = function (t)
				return count_event_breed("skaven_poison_wind_globadier") + count_event_breed("skaven_ratling_gunner") + count_event_breed("skaven_warpfire_thrower") + count_event_breed("skaven_pack_master") + count_event_breed("skaven_gutter_runner") + count_event_breed("chaos_corruptor_sorcerer") < 9
			end
		},
		{
			"flow_event",
			flow_event_name = "nurgle_end_event_specials_done"
		}
	}
	
	TerrorEventBlueprints.nurgle.nurgle_end_event_specials_02 = {
		{
			"set_master_event_running",
			name = "nurgle_end_event"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"delay",
			duration = 4
		},
		{
			"continue_when",
			duration = 7,
			condition = function (t)
				return count_event_breed("skaven_poison_wind_globadier") + count_event_breed("skaven_ratling_gunner") + count_event_breed("skaven_warpfire_thrower") + count_event_breed("skaven_pack_master") + count_event_breed("skaven_gutter_runner") + count_event_breed("chaos_corruptor_sorcerer") < 9
			end
		},
		{
			"flow_event",
			flow_event_name = "nurgle_end_event_specials_done"
		}
	}
	
	TerrorEventBlueprints.nurgle.nurgle_end_event_specials_03 = {
		{
			"set_master_event_running",
			name = "nurgle_end_event"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"delay",
			duration = 4
		},
		{
			"continue_when",
			duration = 7,
			condition = function (t)
				return count_event_breed("skaven_poison_wind_globadier") + count_event_breed("skaven_ratling_gunner") + count_event_breed("skaven_warpfire_thrower") + count_event_breed("skaven_pack_master") + count_event_breed("skaven_gutter_runner") + count_event_breed("chaos_corruptor_sorcerer") < 9
			end
		},
		{
			"flow_event",
			flow_event_name = "nurgle_end_event_specials_done"
		}
	}
	
	--01 2 Denial 1 random
	--02 1 Denial 1 disabler 1 random
	--03 1 Denial 2 random
	TerrorEventBlueprints.nurgle.nurgle_end_event_loop_01 = {
		{
			"set_master_event_running",
			name = "nurgle_end_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "nurgle_end_event_loop_done"
		}
	}
	
	TerrorEventBlueprints.nurgle.nurgle_end_event_loop_02 = {
		{
			"set_master_event_running",
			name = "nurgle_end_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"delay",
			duration = 8
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "event_chaos_extra_spice_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "Festering_loop_event_1",
			breed_name = "chaos_raider_tutorial",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function,
				size_variation_range = {
				    1.2,
				    1.25
				}
			}
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event",
			composition_type = "storm_vermin_medium"
		},
		{
			"delay",
			duration = 20
		},		
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "nurgle_end_event_loop_done"
		}
	}
	
	TerrorEventBlueprints.nurgle.nurgle_end_event_loop_03 = {
		{
			"set_master_event_running",
			name = "nurgle_end_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "Festering_loop_event_1",
			breed_name = "chaos_raider_tutorial",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function,
				size_variation_range = {
				    1.2,
				    1.25
				}
			}
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "nurgle_end_event_loop_done"
		}
	}
	
	TerrorEventBlueprints.nurgle.nurgle_end_event_loop_04 = {
		{
			"set_master_event_running",
			name = "nurgle_end_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 8
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "nurgle_end_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event",
			composition_type = "storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event",
			composition_type = "storm_vermin_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "nurgle_end_event_loop_done"
		}
	}
	
	TerrorEventBlueprints.nurgle.nurgle_end_event_loop_05 = {
		{
			"set_master_event_running",
			name = "nurgle_end_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event",
			composition_type = "storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event",
			composition_type = "storm_vermin_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "Festering_loop_event_2",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function,
				size_variation_range = {
				    1.2,
				    1.25
				}
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "nurgle_end_event",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "nurgle_end_event_loop_done"
		}
	}
	
	TerrorEventBlueprints.nurgle.nurgle_end_event_loop_06 = {
		{
			"set_master_event_running",
			name = "nurgle_end_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_monk",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_monk",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_monk",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stingers_plague_monk"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "nurgle_end_event_loop_done"
		}
	}
	
	TerrorEventBlueprints.nurgle.nurgle_end_event_escape = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_master_event_running",
			name = "nurgle_end_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event02",
			composition_type = "event_large"
		},
		{
			"spawn_at_raw",
			spawner_id = "Festering_escape_event",
			breed_name = "chaos_raider_tutorial",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function,
				size_variation_range = {
				    1.2,
				    1.25
				}
			}
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event02",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "nurgle_end_event_escape_done"
		}
	}
	
	TerrorEventBlueprints.nurgle.nurgle_end_event_escape_02 = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_master_event_running",
			name = "nurgle_end_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event02",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event02",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "nurgle_end_event02",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event02",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event02",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			spawner_id = "nurgle_end_event02",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 35,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"flow_event",
			flow_event_name = "nurgle_end_event_escape_02_done"
		}
	}
	

	---------------------
	--Warcamp

	HordeCompositions.event_warcamp_elites = {
		{
			name = "zerker",
			weight = 3,
			breeds = {
				"chaos_warrior",
				2,
				"chaos_berzerker",
				{
					4,
					5
				}
			}
		},
		{
			name = "mixed",
			weight = 2,
			breeds = {
				"chaos_warrior",
				2,
				"chaos_raider",
				{
					2,
					3
				},
				"chaos_berzerker",
				{
					2,
					3
				}
			}
		},
		{
			name = "mauler",
			weight = 5,
			breeds = {
				"chaos_warrior",
				2,
				"chaos_raider",
				{
					4,
					5
				}
			}
		},
	}

	TerrorEventBlueprints.warcamp.warcamp_payload = {
		{
			"set_master_event_running",
			name = "warcamp_payload"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_l",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_l",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_l",
			composition_type = "chaos_warriors"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_r",
			composition_type = "event_marauder_special"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_l",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("chaos_berzerker") < 10 and count_event_breed("chaos_raider") < 10 and count_event_breed("chaos_marauder") < 18 and count_event_breed("chaos_marauder_with_shield") < 18
			end
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "event_marauder_special"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_r",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_r",
			composition_type = "event_marauder_special"
		},
		{
			"delay",
			duration = 6
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_l",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "event_marauder_special"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_r",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_r",
			composition_type = "event_marauder_special"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("chaos_berzerker") < 10 and count_event_breed("chaos_raider") < 10 and count_event_breed("chaos_marauder") < 18 and count_event_breed("chaos_marauder_with_shield") < 18
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_l",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_r",
			composition_type = "event_maulers_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_l",
			composition_type = "event_maulers_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_r",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("chaos_berzerker") < 10 and count_event_breed("chaos_raider") < 10 and count_event_breed("chaos_marauder") < 18 and count_event_breed("chaos_marauder_with_shield") < 18
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_r",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "event_marauder_special"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_r",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_r",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_r",
			composition_type = "event_marauder_special"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_l",
			composition_type = "chaos_warriors"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("chaos_berzerker") < 10 and count_event_breed("chaos_raider") < 10 and count_event_breed("chaos_marauder") < 18 and count_event_breed("chaos_marauder_with_shield") < 18
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_r",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "event_marauder_special"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_r",
			composition_type = "event_maulers_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_r",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("chaos_berzerker") < 10 and count_event_breed("chaos_raider") < 10 and count_event_breed("chaos_marauder") < 18 and count_event_breed("chaos_marauder_with_shield") < 18
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_l",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "event_marauder_special"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_r",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "payload_event_r",
			composition_type = "event_maulers_medium"
		},
		{
			"continue_when",
			duration = 50,
			condition = function (t)
				return count_event_breed("chaos_berzerker") < 10 and count_event_breed("chaos_raider") < 10 and count_event_breed("chaos_marauder") < 18 and count_event_breed("chaos_marauder_with_shield") < 18
			end
		},
		{
			"flow_event",
			flow_event_name = "warcamp_payload"
		}
	}

	-- TerrorEventBlueprints.warcamp.warcamp_door_guard = {
		-- {
			-- "disable_kick"
		-- },
		-- {
			-- "spawn_at_raw",
			-- spawner_id = "wc_shield_dude_1",
			-- breed_name = "chaos_warrior"
		-- },
		-- {
			-- "spawn_at_raw",
			-- spawner_id = "wc_shield_dude_2",
			-- breed_name = "chaos_warrior"
		-- },
		-- {
			-- "spawn_at_raw",
			-- spawner_id = "wc_sword_dude_1",
			-- breed_name = "chaos_berzerker"
		-- },
		-- {
			-- "spawn_at_raw",
			-- spawner_id = "wc_sword_dude_2",
			-- breed_name = "chaos_berzerker"
		-- },
		-- {
			-- "spawn_at_raw",
			-- spawner_id = "wc_2h_dude_1",
			-- breed_name = "chaos_warrior"
		-- }
	-- }

	TerrorEventBlueprints.warcamp.warcamp_camp = {
		{
			"set_master_event_running",
			name = "warcamp_camp"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"control_specials",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "camp_event",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "event_marauder_special"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "payload_event_l",
			composition_type = "event_marauder_special"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "camp_event",
			composition_type = "event_warcamp_elites"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "camp_event",
			composition_type = "event_warcamp_elites"
		},
		{
			"delay",
			duration = 4
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("chaos_berzerker") < 10 and count_event_breed("chaos_raider") < 10 and (count_event_breed("chaos_marauder") + count_event_breed("chaos_marauder_with_shield") < 25) and count_event_breed("chaos_warrior") < 6
			end
		},
		{
			"delay",
			duration = 15
		},
		{
			"flow_event",
			flow_event_name = "warcamp_camp_restart"
		}
	}

	HordeCompositions.warcamp_boss_event_trickle = {
		{
			name = "plain",
			weight = 6,
			breeds = {
				"chaos_marauder",
				{
					6,
					8
				},
				"chaos_marauder_tutorial",
				{
					3,
					4
				},
				"chaos_berzerker",
				{
					3,
					4
				}
			}
		},
		{
			name = "somevermin",
			weight = 4,
			breeds = {
				"chaos_marauder",
				{
					6,
					8
				},
				"chaos_marauder_tutorial",
				{
					3,
					4
				},
				"chaos_raider",
				{
					2,
					3
				},
				"chaos_berzerker",
				{
					2,
					3
				}
			}
		}
	}

	HordeCompositions.warcamp_boss_event_defensive = {
		{
			name = "plain",
			weight = 6,
			breeds = {
				"chaos_marauder",
				{
					9,
					12
				},
				"chaos_marauder_with_shield",
				{
					10,
					12
				},
				"chaos_marauder_tutorial",
				{
					5,
					6
				},
				"chaos_raider",
				{
					5,
					6
				},
				"chaos_warrior",
				{
					2,
					3
				}
			}
		},
		{
			name = "horde",
			weight = 4,
			breeds = {
				"chaos_fanatic",
				{
					25,
					31
				},
				"chaos_marauder",
				{
					10,
					11
				},
				"chaos_marauder_tutorial",
				{
					5,
					6
				},
				"chaos_berzerker",
				{
					8,
					9
				}
			}
		},
		{
			name = "somevermin",
			weight = 2,
			breeds = {
				"chaos_warrior",
				{
					4,
					5
				},
				"chaos_marauder",
				{
					6,
					7
				},
				"chaos_marauder_tutorial",
				{
					6,
					7
				},
				"chaos_marauder_with_shield",
				{
					13,
					15
				}
			}
		}
	}
	
	TerrorEventBlueprints.warcamp.warcamp_chaos_boss = {
		{
			"set_master_event_running",
			name = "warcamp_chaos_boss"
		},
		{
			"spawn_at_raw",
			spawner_id = "warcamp_chaos_boss",
			breed_name = "chaos_exalted_champion_warcamp",
			optional_data = { 
				max_health_modifier = 1.5,
				enhancements = enhancement_4
			}
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("chaos_exalted_champion_warcamp") == 1
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "onslaught_camp_boss_top",
			composition_type = "chaos_warriors"
		},	
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "onslaught_camp_boss_top_behind",
			composition_type = "event_maulers_medium"
		},	
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "onslaught_camp_boss_top_left",
			composition_type = "event_small_chaos"
		},	
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "onslaught_camp_boss_top_right",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},	
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("chaos_exalted_champion_warcamp") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "warcamp_chaos_boss_dead"
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	}

	--See hooks for warcamp boss behaviour changes.
	
	---------------------
	--Skittergate
	TerrorEventBlueprints.skittergate.skittergate_pacing_off = {
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	}
	
	TerrorEventBlueprints.skittergate.skittergate_spawn_guards = {
		{
			"spawn_at_raw",
			spawner_id = "gate_guard_01",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "gate_guard_02",
			breed_name = "skaven_storm_vermin_commander"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_gate_guard",
			breed_name = "skaven_storm_vermin_commander"
		}
	}
	
	TerrorEventBlueprints.skittergate.skittergate_chaos_boss = {
		{
			"set_master_event_running",
			name = "skittergate_chaos_boss"
		},
		{
			"event_horde",
			spawner_id = "onslaught_CW_gatekeeper_1",
			composition_type = "onslaught_skittergate_warriors_one"
		},
		{
			"event_horde",
			spawner_id = "onslaught_CW_gatekeeper_3",
			composition_type = "onslaught_skittergate_warriors_three"
		},
		{
			"event_horde",
			spawner_id = "onslaught_CW_gatekeeper_2",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "onslaught_CW_gatekeeper_2",
			composition_type = "onslaught_skittergate_warriors_two"
		},
		{
			"event_horde",
			spawner_id = "onslaught_CW_gatekeeper_1",
			composition_type = "onslaught_skittergate_warriors_one"
		},
		{
			"event_horde",
			spawner_id = "onslaught_CW_gatekeeper_3",
			composition_type = "onslaught_skittergate_warriors_three"
		},		
		{
			"delay",
			duration = 15
		},
		{
			"spawn_at_raw",
			spawner_id = "skittergate_chaos_boss",
			breed_name = "chaos_exalted_champion_norsca"
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("chaos_exalted_champion_norsca") == 1
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("chaos_exalted_champion_norsca") < 1 or count_event_breed("chaos_warrior") < 6
			end
		},
		{
			"event_horde",
			spawner_id = "onslaught_zerker_gatekeeper",
			composition_type = "onslaught_skittergate_warriors_three"
		},
		{
			"event_horde",
			spawner_id = "onslaught_zerker_gatekeeper",
			composition_type = "onslaught_skittergate_zerker"
		},
		{
			"event_horde",
			spawner_id = "onslaught_zerker_gatekeeper",
			composition_type = "onslaught_skittergate_zerker"
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("chaos_exalted_champion_norsca") < 1
			end
		},
		{
			"delay",
			duration = 2
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("chaos_exalted_champion_norsca") < 1 and count_event_breed("chaos_spawn_exalted_champion_norsca") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "skittergate_chaos_boss_killed"
		}
	}
	
	HordeCompositions.onslaught_skittergate_warriors_one = {
		{
			name = "plain",
			weight = 6,
			breeds = {
				"chaos_warrior",
				1,
			}
		}
	}
	
	HordeCompositions.onslaught_skittergate_warriors_two = {
		{
			name = "plain",
			weight = 6,
			breeds = {
				"chaos_warrior",
				2,
			}
		}
	}
	
	HordeCompositions.onslaught_skittergate_warriors_three = {
		{
			name = "plain",
			weight = 6,
			breeds = {
				"chaos_warrior",
				3,
			}
		}
	}
	
	HordeCompositions.onslaught_skittergate_zerker = {
		{
			name = "plain",
			weight = 6,
			breeds = {
				"chaos_berzerker",
				{
					10,
					12
				},
				"chaos_marauder",
				{
					20,
					24
				},
				"chaos_raider",
				{
					3,
					4
				}
			}
		}
	}
	
	TerrorEventBlueprints.skittergate.skittergate_gatekeeper_marauders = {
		{
			"spawn_at_raw",
			spawner_id = "skittergate_gatekeeper_marauder_01",
			breed_name = "chaos_raider"
		},
		{
			"spawn_at_raw",
			spawner_id = "skittergate_gatekeeper_marauder_02",
			breed_name = "chaos_raider"
		},
		{
			"spawn_at_raw",
			spawner_id = "skittergate_gatekeeper_marauder_03",
			breed_name = "chaos_marauder_with_shield"
		}
	}
	
	TerrorEventBlueprints.skittergate.skittergate_terror_event_02 = {
		{
			"set_master_event_running",
			name = "skittergate_terror_event_02"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "terror_event_02",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "terror_event_02",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "terror_event_02",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"control_specials",
			enable = true
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 15 and count_event_breed("skaven_slave") < 20 and (count_event_breed("chaos_marauder") + count_event_breed("chaos_marauder_with_shield")) < 12
			end
		},
		{
			"flow_event",
			flow_event_name = "skittergate_terror_event_02_done"
		}
	}
	
	BreedActions.skaven_grey_seer.ground_combat.spawn_allies_cooldown = 18

	BreedActions.skaven_grey_seer.ground_combat.staggers_until_teleport = 1
	BreedActions.skaven_grey_seer.ground_combat.warp_lightning_spell_cooldown = {
			2,
			2,
			2,
			2
	}
	
	BreedActions.skaven_grey_seer.ground_combat.vermintide_spell_cooldown = {
			4,
			4,
			4,
			4
	}
	
	BreedActions.skaven_grey_seer.ground_combat.teleport_spell_cooldown = {
			1.5,
			1.5,
			1.5,
			1.5
	}
	
	HordeCompositions.skittergate_boss_event_defensive = {
		{
			name = "plain",
			weight = 6,
			breeds = {
				"skaven_storm_vermin",
				{
					14,
					16
				},
				"skaven_clan_rat",
				{
					10,
					12
				},
				"skaven_clan_rat_with_shield",
				{
					7,
					9
				},
				"skaven_storm_vermin_with_shield",
				{
					3,
					5
				}
			}
		},
		{
			name = "somevermin",
			weight = 3,
			breeds = {
				"skaven_slave",
				{
					25,
					30
				},
				"skaven_storm_vermin",
				{
					10,
					12
				},
				"skaven_storm_vermin_with_shield",
				{
					1,
					2
				},
				"skaven_plague_monk",
				{
					8,
					10
				}
				
			}
		},
		{
			name = "berzerkers",
			weight = 3,
			breeds = {
				"skaven_plague_monk",
				{
					16,
					18
				},
				"skaven_clan_rat_with_shield",
				{
					10,
					12
				},
				"skaven_storm_vermin_with_shield",
				1
			}
		},
		{
			name = "shield_vermins",
			weight = 8,
			breeds = {
				"skaven_storm_vermin_with_shield",
				{
					10,
					11
				},
				"skaven_clan_rat_with_shield",
				{
					10,
					12
				},
				"skaven_storm_vermin",
				6,
			}
		}
	}
	
	HordeCompositions.skittergate_grey_seer_trickle = {
		{
			name = "plain",
			weight = 6,
			breeds = {
				"skaven_slave",
				{
					16,
					20
				},
				"skaven_clan_rat",
				{
					9,
					10
				},
				"skaven_clan_rat_with_shield",
				{
					6,
					8
				},
				"skaven_storm_vermin_commander",
				{
					8,
					9
				},
				"skaven_plague_monk",
				{
					7,
					8
				},
				"skaven_storm_vermin_with_shield",
				1
			}
		}
	}
	
	--See hooks for boss logic.
	
	---------------------
	--The Pit
	
	TerrorEventBlueprints.dlc_bogenhafen_slum.dlc_bogenhafen_slum_pacing_off = {
		{
			"text",
			text = "",
			duration = 0
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_slum.dlc_bogenhafen_slum_event_pacing_off = {
		{
			"text",
			text = "",
			duration = 0
		}
	}
	
	HordeCompositions.chaos_elites = {
		{
			name = "zerker",
			weight = 1,
			breeds = {
				"chaos_berzerker",
				{
					3,
					4
				}
			}
		},
		{
			name = "mauler",
			weight = 1,
			breeds = {
				"chaos_raider",
				{
					3,
					4
				}
			}
		}
	}
	
	HordeCompositions.slum_cw = {
		{
			name = "chaos_warrior",
			weight = 2,
			breeds = {
				"chaos_warrior",
					2
			}
		}
	}
	
	HordeCompositions.slum_specials = {
		{
			name = "leech",
			weight = 2,
			breeds = {
				"chaos_corruptor_sorcerer",
				3,
			}
		},
		{
			name = "warpfire",
			weight = 2,
			breeds = {
				"skaven_warpfire_thrower",
				3,
			}
		},
		{
			name = "mixed",
			weight = 3,
			breeds = {
				"chaos_corruptor_sorcerer",
				2,
				"skaven_warpfire_thrower",
				1,
			}
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_slum.dlc_bogenhafen_slum_event_start = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_slum_event_start"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"control_specials",
			enable = false
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_front_mid_01",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_front_mid_01",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_front_mid_01",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_front_left_01",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_front_right_01",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_front_right_01",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_front_right_01",
			composition_type = "slum_cw"
		},
		{
			"delay",
			duration = 15
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_slum_boss_event",
			breed_name = "chaos_troll",
			optional_data = {
				enhancements = regenerating
			}
		},
		{
			"delay",
			duration = 12
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_slum_event_start_done"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_slum.dlc_bogenhafen_slum_event_loop = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_front_left_01",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_front_left_01",
			composition_type = "chaos_elites"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_front_mid_01",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_front_right_01",
			composition_type = "slum_cw"
		},
		{
			"delay",
			duration = 48
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_slum_event_loop_done"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_slum.dlc_bogenhafen_slum_event_spice_mid = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_front_mid_01",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_front_mid_01",
			composition_type = "slum_specials"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_front_mid_01",
			composition_type = "onslaught_custom_special_disabler"
		},
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_slum.dlc_bogenhafen_slum_event_spice_left = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_left_01",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_left_01",
			composition_type = "onslaught_event_small_fanatics"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_left_01",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_left_01",
			composition_type = "event_maulers_medium"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_slum.dlc_bogenhafen_slum_event_spice_right = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_left_01",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_left_01",
			composition_type = "onslaught_event_small_fanatics"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_left_01",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_left_01",
			composition_type = "event_maulers_medium"
		},
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_slum.dlc_bogenhafen_slum_event_end_loop = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_roof_01",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_roof_01",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_roof_01",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_roof_01",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_event_roof_01",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return (count_event_breed("chaos_marauder_with_shield") + count_event_breed("chaos_marauder")) < 14
			end
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 20 and count_event_breed("skaven_slave") < 12 and count_event_breed("skaven_storm_vermin_commander") < 5
			end
		},
		{
			"delay",
			duration = 6
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_slum_event_end_loop"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_slum.dlc_bogenhafen_slum_gauntlet_part_01 = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_slum_gauntlet_master"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"control_specials",
			enable = false
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			spawner_id = "dlc_bogenhafen_slum_gauntlet_part_01",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "onslaught_slum_gauntlet_cutoff",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			spawner_id = "dlc_bogenhafen_slum_gauntlet_part_01",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "onslaught_slum_gauntlet_cutoff",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"spawn_special",
			spawner_id = "dlc_bogenhafen_slum_gauntlet_part_01",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 2
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_special",
			spawner_id = "dlc_bogenhafen_slum_gauntlet_part_01",
			breed_name = "skaven_pack_master"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_pack_master"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = "skaven_pack_master"
		},
		{
			"event_horde",
			spawner_id = "onslaught_slum_gauntlet_behind",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "onslaught_slum_gauntlet_behind",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "onslaught_slum_gauntlet_behind",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_special",
			spawner_id = "dlc_bogenhafen_slum_gauntlet_part_01",
			breed_name = "skaven_pack_master"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_slum.dlc_bogenhafen_slum_gauntlet_wall = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_slum_gauntlet_master"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_gauntlet_wall_01",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_gauntlet_wall_01",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_gauntlet_wall_01",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_gauntlet_wall_01",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_gauntlet_wall",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "bogenhafen_slum_gauntlet_wall",
			composition_type = "onslaught_chaos_warriors"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_slum.dlc_bogenhafen_slum_gauntlet_part_02 = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_slum_gauntlet_master"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "dlc_bogenhafen_slum_gauntlet_part_02",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "dlc_bogenhafen_slum_gauntlet_part_02",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			spawner_id = "dlc_bogenhafen_slum_gauntlet_part_02",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "dlc_bogenhafen_slum_gauntlet_part_02",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"spawn_special",
			spawner_id = "dlc_bogenhafen_slum_gauntlet_part_02",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 30
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("chaos_berzerker") < 3 and (count_event_breed("chaos_marauder_with_shield") + count_event_breed("chaos_marauder")) < 9 and count_event_breed("chaos_warrior") < 2 and (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 10 and count_event_breed("skaven_slave") < 14 and count_event_breed("skaven_storm_vermin_commander") < 4
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_slum_gauntlet_part_02_done"
		}
	}
	
	---------------------
	--Blightreaper
	
	TerrorEventBlueprints.dlc_bogenhafen_city.dlc_bogenhafen_city_disable_pacing = {
		{
			"text",
			text = "",
			duration = 0
		}
	}

	TerrorEventBlueprints.dlc_bogenhafen_city.dlc_bogenhafen_city_sewer_start = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_city_sewer_start"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{	
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			spawner_id = "sewer_start",
			composition_type = "event_medium"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stingers_plague_monk"
		},
		{
			"event_horde",
			spawner_id = "sewer_start",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "sewer_start",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "sewer_start",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "sewer_start",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "onslaught_sewer_backspawn",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "onslaught_sewer_backspawn",
			composition_type = "onslaught_event_small_fanatics"
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 12 and count_event_breed("skaven_slave") < 18
			end
		},
		{
			"delay",
			duration = 20
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_city_sewer_start_done"
		}
	}

	TerrorEventBlueprints.dlc_bogenhafen_city.dlc_bogenhafen_city_sewer_spice = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "sewer_spice",
			composition_type = "event_extra_spice_unshielded"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "sewer_spice",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "sewer_spice",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "sewer_spice",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 12 and count_event_breed("skaven_slave") < 18
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_city_sewer_spice_done"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_city.dlc_bogenhafen_city_sewer_mid01 = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_city_sewer_mid01"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "sewer_mid",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "onslaught_sewer_backspawn",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			spawner_id = "onslaught_sewer_backspawn",
			composition_type = "event_large_chaos"
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 16 and count_event_breed("skaven_slave") < 25
			end
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "sewer_rawspawner01",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "sewer_mid",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "sewer_mid",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "sewer_mid",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "sewer_mid",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stingers_plague_monk"
		},
		{
			"event_horde",
			spawner_id = "onslaught_sewer_backspawn",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "sewer_mid",
			composition_type = "event_small"
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return count_event_breed("skaven_plague_monk") < 8 and count_event_breed("skaven_clan_rat") < 12 and count_event_breed("skaven_storm_vermin_commander") < 5 and count_event_breed("skaven_slave") < 15
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_city_sewer_mid01_done"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_city.dlc_bogenhafen_city_sewer_end = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_city_sewer_end"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "onslaught_sewer_backspawn",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "sewer_end_chaos",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 20 and count_event_breed("chaos_marauder_with_shield") < 20
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "sewer_end_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "sewer_mid",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"control_specials",
			enable = true
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_city_sewer_end_done"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_city.dlc_bogenhafen_city_sewer_escape = {
		{
			"set_master_event_running",
			name = "bogenhafenhafen_sewer_escape"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "sewer_escape",
			composition_type = "event_medium_chaos"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_sewer_exit_gun_1",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_sewer_exit_gun_2",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 8 and count_event_breed("chaos_marauder_with_shield") < 8
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_city_sewer_escape_done"
		}
	}
	
	HordeCompositions.onslaught_blightreaper_temple_easy = {
		{
			name = "skaven_offensive",
			weight = 1,
			breeds = {
				"skaven_storm_vermin_commander",
				{
					4,
					5
				},
				"skaven_plague_monk",
				{
					4,
					5
				}
			}
		},
		{
			name = "skaven_mixed",
			weight = 1,
			breeds = {
				"skaven_storm_vermin_with_shield",
				5,
				"skaven_plague_monk",
				{
					5,
					5
				}
			}
		},
		{
			name = "skaven_defensive",
			weight = 1,
			breeds = {
				"skaven_storm_vermin_with_shield",
				5,
				"skaven_storm_vermin_commander",
				{
					4,
					5
				}
			}
		},
		{
			name = "chaos_mixed",
			weight = 1,
			breeds = {
				"chaos_berzerker",
				{
					6,
					7
				},
				"chaos_marauder_with_shield",
				16,
			}
		},
		{
			name = "chaos_offensive",
			weight = 1,
			breeds = {
				"chaos_warrior",
				3,
				"chaos_raider",
				{
					5,
					6
				},
			}
		},
		{
			name = "chaos_zerg",
			weight = 1,
			breeds = {
				"chaos_warrior",
				3,
				"chaos_berzerker",
				{
					5,
					6
				},
			}
		},
		{
			name = "chaos_defensive",
			weight = 1,
			breeds = {
				"chaos_raider",
				{
					6,
					7
				},
				"chaos_marauder_with_shield",
				16,
			}
		},
		{
			name = "chaos_leader",
			weight = 1,
			breeds = {
				"chaos_warrior",
				2,
				"chaos_raider",
				{
					3,
					4
				},
				"chaos_marauder_with_shield",
				{
					8,
					10
				},
				"chaos_berzerker",
				{
					3,
					4
				}
			}
		}
	}
	
	HordeCompositions.onslaught_blightreaper_temple_hard = {
		{
			name = "chaos_defensive",
			weight = 1,
			breeds = {
				"chaos_warrior",
				6,
				"chaos_marauder_with_shield",
				{
					10,
					12
				}
			}
		},
		{
			name = "chaos_offensive",
			weight = 1,
			breeds = {
				"chaos_warrior",
				4,
				"chaos_raider",
				{
					5,
					6
				}
			}
		},
		{
			name = "chaos_zerg",
			weight = 1,
			breeds = {
				"chaos_warrior",
				4,
				"chaos_berzerker",
				{
					6,
					7
				}
			}
		},
		{
			name = "chaos_leader",
			weight = 1,
			breeds = {
				"chaos_warrior",
				2,
				"chaos_marauder_with_shield",
				{
					8,
					10
				},
				"chaos_raider",
				{
					4,
					6
				},
				"chaos_berzerker",
				{
					4,
					6
				}
			}
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_city.dlc_bogenhafen_city_temple_loop = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_city_temple_loop"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_loop",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button5",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 30
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 15 and count_event_breed("skaven_slave") < 32 and count_event_breed("skaven_storm_vermin_commander") < 5 and count_event_breed("skaven_plague_monk") < 5 and count_event_breed("chaos_fanatic") < 24 and count_event_breed("chaos_marauder") < 16 and count_event_breed("chaos_warrior") < 3 and count_event_breed("chaos_raider") < 6 and count_event_breed("chaos_berzerker") < 6 and count_event_breed("skaven_gutter_runner") < 4 and count_event_breed("skaven_pack_master") < 4 and (count_event_breed("skaven_poison_wind_globadier") + count_event_breed("skaven_warpfire_thrower") + count_event_breed("skaven_ratling_gunner")) < 7
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button5",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button5",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 30
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 15 and count_event_breed("skaven_slave") < 32 and count_event_breed("skaven_storm_vermin_commander") < 5 and count_event_breed("skaven_plague_monk") < 5 and count_event_breed("chaos_fanatic") < 24 and count_event_breed("chaos_marauder") < 16 and count_event_breed("chaos_warrior") < 3 and count_event_breed("chaos_raider") < 6 and count_event_breed("chaos_berzerker") < 6 and count_event_breed("skaven_gutter_runner") < 4 and count_event_breed("skaven_pack_master") < 4 and (count_event_breed("skaven_poison_wind_globadier") + count_event_breed("skaven_warpfire_thrower") + count_event_breed("skaven_ratling_gunner")) < 7
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button5",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button2",
			composition_type = "storm_vermin_medium"
		},
		{
			"delay",
			duration = 30
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 15 and count_event_breed("skaven_slave") < 32 and count_event_breed("skaven_storm_vermin_commander") < 5 and count_event_breed("skaven_plague_monk") < 5 and count_event_breed("chaos_fanatic") < 24 and count_event_breed("chaos_marauder") < 16 and count_event_breed("chaos_warrior") < 3 and count_event_breed("chaos_raider") < 6 and count_event_breed("chaos_berzerker") < 6 and count_event_breed("skaven_gutter_runner") < 4 and count_event_breed("skaven_pack_master") < 4 and (count_event_breed("skaven_poison_wind_globadier") + count_event_breed("skaven_warpfire_thrower") + count_event_breed("skaven_ratling_gunner")) < 7
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button2",
			composition_type = "plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_loop",
			composition_type = "event_medium_shield"
		},
		{
			"delay",
			duration = 30
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 15 and count_event_breed("skaven_slave") < 32 and count_event_breed("skaven_storm_vermin_commander") < 5 and count_event_breed("skaven_plague_monk") < 5 and count_event_breed("chaos_fanatic") < 24 and count_event_breed("chaos_marauder") < 16 and count_event_breed("chaos_warrior") < 3 and count_event_breed("chaos_raider") < 6 and count_event_breed("chaos_berzerker") < 6 and count_event_breed("skaven_gutter_runner") < 4 and count_event_breed("skaven_pack_master") < 4 and (count_event_breed("skaven_poison_wind_globadier") + count_event_breed("skaven_warpfire_thrower") + count_event_breed("skaven_ratling_gunner")) < 7
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_city_temple_loop_done"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_city.dlc_bogenhafen_city_temple_start = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_city_end_start"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"disable_kick"
		},
		{
			"control_specials",
			enable = true
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_start",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button2",
			composition_type = "onslaught_blightreaper_temple_easy"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			spawner_id = "temple_event_button2",
			composition_type = "onslaught_custom_special_disabler"
		},
		{
			"event_horde",
			spawner_id = "temple_event_button2",
			composition_type = "onslaught_custom_special_disabler"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 20 and count_event_breed("skaven_storm_vermin_commander") < 10 and count_event_breed("skaven_slave") < 35 and count_event_breed("skaven_storm_vermin_with_shield") < 8 and count_event_breed("skaven_plague_monk") < 10 and count_event_breed("chaos_marauder") < 26 and count_event_breed("chaos_marauder_with_shield") < 20 and count_event_breed("chaos_raider") < 10 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 4
			end
		},
		{
			"event_horde",
			spawner_id = "temple_event_start",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button2",
			composition_type = "onslaught_blightreaper_temple_easy"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 20 and count_event_breed("skaven_storm_vermin_commander") < 10 and count_event_breed("skaven_slave") < 35 and count_event_breed("skaven_storm_vermin_with_shield") < 8 and count_event_breed("skaven_plague_monk") < 10 and count_event_breed("chaos_marauder") < 26 and count_event_breed("chaos_marauder_with_shield") < 20 and count_event_breed("chaos_raider") < 10 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_city_temple_start_done"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_city.dlc_bogenhafen_city_temple_button1 = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_city_temple_button1"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "temple_event_button1",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "temple_event_button2",
			composition_type = "onslaught_blightreaper_temple_easy"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "temple_event_button2",
			composition_type = "onslaught_custom_specials_heavy_disabler"
		},
		{
			"delay",
			duration = 30
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 20 and count_event_breed("skaven_storm_vermin_commander") < 10 and count_event_breed("skaven_slave") < 35 and count_event_breed("skaven_storm_vermin_with_shield") < 8 and count_event_breed("skaven_plague_monk") < 10 and count_event_breed("chaos_marauder") < 26 and count_event_breed("chaos_marauder_with_shield") < 20 and count_event_breed("chaos_raider") < 10 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 4
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button2",
			composition_type = "event_extra_spice_unshielded"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_rawspawner01",
			breed_name = "skaven_rat_ogre",
			optional_data = {
				max_health_modifier = 0.6,
			    enhancements = enhancement_5
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 20 and count_event_breed("skaven_storm_vermin_commander") < 10 and count_event_breed("skaven_slave") < 35 and count_event_breed("skaven_storm_vermin_with_shield") < 8 and count_event_breed("skaven_plague_monk") < 10 and count_event_breed("chaos_marauder") < 26 and count_event_breed("chaos_marauder_with_shield") < 20 and count_event_breed("chaos_raider") < 10 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_city_temple_button1_done"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_city.dlc_bogenhafen_city_temple_button2 = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_city_temple_button2"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button2",
			composition_type = "event_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_rawspawner01",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_rawspawner02",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"event_horde",
			spawner_id = "temple_event_button2",
			composition_type = "onslaught_blightreaper_temple_easy"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 20 and count_event_breed("skaven_storm_vermin_commander") < 10 and count_event_breed("skaven_slave") < 35 and count_event_breed("skaven_storm_vermin_with_shield") < 8 and count_event_breed("skaven_plague_monk") < 10 and count_event_breed("chaos_marauder") < 26 and count_event_breed("chaos_marauder_with_shield") < 20 and count_event_breed("chaos_raider") < 10 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 4
			end
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button2",
			composition_type = "event_extra_spice_unshielded"
		},
		{
			"event_horde",
			spawner_id = "temple_event_button4",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			spawner_id = "temple_event_button4",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			spawner_id = "temple_event_button4",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_window1",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_hidden",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_front4",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 20 and count_event_breed("skaven_storm_vermin_commander") < 10 and count_event_breed("skaven_storm_vermin") < 8 and count_event_breed("skaven_slave") < 35 and count_event_breed("skaven_storm_vermin_with_shield") < 8 and count_event_breed("skaven_plague_monk") < 10 and count_event_breed("chaos_marauder") < 26 and count_event_breed("chaos_marauder_with_shield") < 20 and count_event_breed("chaos_raider") < 10 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_city_temple_button2_done"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_city.dlc_bogenhafen_city_temple_button3 = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_city_temple_button3"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stingers_plague_monk"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button3",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "temple_event_button3",
			composition_type = "onslaught_blightreaper_temple_easy"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button3",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_window1",
			breed_name = "skaven_plague_monk",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_hidden",
			breed_name = "skaven_plague_monk",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_front4",
			breed_name = "skaven_plague_monk",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 20 and count_event_breed("skaven_storm_vermin_commander") < 10 and count_event_breed("skaven_slave") < 35 and count_event_breed("skaven_storm_vermin_with_shield") < 8 and count_event_breed("skaven_plague_monk") < 10 and count_event_breed("chaos_marauder") < 26 and count_event_breed("chaos_marauder_with_shield") < 20 and count_event_breed("chaos_raider") < 10 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 4
			end
		},
		{
			"event_horde",
			spawner_id = "temple_event_button2",
			composition_type = "onslaught_blightreaper_temple_easy"
		},
		{
			"spawn_special",
			amount = 3,
			spawner_id = "temple_event_button3",
			breed_name = "chaos_corruptor_sorcerer"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_window1",
			breed_name = "skaven_plague_monk",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_hidden",
			breed_name = "skaven_plague_monk",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_front4",
			breed_name = "skaven_plague_monk",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button3",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 20 and count_event_breed("skaven_storm_vermin_commander") < 10 and count_event_breed("skaven_slave") < 35 and count_event_breed("skaven_storm_vermin_with_shield") < 8 and count_event_breed("skaven_plague_monk") < 10 and count_event_breed("chaos_marauder") < 26 and count_event_breed("chaos_marauder_with_shield") < 20 and count_event_breed("chaos_raider") < 10 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_city_temple_button3_done"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_city.dlc_bogenhafen_city_temple_button4 = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_city_temple_button4"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button4",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button4",
			composition_type = "onslaught_blightreaper_temple_hard"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_window2",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_hidden",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_front2",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 24 and count_event_breed("chaos_marauder_with_shield") < 15 and count_event_breed("chaos_raider") < 8 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 6
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button4",
			composition_type = "onslaught_blightreaper_temple_hard"
		},
		{
			"delay",
			duration = 5
		},
				{
			"spawn_at_raw",
			spawner_id = "onslaught_button_window2",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_hidden",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_front2",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function
			}
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 24 and count_event_breed("chaos_marauder_with_shield") < 15 and count_event_breed("chaos_raider") < 8 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_city_temple_button4_done"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_city.dlc_bogenhafen_city_temple_button5 = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_city_temple_button5"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_rawspawner01",
			breed_name = "chaos_spawn",
			optional_data = {
				max_health_modifier = 0.75,
				enhancements = enhancement_5
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_button_hidden",
			breed_name = "chaos_spawn",
			optional_data = {
				max_health_modifier = 0.75,
				enhancements = regenerating
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button5",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button5",
			composition_type = "onslaught_blightreaper_temple_hard"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "temple_event_button2",
			composition_type = "onslaught_custom_specials_heavy_denial"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 24 and count_event_breed("chaos_marauder_with_shield") < 15 and count_event_breed("chaos_raider") < 8 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_city_temple_button5_done"
		}
	}
	
	TerrorEventBlueprints.dlc_bogenhafen_city.dlc_bogenhafen_city_temple_escape = {
		{
			"set_master_event_running",
			name = "dlc_bogenhafen_city_temple_escape"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "temple_event_escape",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "temple_event_escape",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 24 and count_event_breed("chaos_marauder_with_shield") < 15 and count_event_breed("chaos_raider") < 8 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 6
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "temple_event_escape",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "temple_event_escape",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 24 and count_event_breed("chaos_marauder_with_shield") < 15 and count_event_breed("chaos_raider") < 8 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 6
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "temple_event_escape",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "temple_event_escape",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 24 and count_event_breed("chaos_marauder_with_shield") < 15 and count_event_breed("chaos_raider") < 8 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 6
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "temple_event_escape",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "temple_event_escape",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 24 and count_event_breed("chaos_marauder_with_shield") < 15 and count_event_breed("chaos_raider") < 8 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 6
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "temple_event_escape",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "temple_event_escape",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 24 and count_event_breed("chaos_marauder_with_shield") < 15 and count_event_breed("chaos_raider") < 8 and count_event_breed("chaos_berzerker") < 8 and count_event_breed("chaos_warrior") < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_bogenhafen_city_temple_button5_done"
		}
	}

	-------------------
	--Horn of Magnus

	HordeCompositions.onslaught_gutter_assistants = {
		{
			name = "monk",
			weight = 5,
			breeds = {
				"skaven_plague_monk",
				1
			}
		},
		{
			name = "shield",
			weight = 5,
			breeds = {
				"skaven_storm_vermin_with_shield",
				1
			}
		},
		{
			name = "pack",
			weight = 5,
			breeds = {
				"skaven_pack_master",
				1
			}
		},
		{
			name = "warpfire",
			weight = 2,
			breeds = {
				"skaven_warpfire_thrower",
				1
			}
		}
	}

	TerrorEventBlueprints.magnus.magnus_gutter_runner_treasure = {
		{
			"spawn_special",
			breed_name = "skaven_gutter_runner",
			amount = {
				2,
				3
			}
		},
		{
			"play_stinger",
			stinger_name = "enemy_gutterrunner_stinger"
		},
		{
			"event_horde",
			composition_type = "onslaught_gutter_assistants"
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "gutter_runner_treasure_restart"
		}
	}

	TerrorEventBlueprints.magnus.magnus_door_event_guards = {
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "magnus_door_event_guards_01",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
	}

	TerrorEventBlueprints.magnus.magnus_door_a = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = true
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "event_large"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "magnus_door_event_guards_03",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_specials",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_specials",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 5,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 12
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_maulers_small"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function,
				max_health_modifier = 1.5,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "event_small"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_specials",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_specials",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"delay",
			duration = 14
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_small"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 14
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 13
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_small"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_extra_spice_small"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_small"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_small"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_extra_spice_small"
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	}

	TerrorEventBlueprints.magnus.magnus_door_b = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = true
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_b",
			composition_type = "event_medium"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_specials",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "magnus_door_event_guards_03",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 5,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "event_small"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "onslaught_storm_vermin_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_specials",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_maulers_medium"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_maulers_small"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "event_small"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_maulers_medium"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_c",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_small"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn",
			{
				1,
				2
			},
			spawner_id = "magnus_door_event_specials",
			breed_name = "chaos_warrior"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "event_small"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "event_extra_spice_small"
		},
		{
			"event_horde",
			spawner_id = "magnus_door_event_a",
			composition_type = "onslaught_storm_vermin_small"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"continue_when",
			duration = 12,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	}

	TerrorEventBlueprints.magnus.magnus_end_event = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = true
		},
		{
			"set_master_event_running",
			name = "magnus_end_event"
		},
		{
			"flow_event",
			flow_event_name = "magnus_horn_crescendo_starting"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn_first",
			composition_type = "event_large"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 18 and count_event_breed("skaven_slave") < 25 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("skaven_plague_monk") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "magnus_end_event_first_wave_killed"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_extra_spice_large"
		},
		{
			"disable_kick"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 18 and count_event_breed("skaven_slave") < 25 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("skaven_plague_monk") < 5
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "magnus_tower_chaos",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "magnus_tower_chaos",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_chaos",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_chaos",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "magnus_tower_chaos",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return (count_event_breed("chaos_marauder") + count_event_breed("chaos_marauder_with_shield")) < 10 and count_event_breed("chaos_fanatic") < 18 and count_event_breed("chaos_raider") < 6 and count_event_breed("chaos_berzerker") < 6 and count_event_breed("chaos_warrior") < 3
			end
		},
		{
			"delay",
			duration = 4
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 18 and count_event_breed("skaven_slave") < 25 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("skaven_plague_monk") < 5
			end
		},
		{
			"control_specials",
			enable = true
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 18 and count_event_breed("skaven_slave") < 25 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("skaven_plague_monk") < 5
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "magnus_tower_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "magnus_tower_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "magnus_tower_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 1
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "magnus_tower_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return (count_event_breed("chaos_marauder") + count_event_breed("chaos_marauder_with_shield")) < 10 and count_event_breed("chaos_fanatic") < 18 and count_event_breed("chaos_raider") < 6 and count_event_breed("chaos_berzerker") < 6 and count_event_breed("chaos_warrior") < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_magnus_boss_end",
			breed_name = "skaven_rat_ogre",
			optional_data = {
				enhancements = relentless
			}
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 18 and count_event_breed("skaven_slave") < 25 and count_event_breed("skaven_storm_vermin_commander") < 6 and count_event_breed("skaven_plague_monk") < 5
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "magnus_tower_horn",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_small"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "magnus_tower_horn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 3 and count_event_breed("skaven_slave") < 5 and count_event_breed("skaven_storm_vermin_commander") < 1 and count_event_breed("skaven_plague_monk") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "magnus_horn_event_done"
		},
		{
			"delay",
			duration = 5
		},
		{
			"control_pacing",
			enable = true
		}
	}
	
	---------------------
	--Garden of Morr
	
	TerrorEventBlueprints.cemetery.cemetery_plague_brew_event_1_a = {
		{
			"disable_kick"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"control_pacing",
			enable = false,
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_large"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_entrance",
			breed_name = "skaven_plague_monk",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin_commander",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_medium",
		},
		{
			"delay",
			duration = {
				8,
				10
			}
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_pack_master",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 3,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 20,
			max_distance = 25,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_entrance",
			breed_name = "skaven_plague_monk",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_storm_vermin_shields_small",
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_storm_vermin_shields_small",
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_plague_monks_medium",
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_plague_monks_medium",
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_ratling_gunner",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 3,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 20,
			max_distance = 25,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"spawn_at_raw",
			spawner_id = "cemetery_brew_event_specials",
			breed_name = "skaven_plague_monk",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
	}
	
	TerrorEventBlueprints.cemetery.cemetery_plague_brew_event_1_b = {
		{
			"disable_kick"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"control_pacing",
			enable = false,
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_large"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_entrance",
			breed_name = "skaven_plague_monk",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin_commander",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_medium",
		},
		{
			"delay",
			duration = {
				8,
				10
			}
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_pack_master",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 3,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 20,
			max_distance = 25,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_entrance",
			breed_name = "skaven_plague_monk",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_storm_vermin_shields_small",
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_storm_vermin_shields_small",
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_plague_monks_medium",
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_plague_monks_medium",
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_ratling_gunner",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 3,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 20,
			max_distance = 25,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"spawn_at_raw",
			spawner_id = "cemetery_brew_event_specials",
			breed_name = "skaven_plague_monk",
			optional_data = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
	}
	
	TerrorEventBlueprints.cemetery.cemetery_plague_brew_event_2_a = {
		{
			"disable_kick"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_chain_2",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_gutter_runner",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 3,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 20,
			max_distance = 25,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_medium"
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_warpfire_thrower",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 4,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 20,
			max_distance = 25,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_chain_2",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin_commander",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
	}
	
	TerrorEventBlueprints.cemetery.cemetery_plague_brew_event_2_b = {
		{
			"disable_kick"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 60
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_chain_2",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_gutter_runner",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 3,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 20,
			max_distance = 25,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_medium"
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_warpfire_thrower",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 4,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 20,
			max_distance = 25,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_chain_2",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin_commander",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
	}
	
	TerrorEventBlueprints.cemetery.cemetery_plague_brew_event_3_a = {
		{
			"disable_kick"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_chain_3",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_chain_3",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_medium"
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 15,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_warpfire_thrower",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 4,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 20,
			max_distance = 25,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_chain_3",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
	}
	
	TerrorEventBlueprints.cemetery.cemetery_plague_brew_event_3_b = {
		{
			"disable_kick"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "cemetery_brew_event_specials",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_chain_3",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_chain_3",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_medium"
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_storm_vermin",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 15,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 1.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"spawn_around_origin_unit",
			breed_name = "skaven_warpfire_thrower",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 4,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 20,
			max_distance = 25,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_chain_3",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
	}
	
	TerrorEventBlueprints.cemetery.cemetery_plague_brew_event_4_a = {
		{
			"disable_kick"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_medium"
		}
	}
	
	TerrorEventBlueprints.cemetery.cemetery_plague_brew_event_4_b = {
		{
			"disable_kick"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			composition_type = "event_extra_spice_medium"
		}
	}
	
	TerrorEventBlueprints.cemetery.cemetery_plague_brew_exit_event = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "cemetery_brew_event_chaos",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			spawner_id = "cemetery_brew_event_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_chain_4",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 15
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_warrior",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 8,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 2.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"event_horde",
			spawner_id = "cemetery_brew_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "cemetery_brew_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_chain_4",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function
			}
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"event_horde",
			spawner_id = "cemetery_brew_event_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"spawn_around_origin_unit",
			breed_name = "chaos_warrior",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 4,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 2.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"event_horde",
			spawner_id = "cemetery_brew_event_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = {
				"skaven_rat_ogre",
				"chaos_spawn",
			},
			optional_data = {
				max_health_modifier = 0.75,
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 2.5,
			max_distance = 6.5,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"event_horde",
			spawner_id = "cemetery_brew_event_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "cemetery_brew_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "cemetery_brew_event_chaos",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cemetery_chain_4",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 25
		},
		{
			"control_pacing",
			enable = true,
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 3 and count_event_breed("chaos_fanatic") < 3 and count_event_breed("chaos_marauder_with_shield") < 2
			end
		}
	}
	
	---------------------
	--Engines of War
	
	TerrorEventBlueprints.forest_ambush.forest_skaven_camp_loop = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_master_event_running",
			name = "forest_camp"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "skaven_camp_loop",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "skaven_camp_loop",
			composition_type = "event_extra_spice_unshielded"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "skaven_camp_loop",
			composition_type = "onslaught_storm_vermin_small"
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_special",
			spawner_id = "forest_camp_specials",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "skaven_camp_loop",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "skaven_camp_loop",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "skaven_camp_loop",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "skaven_camp_loop",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				2,
				4
			}
		},
		{
			"spawn_special",
			spawner_id = "forest_camp_specials",
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"spawn_special",
			spawner_id = "forest_camp_specials",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			}
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_slave") < 12 and (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 8 and (count_event_breed("skaven_storm_vermin_commander") + count_event_breed("skaven_storm_vermin_with_shield")) < 5
			end
		},
		{
			"delay",
			duration = {
				8,
				10
			}
		},
		{
			"flow_event",
			flow_event_name = "forest_skaven_camp_loop_restart"
		}
	}
	
	TerrorEventBlueprints.forest_ambush.forest_skaven_camp_resistance_loop = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_master_event_running",
			name = "forest_camp"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			spawner_id = "forest_camp_specials",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_camp_specials",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"spawn_special",
			spawner_id = "forest_camp_specials",
			breed_name = {
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "skaven_camp_loop",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "skaven_camp_loop",
			composition_type = "event_extra_spice_unshielded"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "skaven_camp_loop",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "skaven_camp_loop",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				4,
				9
			}
		},
		{
			"spawn_special",
			amount = 2,
			spawner_id = "forest_camp_specials",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"spawn_special",
			spawner_id = "forest_camp_specials",
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return count_event_breed("skaven_plague_monk") < 10 and count_event_breed("skaven_slave") < 24 and (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 16 and (count_event_breed("skaven_storm_vermin_commander") + count_event_breed("skaven_storm_vermin_with_shield")) < 10
			end
		},
		{
			"delay",
			duration = {
				13,
				17
			}
		},
		{
			"event_horde",
			spawner_id = "forest_camp_specials",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"spawn_special",
			amount = 2,
			spawner_id = "forest_camp_specials",
			breed_name = {
				"skaven_pack_master",
				"skaven_gutter_runner"
			}
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "skaven_camp_loop",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "skaven_camp_loop",
			composition_type = "event_extra_spice_unshielded"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "skaven_camp_loop",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				4,
				9
			}
		},
		{
			"spawn_special",
			amount = 2,
			spawner_id = "forest_camp_specials",
			breed_name = {
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_special",
			spawner_id = "forest_camp_specials",
			breed_name = {
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_plague_monk") < 10 and count_event_breed("skaven_slave") < 24 and (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 16 and (count_event_breed("skaven_storm_vermin_commander") + count_event_breed("skaven_storm_vermin_with_shield")) < 10
			end
		},
		{
			"delay",
			duration = {
				13,
				17
			}
		},
		{
			"flow_event",
			flow_event_name = "forest_skaven_camp_resistance_loop_restart"
		}
	}
	
	TerrorEventBlueprints.forest_ambush.forest_skaven_camp_a = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_master_event_running",
			name = "forest_camp"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "event_small"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_small"
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return count_event_breed("skaven_storm_vermin_commander") < 12
			end
		},
		{
			"delay",
			duration = {
				10,
				15
			}
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_small"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_storm_vermin_commander") < 10 
			end
		},
		{
			"flow_event",
			flow_event_name = "forest_skaven_camp_a_done"
		}
	}
	
	TerrorEventBlueprints.forest_ambush.forest_skaven_camp_b = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_master_event_running",
			name = "forest_camp"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "event_small"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_plague_monk") < 12 
			end
		},
		{
			"delay",
			duration = {
				10,
				15
			}
		},
		{
			"flow_event",
			flow_event_name = "forest_skaven_camp_b_done"
		}
	}
	
	TerrorEventBlueprints.forest_ambush.forest_skaven_camp_c = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_master_event_running",
			name = "forest_camp"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "skaven_shields"
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return count_event_breed("skaven_clan_rat_with_shield") < 20 and count_event_breed("skaven_storm_vermin_with_shield") < 10
			end
		},
		{
			"delay",
			duration = {
				10,
				15
			}
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "event_smaller"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "skaven_shields"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "skaven_shields"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_clan_rat_with_shield") < 10 and count_event_breed("skaven_storm_vermin_with_shield") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "forest_skaven_camp_c_done"
		}
	}
	
	TerrorEventBlueprints.forest_ambush.forest_skaven_camp_finale = {
		{
			"set_master_event_running",
			name = "forest_camp"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"stop_event",
			stop_event_name = "forest_skaven_camp_resistance_loop"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "forest_door_a",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_door_a",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_door_a",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"event_horde",
			spawner_id = "forest_skaven_camp",
			composition_type = "event_smaller"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_doomwheel_boss",
			breed_name = "skaven_rat_ogre",
			optional_data = {
			    enhancements = enhancement_5
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 10 and count_event_breed("skaven_slave") < 15 and count_event_breed("skaven_rat_ogre") < 1 and count_event_breed("skaven_stormfiend") < 1
			end
		},
		{
			"stop_master_event"
		},
		{
			"flow_event",
			flow_event_name = "forest_skaven_camp_finale_done"
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"control_pacing",
			enable = true
		}
	}
	
	TerrorEventBlueprints.forest_ambush.forest_end_event_loop = {
		{
			"set_master_event_running",
			name = "forest_finale"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "forest_end_event",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 3
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield")) < 8 and count_event_breed("skaven_slave") < 12 and count_event_breed("skaven_storm_vermin_commander") < 4
			end
		},
		{
			"delay",
			duration = {
				10,
				15
			}
		},
		{
			"flow_event",
			flow_event_name = "forest_end_event_loop_restart"
		}
	}
	
	TerrorEventBlueprints.forest_ambush.forest_end_event_a = {
		{
			"set_master_event_running",
			name = "forest_finale"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = {
				6,
				9
			}
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_specials",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_specials",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "forest_end_event",
			composition_type = "event_small"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "forest_end_event",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_specials",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				30,
				34
			}
		},
		{
			"flow_event",
			flow_event_name = "forest_end_event_restart"
		}
	}
	
	TerrorEventBlueprints.forest_ambush.forest_end_event_b = {
		{
			"set_master_event_running",
			name = "forest_finale"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "event_small_chaos"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_event_small_fanatics"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_event_small_fanatics"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "event_maulers_small"
		},
		{
			"delay",
			duration = {
				40,
				45
			}
		},
		{
			"flow_event",
			flow_event_name = "forest_end_event_restart"
		}
	}
	
	TerrorEventBlueprints.forest_ambush.forest_end_event_c = {
		{
			"set_master_event_running",
			name = "forest_finale"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "forest_end_event",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 1
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_custom_boss_spawn"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			spawner_id = "forest_end_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event",
			composition_type = "event_extra_spice_small"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				38,
				42
			}
		},
		{
			"flow_event",
			flow_event_name = "forest_end_event_restart"
		}
	}
	
	TerrorEventBlueprints.forest_ambush.forest_end_finale = {
		{
			"set_master_event_running",
			name = "forest_finale"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_finale",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_finale",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_finale",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "onslaught_custom_boss_minotaur"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_finale",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_finale",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			spawner_id = "forest_end_event_chaos",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 10 and count_event_breed("skaven_slave") < 15 and count_event_breed("skaven_storm_vermin_commander") < 5 and count_event_breed("chaos_raider") < 5 and count_event_breed("chaos_warrior") < 2
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "forest_end_event_restart"
		}
	}
	
	---------------------
	--Dark Omens
	
	local horde_sound_settings = {
		skaven = {
			stinger_sound_event = "enemy_horde_stinger",
			music_states = {
				horde = "horde"
			}
		},
		chaos = {
			stinger_sound_event = "enemy_horde_chaos_stinger",
			music_states = {
				pre_ambush = "pre_ambush_chaos",
				horde = "horde_chaos"
			}
		},
		beastmen = {
			stinger_sound_event = "enemy_horde_beastmen_stinger",
			music_states = {
				pre_ambush = "pre_ambush_beastmen",
				horde = "horde_beastmen"
			}
		}
	}
	
	local function num_spawned_enemies()
		local spawned_enemies = Managers.state.conflict:spawned_units()

		return #spawned_enemies
	end
	
	local function num_alive_standards()
		local alive_standards = Managers.state.conflict:alive_standards()

		return #alive_standards
	end
	
	TerrorEventBlueprints.crater.crater_mid_event = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_master_event_running",
			name = "crater_mid_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = true
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "crater_mid_event_door_horde_01",
			composition_type = "onslaught_custom_boss_minotaur",
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "crater_mid_event_door_horde_01",
			composition_type = "ungor_archers",
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "crater_mid_event_door_horde_02",
			composition_type = "ungor_archers",
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return count_event_breed("beastmen_minotaur") < 1 and count_breed("beastmen_ungor_archer") < 5
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "crater_mid_event_door_horde_01",
			composition_type = "event_medium_beastmen",
			sound_settings = horde_sound_settings.beastmen
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "crater_mid_event_door_horde_02",
			composition_type = "event_medium_beastmen",
			sound_settings = horde_sound_settings.beastmen
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return count_event_breed("beastmen_gor") < 1 and count_breed("beastmen_ungor") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "crater_mid_event_enable_gate"
		},
		{
			"delay",
			duration = 1
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"event_horde",
			limit_spawners = 1,
			spawner_id = "crater_mid_event_door_elite_02",
			composition_type = "crater_bestigor_medium",
			sound_settings = horde_sound_settings.beastmen
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("beastmen_bestigor") < 1
			end
		},
		{
			"delay",
			duration = 1
		},
		{
			"control_specials",
			enable = true
		},
		{
			"flow_event",
			flow_event_name = "crater_mid_event_done"
		}
	}
	
	TerrorEventBlueprints.crater.crater_end_event_manual_spawns = {
		{
			"spawn_at_raw",
			spawner_id = "crater_end_event_manual_spawn_01",
			breed_name = "beastmen_bestigor"
		},
		{
			"spawn_at_raw",
			spawner_id = "crater_end_event_manual_spawn_02",
			breed_name = "beastmen_bestigor"
		},
		{
			"spawn_at_raw",
			spawner_id = "crater_end_event_manual_spawn_03",
			breed_name = "beastmen_bestigor"
		},
		{
			"spawn_at_raw",
			spawner_id = "crater_end_event_manual_spawn_04",
			breed_name = "beastmen_bestigor"
		},
		{
			"spawn_at_raw",
			spawner_id = "crater_end_event_manual_spawn_05",
			breed_name = "beastmen_bestigor"
		},
		{
			"spawn_at_raw",
			spawner_id = "crater_end_event_manual_spawn_06",
			breed_name = "beastmen_bestigor"
		},
		{
			"spawn_at_raw",
			spawner_id = "crater_end_event_manual_spawn_07",
			breed_name = "beastmen_bestigor"
		},
		{
			"spawn_at_raw",
			spawner_id = "crater_end_event_manual_spawn_08",
			breed_name = "beastmen_bestigor"
		},
		{
			"spawn_at_raw",
			spawner_id = "crater_end_event_manual_spawn_10",
			breed_name = "beastmen_bestigor"
		},
		{
			"spawn_at_raw",
			spawner_id = "crater_end_event_manual_spawn_11",
			breed_name = "beastmen_bestigor"
		},
		{
			"spawn_at_raw",
			spawner_id = "crater_end_event_manual_spawn_12",
			breed_name = "beastmen_bestigor"
		},
		{
			"spawn_at_raw",
			spawner_id = "crater_end_event_manual_spawn_13",
			breed_name = "beastmen_bestigor"
		},
		{
			"spawn_at_raw",
			spawner_id = "crater_end_event_manual_spawn_14",
			breed_name = "beastmen_bestigor"
		},
		{
			"spawn_at_raw",
			spawner_id = "crater_end_event_manual_spawn_15",
			breed_name = "beastmen_bestigor"
		}
	}
	
	TerrorEventBlueprints.crater.crater_end_event_intro_wave = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "crater_end_event_intro_wave"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_beastmen_stinger"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event_intro_wave",
			composition_type = "event_large_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event_intro_wave",
			composition_type = "event_large_beastmen"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 55,
			condition = function (t)
				return count_event_breed("beastmen_gor") < 4 and count_breed("beastmen_ungor") < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "crater_end_event_intro_wave_done"
		}
	}
	
	TerrorEventBlueprints.crater.crater_end_event_wave_01 = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "crater_end_event_wave_01"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "event_large_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "event_large_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 16
			end
		},
		{
			"spawn_special",
			breed_name = "beastmen_bestigor",
			amount = 10
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "event_medium_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "event_medium_beastmen"
		},
		{
			"continue_when",
			duration = 90,
			condition = function (t)
				return num_alive_standards() < 1 and count_event_breed("beastmen_gor") < 8 and count_event_breed("beastmen_ungor") < 8
			end
		},
		{
			"spawn_at_raw",
			breed_name = "beastmen_minotaur",
			spawner_id = "event_minotaur"
		},
		{
			"flow_event",
			flow_event_name = "crater_end_event_wave_01_done"
		}
	}
	
	TerrorEventBlueprints.crater.crater_end_event_wave_02 = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "crater_end_event_wave_02"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "event_large_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "event_large_beastmen"
		},
		{
			"spawn_special",
			breed_name = "beastmen_bestigor",
			amount = 14
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 20
			end
		},
		{
			"spawn_special",
			breed_name = "beastmen_bestigor",
			amount = 10
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "event_large_beastmen"
		},
		{
			"continue_when",
			duration = 180,
			condition = function (t)
				return num_alive_standards() < 1 and count_event_breed("beastmen_gor") < 8 and count_event_breed("beastmen_ungor") < 8
			end
		},
		{
			"flow_event",
			flow_event_name = "crater_end_event_wave_02_done"
		}
	}
	
	TerrorEventBlueprints.crater.crater_end_event_wave_03 = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "crater_end_event_wave_03"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "event_large_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 20
			end
		},
		{
			"spawn_special",
			breed_name = "beastmen_bestigor",
			amount = 12
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "event_large_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "ungor_archers"
		},
		{
			"continue_when",
			duration = 180,
			condition = function (t)
				return num_alive_standards() < 1 and count_event_breed("beastmen_gor") < 8 and count_event_breed("beastmen_ungor") < 8
			end
		},
		{
			"flow_event",
			flow_event_name = "crater_end_event_wave_03_done"
		}
	}
	
	TerrorEventBlueprints.crater.crater_end_event_wave_04 = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "crater_end_event_wave_04"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "event_large_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "event_large_beastmen"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 16
			end
		},
		{
			"spawn_special",
			breed_name = "beastmen_bestigor",
			amount = 12
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "event_large_beastmen"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "ungor_archers"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "crater_end_event",
			composition_type = "ungor_archers"
		},
		{
			"flow_event",
			flow_event_name = "crater_end_event_wave_04_repeat"
		},
		{
			"continue_when",
			duration = 180,
			condition = function (t)
				return num_alive_standards() < 1 and count_event_breed("beastmen_gor") < 5 and count_event_breed("beastmen_ungor") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "crater_end_event_wave_04_done"
		}
	}
	
	TerrorEventBlueprints.crater.crater_end_event_minotaur = {
		{
			"spawn_at_raw",
			breed_name = "beastmen_minotaur",
			spawner_id = "event_minotaur",
			difficulty_requirement = HARD
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("beastmen_minotaur") == 2
			end
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("beastmen_minotaur") < 2
			end
		}
	}
	
	HordeCompositions.event_small_beastmen = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					13,
					14
				}
			}
		},
		{
			name = "mixed",
			weight = 3,
			breeds = {
				"beastmen_ungor",
				{
					3,
					4
				},
				"beastmen_gor",
				{
					9,
					10
				}
			}
		}
	}
	
	HordeCompositions.event_medium_beastmen = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					16,
					17
				},
				"beastmen_ungor",
				{
					8,
					9
				}
			}
		},
		{
			name = "mixed",
			weight = 3,
			breeds = {
				"beastmen_gor",
				{
					7,
					8
				},
				"beastmen_ungor",
				{
					15,
					16
				}
			}
		}
	}
	
	HordeCompositions.event_large_beastmen = {
		{
			name = "plain",
			weight = 7,
			breeds = {
				"beastmen_gor",
				{
					18,
					19
				},
				"beastmen_ungor",
				{
					16,
					17
				}
			}
		},
		{
			name = "mixed",
			weight = 3,
			breeds = {
				"beastmen_gor",
				{
					22,
					23
				},
				"beastmen_ungor",
				{
					14,
					15
				}
			}
		}
	}
	
	HordeCompositions.crater_bestigor_medium = {
		{
			name = "ambestigor",
			weight = 3,
			breeds = {
				"beastmen_bestigor",
				{
					9,
					10
				},
				"beastmen_standard_bearer",
				2
			}
		}
	}
	
	---------------------
	--Old Haunts

	HordeCompositions.trash_skeletons = {
		{
			name = "trashetons",
			weight = 3,
			breeds = {
				"ethereal_skeleton_with_shield",
				{
					15,
					16
				}
			}
		}
	}

	HordeCompositions.buff_skeletons = {
		{
			name = "buffetons",
			weight = 3,
			breeds = {
				"ethereal_skeleton_with_hammer",
				{
					5,
					6
				}
			}
		}
	}

	HordeCompositions.a_singular_cw = {
		{
			name = "loner",
			weight = 3,
			breeds = {
				"chaos_warrior",
				{
					1,
					1
				}
			}
		}
	}
	
	TerrorEventBlueprints.dlc_portals.dlc_portals_control_pacing_disabled = {
		{
			"text",
			text = "",
			duration = 0
		}
	}
	
	TerrorEventBlueprints.dlc_portals.dlc_portals_temple_inside = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "dlc_portals_temple_inside"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"event_horde",
			spawner_id = "portals_temple_inside",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "portals_temple_inside",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			spawner_id = "portals_temple_inside",
			composition_type = "onslaught_storm_vermin_shields_small"
		},
		{
			"delay",
			duration = 25
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 14 and count_event_breed("skaven_slave") < 14 and count_event_breed("skaven_storm_vermin_commander") < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_portals_temple_inside_done"
		}
	}

	TerrorEventBlueprints.dlc_portals.dlc_portals_temple_inside_specials = {
		{
			"event_horde",
			spawner_id = "portals_temple_inside_specials",
			composition_type = "plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "portals_temple_inside_specials",
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"event_horde",
			spawner_id = "portals_temple_inside_specials",
			composition_type = "onslaught_custom_special_skaven"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_haunts_ladder_left1",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function,
				max_health_modifier = 1.5,
				size_variation_range = {
					1.2,
					1.25
				}
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_haunts_ladder_right1",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function,
				max_health_modifier = 1.5,
				size_variation_range = {
					1.2,
					1.25
				}
			}
		},
	}
	
	TerrorEventBlueprints.dlc_portals.dlc_portals_temple_yard = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_temple_yard"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			spawner_id = "portals_temple_yard",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 6
		},
		{
			"spawn_special",
			spawner_id = "portals_temple_yard",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"skaven_warpfire_thrower"
			}
		},
		{
			"spawn_special",
			spawner_id = "portals_temple_yard",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"skaven_warpfire_thrower"
			}
		},
		{
			"event_horde",
			spawner_id = "portals_temple_yard_specials",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "portals_temple_yard_specials",
			composition_type = "chaos_warriors"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "portals_temple_inside_specials",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "portals_temple_yard",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 25 and count_event_breed("chaos_fanatic") < 30 and count_event_breed("chaos_raider") < 8
			end
		},
		{
			"flow_event",
			flow_event_name = "dlc_portals_temple_yard_done"
		}
	}
	
	TerrorEventBlueprints.dlc_portals.dlc_portals_temple_yard_exit = {
		{
			"spawn_at_raw",
			spawner_id = "portals_temple_yard_exit",
			breed_name = "skaven_ratling_gunner"
		},
		{
			"delay",
			duration = 35
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"control_hordes",
			enable = true
		}
	}
	
	TerrorEventBlueprints.dlc_portals.dlc_portals_end_event_guards = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"continue_when",
			duration = 1,
			condition = function (t)
				return activate_darkness()
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "portals_end_event_guards",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "portals_end_event_guards",
			composition_type = "onslaught_chaos_warriors"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_cw_boss",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function
			}
		}
	}
	
	TerrorEventBlueprints.dlc_portals.dlc_portals_end_event_a = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "dlc_portals_end_event"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_shield",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 6,
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_hammer",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 5,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 6,
		},
		{
			"spawn_special",
			spawner_id = "portals_end_event_specials",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_ratling_gunner"
			}
		},
		{
			"event_horde",
			composition_type = "event_medium",
			spawner_id = "portals_end_event_skaven",
		},
		{
			"delay",
			duration = 16,
		},
		{
			"continue_when",
			duration = 5,
			condition = function (t)
				return spawned_during_event() < 12
			end
		},
		{
			"spawn_special",
			breed_name = "skaven_pack_master",
			spawner_id = "portals_end_event_specials",
			amount = 1,
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_shield",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 8,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "portals_end_event_done"
		}
	}
	
	TerrorEventBlueprints.dlc_portals.dlc_portals_end_event_b = {
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "dlc_portals_end_event"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_shield",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 6,
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_hammer",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 5,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"spawn_special",
			breed_name = "skaven_pack_master",
			spawner_id = "portals_end_event_specials",
			amount = 1,
		},
		{
			"event_horde",
			composition_type = "event_medium",
			spawner_id = "portals_end_event_skaven",
		},
		{
			"delay",
			duration = 16,
		},
		{
			"continue_when",
			duration = 5,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"spawn_special",
			spawner_id = "portals_end_event_specials",
			amount = 2,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"skaven_warpfire_thrower"
			}
		},
		{
			"spawn_special",
			spawner_id = "portals_end_event_specials",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner"
			},
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_hammer",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 5,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 6,
		},
		{
			"event_horde",
			spawner_id = "portals_end_event",
			composition_type = "a_singular_cw"
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_shield",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_hammer",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 5,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 6,
		},
		{
			"spawn_special",
			breed_name = "skaven_pack_master",
			spawner_id = "portals_end_event_specials",
			amount = 1,
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"flow_event",
			flow_event_name = "portals_end_event_done"
		}
	}
	
	TerrorEventBlueprints.dlc_portals.dlc_portals_end_event_c = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_end_event"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_shield",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 8
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_hammer",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 5,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 6,
		},
		{
			"spawn_special",
			breed_name = "skaven_pack_master",
			spawner_id = "portals_end_event_specials",
			amount = 1,
		},
		{
			"event_horde",
			composition_type = "event_medium",
			spawner_id = "portals_end_event_skaven",
		},
		{
			"delay",
			duration = 16,
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_hammer",
			spawn_counter_category = "cursed_chest_enemies",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 8,
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_hammer",
			spawn_counter_category = "cursed_chest_enemies",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"spawn_special",
			spawner_id = "portals_end_event_specials",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			},
		},
		{
			"spawn_special",
			spawner_id = "portals_end_event_specials",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner"
			},
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_shield",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 2,
		},
		{
			"event_horde",
			spawner_id = "portals_end_event",
			composition_type = "a_singular_cw"
		},
		{
			"spawn_special",
			breed_name = "skaven_pack_master",
			spawner_id = "portals_end_event_specials",
			amount = 1,
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"flow_event",
			flow_event_name = "portals_end_event_done"
		}
	}
	
	TerrorEventBlueprints.dlc_portals.dlc_portals_end_event_d = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_end_event"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_shield",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 6,
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_hammer",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 5,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 6,
		},
		{
			"event_horde",
			composition_type = "event_medium",
			spawner_id = "portals_end_event_skaven",
		},
		{
			"delay",
			duration = 16,
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_hammer",
			spawn_counter_category = "cursed_chest_enemies",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"spawn_special",
			breed_name = "skaven_pack_master",
			spawner_id = "portals_end_event_specials",
			amount = 1,
		},
		{
			"delay",
			duration = 4
		},
		{
			"spawn_special",
			spawner_id = "portals_end_event_specials",
			amount = 2,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"skaven_ratling_gunner"
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_shield",
			spawn_counter_category = "cursed_chest_enemies",
			amount = 10,
			optional_data = {
				prevent_killed_enemy_dialogue = true,
				spawned_func = cursed_chest_enemy_spawned_func,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 2,
		},
		{
			"event_horde",
			spawner_id = "portals_end_event",
			composition_type = "a_singular_cw"
		},
		{
			"spawn_around_origin_unit",
			breed_name = "ethereal_skeleton_with_hammer",
			spawn_counter_category = "cursed_chest_enemies",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function,
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 3,
		},
		{
			"delay",
			duration = 4
		},
		{
			"spawn_special",
			breed_name = "skaven_pack_master",
			spawner_id = "portals_end_event_specials",
			amount = 1,
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"flow_event",
			flow_event_name = "portals_end_event_done"
		}
	}
	
	TerrorEventBlueprints.dlc_portals.dlc_portals_end_escape_specials = {
		{
			"event_horde",
			spawner_id = "portals_end_escape_specials",
			composition_type = "plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_specials",
			composition_type = "plague_monks_medium"
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_specials",
			composition_type = "plague_monks_medium"
		},
		{
			"spawn_special",
			spawner_id = "portals_end_escape_specials",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower"
			}
		},
		{
			"delay",
			duration = 4
		},
		{
			"spawn_special",
			spawner_id = "portals_end_escape_specials",
			amount = 1,
			breed_name = {
				"skaven_pack_master"
			}
		},
	}
	
	TerrorEventBlueprints.dlc_portals.dlc_portals_end_escape_a = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_end_escape"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "portals_end_event_skaven",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 6
		},
		{
			"spawn_special",
			spawner_id = "portals_end_escape_specials",
			amount = 2,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_ratling_gunner"
			}
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_skaven",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape",
			composition_type = "plague_monks_medium"
		},
		{
			"delay",
			duration = 6
		},
		{
			"spawn_special",
			breed_name = "skaven_warpfire_thrower",
			spawner_id = "portals_end_escape_specials",
			amount = 1,
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_skaven",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"delay",
			duration = {
				1,
				4
			}
		},
		{
			"flow_event",
			flow_event_name = "portals_end_escape_done"
		}
	}
	
	TerrorEventBlueprints.dlc_portals.dlc_portals_end_escape_b = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_end_escape"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_skaven",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"spawn_special",
			spawner_id = "portals_end_escape_specials",
			amount = 2,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"skaven_warpfire_thrower"
			}
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape",
			composition_type = "onslaught_chaos_shields"
		},
		{
			"spawn_special",
			breed_name = "skaven_ratling_gunner",
			spawner_id = "portals_end_escape_specials",
			amount = 1,
		},
		{
			"delay",
			duration = 6
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"flow_event",
			flow_event_name = "portals_end_escape_done"
		}
	}
	
	TerrorEventBlueprints.dlc_portals.dlc_portals_end_escape_yard = {
		{
			"set_freeze_condition",
			max_active_enemies = 80
		},
		{
			"set_master_event_running",
			name = "dlc_portals_end_escape_yard"
		},
		{
			"disable_kick"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_yard",
			composition_type = "onslaught_custom_boss_spawn"
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_yard",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_yard",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_yard",
			composition_type = "onslaught_custom_boss_spawn"
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_yard_specials",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_yard_specials",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_yard_specials",
			composition_type = "chaos_warriors"
		},
		{
			"spawn_at_raw",
			spawner_id = "onslaught_haunts_heads_portal",
			breed_name = "chaos_spawn",
			optional_data = {
				enhancements = enhancement_7
			}
		},
		{
			"delay",
			duration = 3
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 12 and count_event_breed("chaos_fanatic") < 12
			end
		},
		{
			"event_horde",
			spawner_id = "portals_end_escape_yard",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 3 and count_event_breed("chaos_fanatic") < 3 and count_event_breed("chaos_raider") < 2
			end
		},
		{
			"delay",
			duration = {
				1,
				5
			}
		},
		{
			"flow_event",
			flow_event_name = "portals_end_escape_yard_done"
		}
	}
	
	-------------------
	--Blood in the Darkness
	
	TerrorEventBlueprints.dlc_bastion.bastion_gate_event = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "bastion_gate_event"
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"delay",
			duration = 1
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "plague_monks_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 5,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 25 and count_event_breed("skaven_slave") < 32 and count_event_breed("skaven_storm_vermin_commander") < 8
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "plague_monks_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_poison_wind_globadier",
			spawner_id = "bastion_gate_event_special",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_rat_ogre",
			spawner_id = "bastion_gate_event_special",
			optional_data = {
				enhancements = relentless,
				spawned_func = degenerating_rat_ogre
			}
		},
		{
			"control_specials",
			enable = true
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield") < 24) and count_event_breed("skaven_slave") < 32 and count_event_breed("skaven_storm_vermin_commander") < 8
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "plague_monks_medium"
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_ratling_gunner",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_ratling_gunner",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield") < 24) and count_event_breed("skaven_slave") < 32 and count_event_breed("skaven_storm_vermin_commander") < 8			
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "event_large"
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "event_medium_shield"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield") < 24) and count_event_breed("skaven_slave") < 32 and count_event_breed("skaven_storm_vermin_commander") < 8			
			end
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_gutter_runner",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield") < 24) and count_event_breed("skaven_slave") < 32 and count_event_breed("skaven_storm_vermin_commander") < 8
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_warpfire_thrower",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_warpfire_thrower",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 25,
			condition = function (t)
				return (count_event_breed("skaven_clan_rat") + count_event_breed("skaven_clan_rat_with_shield") < 24) and count_event_breed("skaven_slave") < 32 and count_event_breed("skaven_storm_vermin_commander") < 8
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "event_medium_shield"
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_gutter_runner",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_gutter_runner",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event",
			composition_type = "plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_gate_event_chaos",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_gate_event_chaos",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_gate_event_chaos",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_gate_event_chaos",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return count_event_breed("skaven_plague_monk") < 14 and count_event_breed("chaos_warrior") < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event_chaos",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event_chaos",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_gate_event_chaos",
			composition_type = "chaos_warriors_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_stormfiend",
			spawner_id = "bastion_gate_event_special",
			optional_data = {
				enhancements = relentless,
				spawned_func = degenerating_rat_ogre
			}
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_spawn",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 20 and count_event_breed("chaos_fanatic") < 22 and count_event_breed("chaos_warrior") < 10
			end
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_troll",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_troll",
			spawner_id = "bastion_gate_event_special",
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_gate_event_chaos",
			composition_type = "chaos_warriors_small"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event_chaos",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 7
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "bastion_gate_event_chaos",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("chaos_marauder") < 8 and count_event_breed("chaos_fanatic") < 8 and count_event_breed("chaos_warrior") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "bastion_gate_event_done"
		}
	}
	
	TerrorEventBlueprints.dlc_bastion.bastion_finale_event = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"disable_kick"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"set_master_event_running",
			name = "bastion_finale_event"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"delay",
			duration = 10
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"continue_when",
			duration = 1,
			condition = function (t)
				return activate_twins()
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event",
			composition_type = "plague_monks_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "bastion_finale_event_boss",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "nngl_bastion_vo_sorcerer_taunt"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event",
			composition_type = "storm_vermin_medium"
		},
				{
			"continue_when",
			duration = 1,
			condition = function (t)
				return activate_lightning_strike()
			end
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "nngl_bastion_vo_sorcerer_taunt"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event",
			composition_type = "event_medium_shield"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"delay",
			duration = 15,
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event",
			composition_type = "event_small"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event",
			composition_type = "storm_vermin_small"
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "bastion_finale_event_boss",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower",
				"skaven_poison_wind_globadier",
				"skaven_poison_wind_globadier"
			},
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "bastion_finale_event_boss",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower",
				"skaven_poison_wind_globadier",
				"skaven_poison_wind_globadier"
			},
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "nngl_bastion_vo_sorcerer_taunt"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event",
			composition_type = "event_medium_shield"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "bastion_finale_event_boss",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower",
				"skaven_pack_master",
				"skaven_poison_wind_globadier",
				"skaven_poison_wind_globadier"
			},
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "bastion_finale_event_boss",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower",
				"skaven_poison_wind_globadier",
				"skaven_poison_wind_globadier"
			},
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "bastion_finale_event_boss",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower",
				"skaven_poison_wind_globadier",
				"skaven_poison_wind_globadier"
			},
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "bastion_finale_event_boss",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower",
				"skaven_poison_wind_globadier",
				"skaven_poison_wind_globadier"
			},
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event",
			composition_type = "storm_vermin_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "bastion_vo_finale_tiring"
		},
		{
			"delay",
			duration = 3
		},
		{
			"flow_event",
			flow_event_name = "nngl_bastion_vo_sorcerer_taunt"
		},
		{
			"delay",
			duration = 3
		},
		{
			"flow_event",
			flow_event_name = "bastion_finale_event_boss"
		}
	}
	
	TerrorEventBlueprints.dlc_bastion.bastion_event_rat_ogre = {
		{
			"set_master_event_running",
			name = "bastion_event_boss"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "chaos_warriors"
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "chaos_warriors"
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 5
			end
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_gutter_runner",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "bastion_finale_event_escape"
		}
	}
	
	TerrorEventBlueprints.dlc_bastion.bastion_event_storm_fiend = {
		{
			"set_master_event_running",
			name = "bastion_event_boss"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "chaos_warriors"
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 5
			end
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_gutter_runner",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "bastion_finale_event_escape"
		}
	}
	
	TerrorEventBlueprints.dlc_bastion.bastion_event_chaos_spawn = {
		{
			"set_master_event_running",
			name = "bastion_event_boss"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "chaos_warriors"
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 3
			end
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "event_maulers_medium"
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 5
			end
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 1
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_pack_master",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			breed_name = "skaven_gutter_runner",
			spawner_id = "bastion_finale_event_boss",
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "bastion_finale_event_escape"
		}
	}
	
	TerrorEventBlueprints.dlc_bastion.bastion_finale_event_gauntlet = {
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "event_stormvermin_shielders"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 7
		},
		{
			"event_horde",
			limit_spawners = 5,
			spawner_id = "bastion_finale_event_escape",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 4 and count_event_breed("skaven_slave") < 5
			end
		}
	}
	
	-----------------
	--Enchanter's lair
	
	TerrorEventBlueprints.dlc_castle.castle_catacombs_welcome_committee = {
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "catacombs_welcome_committee",
			composition_type = "event_large_chaos"
		},
		{
			"event_horde",
			spawner_id = "catacombs_welcome_committee",
			composition_type = "onslaught_chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "catacombs_welcome_committee",
			composition_type = "onslaught_chaos_berzerkers_small"
		},
		{
			"continue_when",
			duration = 1,
			condition = function (t)
				return spawn_nurglings_dutch()
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "catacombs_special_welcome",
			composition_type = "onslaught_chaos_warriors"
		}
	}

	TerrorEventBlueprints.dlc_castle.castle_dining_hall_guards = {
		{
			"set_master_event_running",
			name = "dining_hall",
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "dining_hall_spawner_recruit",
			difficulty_requirement = NORMAL,
		},
		{
			"delay",
			duration = 0.8,
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "dining_hall_spawner_veteran",
			difficulty_requirement = HARD,
		},
		{
			"delay",
			duration = 0.8,
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "dining_hall_spawner_champion",
			difficulty_requirement = HARDER,
		},
		{
			"delay",
			duration = 0.8,
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "dining_hall_spawner_legend",
			difficulty_requirement = HARDEST,
		},
		{
			"delay",
			duration = 0.8,
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "dining_hall_spawner_cataclysm",
			difficulty_requirement = CATACLYSM,
		},
		{
			"delay",
			duration = 0.8,
		},
		{
			"spawn_at_raw",
			breed_name = "chaos_warrior",
			spawner_id = "dining_hall_spawner_cataclysm_02",
			difficulty_requirement = CATACLYSM,
		},
		{
			"delay",
			duration = 5,
		},
		{
			"continue_when",
			duration = 1,
			condition = function (t)
				return spawn_nurglings_dutch()
			end
		},
		{
			"delay",
			duration = {
				40,
				80
			}
		},
		{
			"continue_when",
			duration = 1,
			condition = function (t)
				return spawn_nurglings_dutch()
			end
		},
		{
			"delay",
			duration = {
				60,
				120
			}
		},
		{
			"continue_when",
			duration = 1,
			condition = function (t)
				return spawn_nurglings_dutch()
			end
		},
		{
			"delay",
			duration = {
				60,
				120
			}
		},
		{
			"continue_when",
			duration = 1,
			condition = function (t)
				return spawn_nurglings_dutch()
			end
		},
		{
			"delay",
			duration = {
				60,
				120
			}
		},
		{
			"continue_when",
			duration = 1,
			condition = function (t)
				return spawn_nurglings_dutch()
			end
		},
		{
			"delay",
			duration = {
				60,
				120
			}
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return count_event_breed("chaos_warrior") < 1
			end,
		},
		{
			"flow_event",
			flow_event_name = "castle_dining_hall_all_chaos_warriors_dead",
		},
	}
	
	TerrorEventBlueprints.dlc_castle.castle_chaos_boss = {
		{
			"control_pacing",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"set_master_event_running",
			name = "castle_chaos_boss"
		},
		{
			"spawn_at_raw",
			spawner_id = "castle_chaos_boss",
			breed_name = "chaos_exalted_sorcerer_drachenfels",
			optional_data = {
				max_health_modifier = 1.3,
				spawned_func = exalted_chaos_boss
			}
		},
		{
			"continue_when",
			duration = 80,
			condition = function (t)
				return count_event_breed("chaos_exalted_sorcerer_drachenfels") == 1
			end
		},
		{
			"flow_event",
			flow_event_name = "castle_chaos_boss_spawn"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			condition = function (t)
				return count_event_breed("chaos_exalted_sorcerer_drachenfels") < 1
			end
		},
		{
			"control_specials",
			enable = true
		},
		{
			"flow_event",
			flow_event_name = "castle_chaos_boss_dead"
		}
	}
	
	TerrorEventBlueprints.dlc_castle.castle_catacombs_end_event_loop = {
		{
			"set_master_event_running",
			name = "escape_catacombs"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "escape_catacombs",
			composition_type = "event_large"
		},
		{
			"continue_when",
			duration = 1,
			condition = function (t)
				return spawn_nurglings_dutch()
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 50,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 18 and count_event_breed("skaven_slave") < 16
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "castle_catacombs_end_event_loop_done"
		}
	}
	
	TerrorEventBlueprints.dlc_castle.castle_catacombs_end_event_loop_extra_spice = {
		{
			"set_master_event_running",
			name = "escape_catacombs"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_escape_spice",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_escape_spice",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 50,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 12 and count_event_breed("skaven_storm_vermin_commander") < 6
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "castle_catacombs_end_event_loop_extra_spice_done"
		}
	}

	HordeCompositions.chaos_event_defensive = {
		{
			name = "wave_a",
			weight = 4,
			breeds = {
				"chaos_fanatic",
				{
					14,
					16
				},
				"chaos_marauder",
				{
					8,
					12
				},
				"skaven_dummy_clan_rat",
				{
					8,
					12
				},
				"chaos_marauder_with_shield",
				{
					6,
					8
				},
				"chaos_berzerker",
				{
					4,
					5
				},
				"chaos_marauder_tutorial",
				{
					4,
					5
				},
				"chaos_raider_tutorial",
				2
			}
		},
		{
			name = "wave_b",
			weight = 4,
			breeds = {
				"chaos_fanatic",
				{
					14,
					16
				},
				"chaos_marauder",
				{
					8,
					12
				},
				"skaven_dummy_clan_rat",
				{
					6,
					8
				},
				"chaos_marauder_with_shield",
				{
					10,
					12
				},
				"chaos_berzerker",
				{
					4,
					5
				},
				"chaos_marauder_tutorial",
				{
					4,
					5
				},
				"chaos_raider_tutorial",
				2
			}
		},
		{
			name = "wave_c",
			weight = 2,
			breeds = {
				"chaos_fanatic",
				{
					14,
					16
				},
				"chaos_marauder",
				{
					8,
					12
				},
				"skaven_dummy_clan_rat",
				{
					8,
					12
				},
				"chaos_marauder_with_shield",
				{
					6,
					8
				},
				"chaos_raider",
				{
					7,
					8
				},
				"chaos_warrior",
				2
			}
		},
		{
			name = "wave_d",
			weight = 2,
			breeds = {
				"chaos_fanatic",
				{
					14,
					16
				},
				"chaos_marauder",
				{
					8,
					12
				},
				"skaven_dummy_clan_rat",
				{
					8,
					12
				},
				"chaos_marauder_with_shield",
				{
					6,
					8
				},
				"chaos_raider",
				{
					7,
					8
				},
				"chaos_warrior",
				2
			}
		},
		{
			name = "wave_e",
			weight = 2,
			breeds = {
				"chaos_fanatic",
				{
					14,
					16
				},
				"chaos_marauder",
				{
					8,
					12
				},
				"skaven_dummy_clan_rat",
				{
					8,
					12
				},
				"chaos_marauder_with_shield",
				{
					6,
					8
				},
				"chaos_raider",
				{
					7,
					8
				},
				"chaos_warrior",
				2
			}
		},
		end_time = 9999,
		start_time = 0
	}
	
	HordeCompositions.chaos_event_defensive_intense = {
		{
			name = "wave_a",
			weight = 4,
			breeds = {
				"chaos_fanatic",
				{
					15,
					16
				},
				"chaos_marauder",
				{
					8,
					10
				},
				"skaven_dummy_clan_rat",
				{
					8,
					10
				},
				"chaos_marauder_with_shield",
				{
					8,
					10
				},
				"chaos_berzerker",
				{
					13,
					14
				}
			}
		},
		{
			name = "wave_b",
			weight = 4,
			breeds = {
				"chaos_fanatic",
				{
					15,
					16
				},
				"chaos_marauder",
				{
					8,
					10
				},
				"skaven_dummy_clan_rat",
				{
					8,
					10
				},
				"chaos_marauder_with_shield",
				{
					8,
					10
				},
				"chaos_raider",
				{
					3,
					4
				},
				"chaos_berzerker",
				{
					3,
					4
				},
				"chaos_warrior",
				2
			}
		},
		{
			name = "wave_c",
			weight = 4,
			breeds = {
				"chaos_fanatic",
				{
					15,
					16
				},
				"chaos_marauder",
				{
					8,
					10
				},
				"skaven_dummy_clan_rat",
				{
					8,
					10
				},
				"chaos_marauder_with_shield",
				{
					8,
					10
				},
				"chaos_raider",
				{
					14,
					16
				}
			}
		},
		{
			name = "wave_d",
			weight = 4,
			breeds = {
				"chaos_fanatic",
				{
					15,
					16
				},
				"chaos_marauder",
				{
					8,
					10
				},
				"skaven_dummy_clan_rat",
				{
					8,
					10
				},
				"chaos_marauder_with_shield",
				{
					8,
					10
				},
				"chaos_berzerker",
				{
					8,
					10
				},
				"chaos_marauder_tutorial",
				{
					5,
					6
				}
			}
		},
		{
			name = "wave_e",
			weight = 4,
			breeds = {
				"chaos_fanatic",
				{
					15,
					16
				},
				"chaos_marauder",
				{
					8,
					10
				},
				"skaven_dummy_clan_rat",
				{
					8,
					10
				},
				"chaos_marauder_with_shield",
				{
					8,
					10
				},
				"chaos_warrior",
				6
			}
		},
		end_time = 9999,
		start_time = 0
	}
	
	HordeCompositions.chaos_event_offensive_small = {
		{
			name = "wave_a",
			weight = 4,
			breeds = {
				"chaos_marauder",
				{
					10,
					12
				},
				"chaos_fanatic",
				{
					8,
					10
				},
				"chaos_raider",
				{
					2,
					3
				},
				"chaos_berzerker",
				{
					2,
					3
				},
				"chaos_marauder_tutorial",
				{
					2,
					3
				}
			}
		},
		end_time = 9999,
		start_time = 0
	}
	
	HordeCompositions.chaos_event_offensive = {
		{
			name = "wave_a",
			weight = 4,
			breeds = {
				"chaos_marauder",
				{
					10,
					12
				},
				"chaos_fanatic",
				{
					8,
					10
				},
				"chaos_berzerker",
				{
					4,
					5
				},
				"chaos_marauder_tutorial",
				{
					4,
					5
				}
			}
		},
		{
			name = "wave_b",
			weight = 4,
			breeds = {
				"chaos_marauder",
				{
					10,
					12
				},
				"chaos_fanatic",
				{
					10,
					12
				},
				"skaven_dummy_clan_rat",
				{
					10,
					12
				},
				"chaos_raider",
				{
					6,
					7
				}
			}
		},
		end_time = 9999,
		start_time = 0
	}

	--Trail of Treachery

	TerrorEventBlueprints.dlc_wizards_trail.trail_disable_pacing_mid = {
		{
			"control_specials",
			enable = true
		},
		{
			"control_pacing",
			enable = true
		}
	}

	--First Drop

	TerrorEventBlueprints.dlc_wizards_trail.trail_enable_pacing_mid = {
		{
			"control_specials",
			enable = true
		},
		{
			"control_pacing",
			enable = true
		},
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_disable_pacing_light = {
		{
			"control_specials",
			enable = true
		},
		{
			"control_pacing",
			enable = true
		},
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_enable_pacing_light = {
		{
			"control_specials",
			enable = true
		},
		{
			"control_pacing",
			enable = true
		},
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_drawbridge_wallbreaker = {
		{
			"spawn_at_raw",
			spawner_id = "drawbridge_wall_breaker_01",
			breed_name = {
				"skaven_dummy_slave"
			},
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "drawbridge_wall_breaker_02",
			breed_name = {
				"skaven_dummy_slave"
			},
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		}
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_grim_path_ambush = {
		{
			"spawn_at_raw",
			spawner_id = "path_ambush_spawner_01",
			amount = 1,
			breed_name = {
				"skaven_stormfiend"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_at_raw",
			spawner_id = "path_ambush_spawner_02",
			amount = 1,
			breed_name = {
				"chaos_spawn"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return count_event_breed("skaven_poison_wind_globadier", "skaven_ratling_gunner", "skaven_warpfire_thrower") < 2
			end
		},
		{
			"delay",
			duration = 3
		}
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_mid_event_recons = {
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"delay",
			duration = 2
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_mid_event_recons_special_02",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_warpfire_thrower"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "trail_mid_event_recons_done"
		}
	}

	--Mid First lever
	TerrorEventBlueprints.dlc_wizards_trail.trail_mid_event_01 = {
		{
			"set_master_event_running",
			name = "trail_mid_event_01"
		},
		{
			"disable_kick"
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"event_horde",
			spawner_id = "trail_mid_event_spawn_01",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "trail_mid_event_spawn_02",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			spawner_id = "trail_mid_event_spawn_02",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "buffed_enemy_spawn_1",
			breed_name = "skaven_dummy_slave",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function()
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "buffed_enemy_spawn_2",
			breed_name = "skaven_dummy_slave",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function()
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "buffed_enemy_spawn_3",
			breed_name = "skaven_dummy_slave",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function()
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_gutter_runner"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 20
			end
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "trail_mid_event_spawn_02",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_special",
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner"
			}
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "trail_mid_event_spawn_roof",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 8
			end
		},
		{
			"event_horde",
			spawner_id = "trail_mid_event_spawn_02",
			composition_type = "plague_monks_medium"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "trail_mid_event_spawn_02",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			spawner_id = "trail_mid_event_spawn_02",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_mid_event_02",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"event_horde",
			spawner_id = "trail_mid_event_spawn_02",
			composition_type = "event_extra_spice_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_mid_event_02",
			breed_name = "skaven_pack_master"
		},
		{
			"event_horde",
			spawner_id = "trail_mid_event_spawn_02",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 8
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_mid_event_02",
			breed_name = "skaven_warpfire_thrower"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "trail_mid_event_spawn_03",
			composition_type = "event_extra_spice_large"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "trail_mid_event_spawn_roof",
			composition_type = "event_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "buffed_enemy_spawn_1",
			breed_name = "skaven_dummy_slave",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "buffed_enemy_spawn_2",
			breed_name = "skaven_dummy_slave",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "buffed_enemy_spawn_3",
			breed_name = "skaven_dummy_slave",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 20
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_pack_master",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_pack_master",
				"skaven_gutter_runner"
			},
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 10
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return num_spawned_enemies() < 20
			end
		},
		{
			"control_hordes",
			enable = true
		},
		{
			"flow_event",
			flow_event_name = "trail_mid_event_01_done"
		}
	}

	--Second lever
	TerrorEventBlueprints.dlc_wizards_trail.trail_mid_event_04 = {
		{
			"set_master_event_running",
			name = "trail_mid_event_04"
		},
		{
			"disable_kick"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"event_horde",
			spawner_id = "trail_mid_event_spawn_04",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			spawner_id = "trail_mid_event_spawn_04",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "buffed_enemy_spawn_1",
			breed_name = "skaven_dummy_slave",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "buffed_enemy_spawn_2",
			breed_name = "skaven_dummy_slave",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "buffed_enemy_spawn_3",
			breed_name = "skaven_dummy_slave",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_mid_event_04_special",
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_mid_event_04_boss",
			breed_name = {
				"skaven_ratling_gunner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master"
			},
			difficulty_amount = {
				hardest = 2,
				hard = 1,
				harder = 1,
				cataclysm = 2,
				normal = 1
			}
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "trail_mid_event_spawn_04",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "trail_mid_event_spawn_02",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 20
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_mid_event_04_special",
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "trail_mid_event_spawn_04",
			composition_type = "event_extra_spice_large"
		},
		{
			"disable_bots_in_carry_event"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return num_spawned_enemies() < 6
			end
		},
		{
			"control_hordes",
			enable = true
		},
		{
			"flow_event",
			flow_event_name = "trail_mid_event_04_done"
		}
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_intro_disable_pacing_end = {
		{
			"control_hordes",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"control_pacing",
			enable = false
		}
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_end_event_first_wave = {
		{
			"set_master_event_running",
			name = "trail_end_event_first_wave"
		},
		{
			"disable_kick"
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "trail_end_event_first_wave",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_first_wave",
			composition_type = "chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_first_wave",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 4
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "trail_end_event_first_wave",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 4
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "trail_end_event_first_wave",
			composition_type = "event_small_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 4
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_end_event_first_wave_done"
		}
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_end_event_01 = {
		{
			"set_master_event_running",
			name = "trail_end_event_01"
		},
		{
			"disable_kick"
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_1",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_4",
			composition_type = "chaos_berzerkers_medium"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_2",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 8
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_end_event_boss",
			breed_name = {
				"chaos_spawn",
				"chaos_troll",
				"skaven_stormfiend"
			},
			optional_data = {
				enhancements = enhancement_5
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_under_water",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 8
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "trail_end_event_spawner_under_water",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_4",
			composition_type = "chaos_berzerkers_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 8
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_end_event_01_done"
		}
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_end_event_urn_guards_01 = {
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_01",
			composition_type = "chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_01",
			composition_type = "chaos_shields"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_01",
			composition_type = "chaos_raiders_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return num_spawned_enemies() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_end_event_urn_guards_01_done"
		}
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_end_event_urn_guards_02 = {
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_02",
			composition_type = "chaos_berzerkers_medium"
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_02",
			composition_type = "chaos_warriors"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_at_raw",
			spawner_id = "trail_end_event_urn_02",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer",
				"skaven_gutter_runner"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return num_spawned_enemies() < 6
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_end_event_urn_guards_02_done"
		}
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_end_event_urn_guards_03 = {
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_03",
			composition_type = "event_small_fanatics"
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_03",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_03",
			composition_type = "chaos_raiders_medium"
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_03",
			composition_type = "chaos_raiders_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return num_spawned_enemies() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_end_event_urn_guards_03_done"
		}
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_end_event_03 = {
		{
			"set_master_event_running",
			name = "trail_end_event_03"
		},
		{
			"disable_kick"
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_under_water",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 2
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_03",
			composition_type = "event_chaos_extra_spice_medium"
		},
		{
			"delay",
			duration = 3
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return num_spawned_enemies() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_urn_02",
			composition_type = "chaos_berzerkers_medium"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "trail_end_event_last_wave_olesya",
			composition_type = "event_medium_chaos"
		},
		{
			"delay",
			duration = 45
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return num_spawned_enemies() < 20
			end
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_3",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_3",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "trail_end_event_first_wave",
			composition_type = "event_medium_chaos"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer",
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"delay",
			duration = 60
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return num_spawned_enemies() < 20
			end
		},
		{
			"event_horde",
			spawner_id = "trail_end_event_spawner_1",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 6,
			spawner_id = "trail_end_event_first_wave",
			composition_type = "event_medium_chaos"
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 60,
			condition = function (t)
				return num_spawned_enemies() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_end_event_03_done"
		}
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_end_event_constant = {
		{
			"enable_bots_in_carry_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 30
		},
		{
			"set_master_event_running",
			name = "trail_end_event_constant"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "trail_end_event_spawner_under_water",
			composition_type = "event_small_fanatics"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "trail_end_event_spawner_1",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "trail_end_event_spawner_1",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "trail_end_event_spawner_under_water",
			composition_type = "event_medium_chaos"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "trail_end_event_spawner_1",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "trail_end_event_spawner_1",
			composition_type = "chaos_berzerkers_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("chaos_fanatic") < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "trail_end_event_constant_done"
		}
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_end_event_torch_hunter = {
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_vortex_sorcerer",
				"chaos_corruptor_sorcerer",
				"skaven_gutter_runner",
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"chaos_corruptor_sorcerer",
				"chaos_vortex_sorcerer",
				"skaven_pack_master",
				"skaven_gutter_runner"
			},
			difficulty_requirement = HARDEST
		}
	}

	TerrorEventBlueprints.dlc_wizards_trail.trail_enable_pacing_end_run = {
		{
			"control_hordes",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"control_pacing",
			enable = false
		}
	}

	TerrorEventBlueprints.dlc_wizards_tower.wt_disable_pacing = {
		{
			"control_hordes",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	}

	--Mission of Mercy
	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_disable_pacing = {
		{
			"control_pacing",
			enable = true
		},
		{
			"control_hordes",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	}

	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_brewery_a = {
		{
			"set_master_event_running",
			name = "brewery_event"
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "brewery_event",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 8 and count_event_breed("skaven_slave") < 8
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "dwarf_interior_brewery_specials_01",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower"
			}
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "brewery_event",
			composition_type = "event_extra_spice_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 10 and count_event_breed("skaven_slave", "skaven_storm_vermin_commander") < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_brewery_restart"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_brewery_hard_a = {
		{
			"set_master_event_running",
			name = "brewery_event"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "brewery_event",
			composition_type = "event_medium_shield"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "dwarf_interior_brewery_specials_01",
			amount = 1,
			breed_name = {
				"skaven_warpfire_thrower",
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat", "skaven_slave", "skaven_clan_rat_with_shield") < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_brewery_post_pause_start"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_brewery_b = {
		{
			"set_master_event_running",
			name = "brewery_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "brewery_event",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 10 and count_event_breed("skaven_slave", "skaven_storm_vermin_commander") < 10
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "dwarf_interior_brewery_specials_02",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower"
			}
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "brewery_event",
			composition_type = "onslaught_storm_vermin_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_storm_vermin_with_shield") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_brewery_restart"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_brewery_hard_b = {
		{
			"set_master_event_running",
			name = "brewery_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "brewery_event",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"spawn_at_raw",
			spawner_id = "dwarf_interior_brewery_specials_02",
			amount = 1,
			breed_name = {
				"skaven_pack_master",
				"skaven_gutter_runner"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return count_event_breed("skaven_slave", "skaven_storm_vermin_commander") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_brewery_post_pause_start"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_brewery_c = {
		{
			"set_master_event_running",
			name = "brewery_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "brewery_event",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 10 and count_event_breed("skaven_slave", "skaven_storm_vermin_commander") < 5
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "dwarf_interior_brewery_specials_03",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_pack_master",
				"skaven_gutter_runner"
			}
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "brewery_event",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 10 and count_event_breed("skaven_slave", "skaven_storm_vermin_commander") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_brewery_restart"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_brewery_hard_c = {
		{
			"set_master_event_running",
			name = "brewery_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"spawn_at_raw",
			spawner_id = "dwarf_interior_brewery_specials_03",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_ratling_gunner",
				"skaven_gutter_runner"
			}
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "brewery_event_hard_c",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 10 and count_event_breed("skaven_slave") < 12
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "brewery_event_hard_c",
			composition_type = "onslaught_storm_vermin_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return count_event_breed("skaven_storm_vermin_with_shield") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_brewery_post_pause_start"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_brewery_hard_d = {
		{
			"set_master_event_running",
			name = "brewery_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "brewery_event_hard_d",
			composition_type = "plague_monks_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "brewery_event_hard_d",
			composition_type = "onslaught_storm_vermin_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "dwarf_interior_brewery_specials_04",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return count_event_breed("skaven_clan_rat", "skaven_storm_vermin_with_shield") < 5 and count_event_breed("skaven_slave", "skaven_storm_vermin_commander") < 5
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_brewery_post_pause_start"
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_brewery_post_pause_start"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_brewery_finale = {
		{
			"set_master_event_running",
			name = "brewery_event"
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"delay",
			duration = 5
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "brewery_event_finale",
			composition_type = "plague_monks_small"
		},
		{
			"spawn_at_raw",
			spawner_id = "dwarf_interior_brewery_specials_04",
			amount = 1,
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_warpfire_thrower",
				"skaven_gutter_runner"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "brewery_event_finale",
			composition_type = "event_extra_spice_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 45,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 7 and count_event_breed("skaven_slave", "skaven_storm_vermin_commander") < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_brewery_finale_end"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_brewery_loop = {
		{
			"set_master_event_running",
			name = "brewery_event"
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"control_specials",
			enable = true
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "brewery_event",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "brewery_event",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 5 and count_event_breed("skaven_storm_vermin", "skaven_storm_vermin_with_shield") < 5
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_brewery_loop_restart"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_great_hall_tunnels = {
		{
			"set_master_event_running",
			name = "great_hall_spawn"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"control_specials",
			enable = true
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "tunnel_spawn",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 25
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_great_hall_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_great_hall_extra_spice_event = {
		{
			"set_master_event_running",
			name = "great_hall_spawn"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "great_hall_air_vent_spawners",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "tunnel_spawn",
			composition_type = "onslaught_storm_vermin_small"
		},
		{
			"delay",
			duration = 5
		},

		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_great_hall_extra_spice_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_great_hall_tunnel_A_extra = {
		{
			"set_master_event_running",
			name = "great_hall_spawn"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "tunnel_A_extra_spawn",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "tunnel_A_extra_spawn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "tunnel_A_extra_spawn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 4
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "tunnel_A_extra_spawn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = khorne_buff_spawn_function,
				max_health_modifier = 1.5,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 15,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "tunnel_A_extra_spawn",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "tunnel_A_extra_spawn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "tunnel_A_extra_spawn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = khorne_buff_spawn_function,
				max_health_modifier = 1.5,
				size_variation_range = {
					1.2,
					1.25
				}
			},
			min_distance = 15,
			max_distance = 16,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "tunnel_A_extra_spawn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "tunnel_A_extra_spawn",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_great_hall_upstairs_tunnel_extra_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_great_hall_tunnel_B_extra = {
		{
			"set_master_event_running",
			name = "great_hall_spawn"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_B_extra_spawn",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_B_extra_spawn",
			composition_type = "plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_B_extra_spawn",
			composition_type = "plague_monks_medium"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "skaven_poison_wind_globadier",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function,
			},
			min_distance = 20,
			max_distance = 30,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 8
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "skaven_poison_wind_globadier",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function,
			},
			min_distance = 20,
			max_distance = 30,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 8
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "skaven_poison_wind_globadier",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function,
			},
			min_distance = 20,
			max_distance = 30,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 8
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_B_extra_spawn",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 8
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_B_extra_spawn",
			composition_type = "plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_B_extra_spawn",
			composition_type = "plague_monks_medium"
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "skaven_poison_wind_globadier",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function,
			},
			min_distance = 20,
			max_distance = 30,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 8
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "skaven_poison_wind_globadier",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function,
			},
			min_distance = 20,
			max_distance = 30,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 8
		},
		{
			"spawn_around_origin_unit",
			spawn_counter_category = "cursed_chest_enemies",
			breed_name = "skaven_poison_wind_globadier",
			optional_data = {
				spawned_func = tzeentch_buff_spawn_function,
			},
			min_distance = 20,
			max_distance = 30,
			pre_spawn_unit_func = cursed_chest_enemy_spawn_decal_func,
			post_spawn_unit_func = cursed_chest_enemy_despawn_decal_func,
			spawn_delay = 2,
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 10 and count_event_breed("skaven_slave") < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_great_hall_back_tunnel_extra_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_interior.dwarf_interior_great_hall_tunnel_C_extra = {
		{
			"set_master_event_running",
			name = "great_hall_spawn"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"enable_bots_in_carry_event"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stingers_plague_monk"
		},
		{
			"delay",
			duration = 2
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stingers_plague_monk"
		},
		{
			"delay",
			duration = 2
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stingers_plague_monk"
		},
		{
			"delay",
			duration = 2
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stingers_plague_monk"
		},
		{
			"delay",
			duration = 2
		},
		{
			"continue_when",
			duration = 1,
			condition = function (t)
				return activate_darkness_180()
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_C_extra_spawn",
			composition_type = "event_medium_shield"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_B_extra_spawn",
			composition_type = "plague_monks_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_B_extra_spawn",
			composition_type = "plague_monks_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_B_extra_spawn",
			composition_type = "plague_monks_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_B_extra_spawn",
			composition_type = "plague_monks_medium"
		},
		{
			"delay",
			duration = 15
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return count_event_breed("skaven_clan_rat") < 10 and count_event_breed("skaven_slave") < 10
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_interior_great_hall_downstairs_tunnel_extra_done"
		}
	}

	--Grudge served cold
	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_courtyard_event_start = {
		{
			"control_hordes",
			enable = false
		},
		{
			"control_specials",
			enable = true
		}
	}
	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_disable_pacing = {
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_courtyard_event_01 = {
		{
			"control_hordes",
			enable = false
		},
		{
			"control_specials",
			enable = true
		},
		{
			"set_master_event_running",
			name = "dwarf_exterior_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard",
			composition_type = "plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "buffed_middle_cold",
			breed_name = "skaven_storm_vermin",
			optional_data ={
				spawned_func = slaanesh_buff_spawn_function,
				max_health_modifier = 4,
				size_variation_range = {
					1.35,
					1.4
				}
			}
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard_hidden",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard",
			composition_type = "plague_monks_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard_hidden",
			composition_type = "storm_vermin_small"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "event_military_courtyard_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_courtyard_event_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_courtyard_event_02 = {
		{
			"control_hordes",
			enable = false
		},
		{
			"control_specials",
			enable = true
		},
		{
			"set_master_event_running",
			name = "dwarf_exterior_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_chaos_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_maulers_medium"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "onslaught_storm_vermin_shields_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"spawn_at_raw",
			spawner_id = "buffed_middle_cold",
			breed_name = "chaos_warrior",
			optional_data ={
				spawned_func = khorne_buff_spawn_function,
				max_health_modifier = 1.5,
				size_variation_range = {
					1.2,
					1.25
				}
			}
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard_hidden",
			composition_type = "chaos_warriors"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard_hidden",
			composition_type = "event_large_chaos"
		},
		{
			"delay",
			duration = 10
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "courtyard_hidden",
			composition_type = "event_military_courtyard_plague_monks"
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "courtyard_hidden",
			composition_type = "event_maulers_medium"
		},
		{
			"delay",
			duration = 5
		},
		{
			"event_horde",
			limit_spawners = 8,
			spawner_id = "courtyard_hidden",
			composition_type = "chaos_warriors"
		},
		{
			"delay",
			duration = 10
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_courtyard_event_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_courtyard_event_end = {
		{
			"control_pacing",
			enable = true
		},
		{
			"control_specials",
			enable = true
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_courtyard_event_specials_01 = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"continue_when",
			duration = 100,
			condition = function (t)
				return count_event_breed("skaven_plague_monk") < 2
			end
		},
		{
			"spawn_special",
			breed_name = "skaven_poison_wind_globadier",
			amount = 2
		},
		{
			"spawn_special",
			amount = 1,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"spawn_special",
			breed_name = "skaven_ratling_gunner",
			amount = 1
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (t)
				return count_event_breed("skaven_poison_wind_globadier") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_courtyard_event_specials_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_courtyard_event_specials_02 = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"continue_when",
			duration = 100,
			condition = function (t)
				return count_event_breed("skaven_plague_monk") < 2
			end
		},
		{
			"spawn_special",
			breed_name = "chaos_vortex_sorcerer",
			amount = 1
		},
		{
			"spawn_special",
			breed_name = "chaos_corruptor_sorcerer",
			amount = 1
		},
		{
			"spawn_special",
			amount = 2,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_poison_wind_globadier"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (t)
				return count_event_breed("chaos_corruptor_sorcerer") < 1 and count_event_breed("chaos_vortex_sorcerer") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_courtyard_event_specials_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_courtyard_event_specials_03 = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_courtyard"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"continue_when",
			duration = 100,
			condition = function (t)
				return count_event_breed("skaven_plague_monk") < 2
			end
		},
		{
			"spawn_special",
			breed_name = "chaos_vortex_sorcerer",
			amount = 1,
		},
		{
			"spawn_special",
			breed_name = "skaven_ratling_gunner",
			amount = 2
		},
		{
			"spawn_special",
			breed_name = "skaven_poison_wind_globadier",
			amount = 1
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (t)
				return count_event_breed("chaos_vortex_sorcerer") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_courtyard_event_specials_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_courtyard_event_specials_04 = {
		{
			"continue_when",
			duration = 100,
			condition = function (t)
				return count_event_breed("skaven_plague_monk") < 2
			end
		},
		{
			"spawn_special",
			breed_name = "skaven_warpfire_thrower",
			amount = 1
		},
		{
			"spawn_special",
			breed_name = "skaven_pack_master",
			amount = 1
		},
		{
			"spawn_special",
			amount = 2,
			breed_name = {
				"chaos_vortex_sorcerer",
				"skaven_ratling_gunner"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (t)
				return count_event_breed("skaven_warpfire_thrower") < 1 and count_event_breed("skaven_pack_master") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_courtyard_event_specials_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_courtyard_event_specials_05 = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_courtyard"
		},
		{
			"continue_when",
			duration = 100,
			condition = function (t)
				return count_event_breed("skaven_plague_monk") < 2
			end
		},
		{
			"spawn_special",
			breed_name = "skaven_ratling_gunner",
			amount = 1
		},
		{
			"spawn_special",
			breed_name = "skaven_poison_wind_globadier",
			amount = 1
		},
		{
			"spawn_special",
			amount = 2,
			breed_name = {
				"skaven_gutter_runner",
				"skaven_pack_master"
			}
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 100,
			condition = function (t)
				return count_event_breed("skaven_ratling_gunner") < 1 and count_event_breed("skaven_poison_wind_globadier") < 1
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_courtyard_event_specials_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_water_boss = {
		{
			"spawn_at_raw",
			spawner_id = "lake_manual",
			breed_name = "skaven_rat_ogre",
			enhancements = relentless
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_temple_guards = {
		{
			"disable_kick"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards02",
			breed_name = "chaos_marauder"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards05",
			breed_name = "chaos_marauder_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards06",
			breed_name = "chaos_marauder"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards07",
			breed_name = "chaos_marauder_with_shield"
		},
		{
			"spawn_at_raw",
			spawner_id = "temple_guards09",
			breed_name = "chaos_warrior",
			optional_data = {
				spawned_func = khorne_buff_spawn_function,
				size_variation_range = {
				    1.2,
				    1.25
				}
			}
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_chamber_guards = {
		{
			"spawn_at_raw",
			spawner_id = "chamber_guards01",
			breed_name = "skaven_storm_vermin"
		},
		{
			"spawn_at_raw",
			spawner_id = "chamber_guards02",
			breed_name = "skaven_storm_vermin"
		},
		{
			"spawn_at_raw",
			spawner_id = "chamber_guards03",
			breed_name = "skaven_storm_vermin"
		},
		{
			"spawn_at_raw",
			spawner_id = "chamber_guards04",
			breed_name = "skaven_storm_vermin"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_escape_guards = {
		{
			"spawn_at_raw",
			spawner_id = "escape_guards01",
			breed_name = "skaven_storm_vermin"
		},
		{
			"spawn_at_raw",
			spawner_id = "escape_guards02",
			breed_name = "skaven_storm_vermin",
			optional_date = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "escape_guards03",
			breed_name = "skaven_storm_vermin"
		},
		{
			"spawn_at_raw",
			spawner_id = "rat_ogre_cold_end",
			breed_name = "skaven_rat_ogre",
			optional_data = {
			    enhancements = enhancement_1
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "escape_guards04",
			breed_name = "skaven_storm_vermin",
			optional_date = {
				spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "escape_guards05",
			breed_name = "skaven_storm_vermin"
		},
		{
			"spawn_at_raw",
			spawner_id = "escape_guards06",
			breed_name = "skaven_storm_vermin"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_end_event_guards = {
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_01",
			breed_name = "skaven_storm_vermin"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_01b",
			breed_name = "skaven_storm_vermin"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_02",
			breed_name = "skaven_storm_vermin",
			optional_date = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_02b",
			breed_name = "skaven_storm_vermin"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_03",
			breed_name = "skaven_storm_vermin"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_03b",
			breed_name = "skaven_storm_vermin"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_04",
			breed_name = "skaven_storm_vermin",
			optional_date = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_04b",
			breed_name = "skaven_storm_vermin"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_05",
			breed_name = "skaven_storm_vermin"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_05b",
			breed_name = "skaven_storm_vermin"
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_06",
			breed_name = "skaven_storm_vermin",
			optional_date = {
				spawned_func = tzeentch_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "chain_guard_06b",
			breed_name = "skaven_storm_vermin"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_end_event_survival_01 = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_end_event_survival"
		},
		dwarf_exterior_disable_pacing = {
			{
				"control_pacing",
				enable = false,
			},
			{
				"control_specials",
				enable = true,
			},
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_survival",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 14
		},
		{
			"spawn_at_raw",
			spawner_id = "underground_spawn_2",
			breed_name = "skaven_rat_ogre",
			optional_data = {
			    enhancements = enhancement_1
			}
		},
		{
			"event_horde",
			spawner_id = "end_event_survival",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 30
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_end_event_survival_01_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_end_event_survival_02 = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 4,
			spawner_id = "end_event_survival",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_survival",
			composition_type = "event_extra_spice_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_survival",
			composition_type = "onslaught_plague_monks_small"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_end_event_survival_02_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_end_event_survival_end = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_end_event_survival"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_survival",
			composition_type = "event_extra_spice_medium"
		},
		{
			"delay",
			duration = 25
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "end_event_survival",
			composition_type = "event_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 15
			end
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_end_event_survival_end_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_exterior.dwarf_exterior_end_event_invasion = {
		{
			"set_master_event_running",
			name = "dwarf_exterior_end_event_invasion"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_invaders",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_invaders",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "underground_spawn_1",
			breed_name = "skaven_storm_vermin",
			optional_data = {
			    spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "underground_spawn_2",
			breed_name = "skaven_storm_vermin",
			optional_data = {
			    spawned_func = nurgle_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 25
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_invaders",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_invaders",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "tunnel_invaders",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = 20
		},
		{
			"continue_when",
			duration = 40,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"delay",
			duration = 5
		},
		{
			"flow_event",
			flow_event_name = "dwarf_exterior_end_event_invasion_done"
		}
	}

	--Khazukan Kazakit-ha!
	TerrorEventBlueprints.dlc_dwarf_beacons.dwarf_beacons_gate_part1 = {
		{
			"set_master_event_running",
			name = "beacons_gate"
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"control_specials",
			enable = false
		},
		{
			"event_horde",
			spawner_id = "gate_currentside",
			composition_type = "event_large"
		},
		{
			"spawn_at_raw",
			spawner_id = "middle_ogre_beacons",
			breed_name = "skaven_rat_ogre",
			optional_data = {
				enhancements = relentless,
				max_health_modifier = 0.6
			}
		},
		{
			"event_horde",
			spawner_id = "gate_currentside",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 30
		},
		{
			"continue_when",
			duration = 20,
			condition = function (t)
				return spawned_during_event() < 20
			end
		}
	}

	TerrorEventBlueprints.dlc_dwarf_beacons.dwarf_beacons_gate_part2 = {
		{
			"set_master_event_running",
			name = "beacons_gate"
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"control_specials",
			enable = true
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "gate_otherside",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			spawner_id = "gate_otherside",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "paratrooper_middle",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 20
			end
		},
		{
			"control_hordes",
			enable = true
		},
	}

	TerrorEventBlueprints.dlc_dwarf_beacons.dwarf_beacons_gate_part3 = {
		{
			"set_master_event_running",
			name = "beacons_gate"
		},
		{
			"control_hordes",
			enable = false
		},
		{
			"control_specials",
			enable = true
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "gate_currentside",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = 15
		},
		{
			"event_horde",
			spawner_id = "gate_otherside",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "paratrooper_middle",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 20
		},
		{
			"spawn_at_raw",
			spawner_id = "paratrooper_middle",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"event_horde",
			spawner_id = "gate_otherside",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 10
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "gate_currentside",
			composition_type = "event_large"
		},
		{
			"event_horde",
			spawner_id = "gate_otherside",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = 25
		},
		{
			"event_horde",
			spawner_id = "gate_otherside",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"spawn_at_raw",
			spawner_id = "paratrooper_middle",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"delay",
			duration = 30
		},
		{
			"spawn_at_raw",
			spawner_id = "paratrooper_middle",
			breed_name = "skaven_storm_vermin",
			optional_data = {
				spawned_func = slaanesh_buff_spawn_function
			}
		},
		{
			"event_horde",
			spawner_id = "gate_otherside",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			spawner_id = "gate_otherside",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"control_hordes",
			enable = true
		},
	}

	TerrorEventBlueprints.dlc_dwarf_beacons.dwarf_beacons_beacon = {
		{
			"set_master_event_running",
			name = "beacons_beacon"
		},
		{
			"control_pacing",
			enable = false
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"spawn",
			{
				2,
				3
			},
			breed_name = "skaven_gutter_runner"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"spawn",
			{
				2,
				3
			},
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"event_horde",
			spawner_id = "beacon",
			composition_type = "event_small"
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"spawn",
			{
				2,
				3
			},
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"spawn",
			{
				3
			},
			breed_name = "skaven_ratling_gunner"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				5,
				6
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"spawn",
			{
				2
			},
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"spawn",
			{
				2
			},
			breed_name = "skaven_pack_master"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"spawn",
			{
				2
			},
			breed_name = "skaven_gutter_runner"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"spawn",
			{
				2
			},
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"spawn",
			{
				2
			},
			breed_name = "skaven_pack_master"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"spawn",
			{
				2,
				3
			},
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"spawn",
			{
				1,
				2
			},
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"spawn",
			{
				2
			},
			breed_name = "skaven_ratling_gunner"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				5,
				6
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"spawn",
			{
				2
			},
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"spawn",
			{
				2
			},
			breed_name = "skaven_pack_master"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"spawn",
			{
				1,
				2
			},
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"spawn",
			{
				2
			},
			breed_name = "skaven_ratling_gunner"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				5,
				6
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"spawn",
			{
				2,
				3
			},
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"spawn",
			{
				3
			},
			breed_name = "skaven_ratling_gunner"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				5,
				6
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"spawn",
			{
				3
			},
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"spawn",
			{
				2
			},
			breed_name = "skaven_pack_master"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_white_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"spawn",
			{
				2,
				3
			},
			breed_name = "skaven_pack_master"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"spawn",
			{
				3
			},
			breed_name = "skaven_ratling_gunner"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"event_horde",
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				5,
				6
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"spawn",
			{
				2
			},
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"spawn",
			{
				2
			},
			breed_name = "skaven_pack_master"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				9,
				11
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
		{
			"spawn",
			{
				2
			},
			breed_name = "skaven_poison_wind_globadier"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"spawn",
			{
				2
			},
			breed_name = "skaven_pack_master"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_plague_monks_medium"
		},
		{
			"event_horde",
			limit_spawners = 2,
			spawner_id = "beacon",
			composition_type = "onslaught_storm_vermin_medium"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"continue_when",
			duration = 30,
			condition = function (t)
				return spawned_during_event() < 25
			end
		},
	}

	TerrorEventBlueprints.dlc_dwarf_beacons.dwarf_beacons_skaven_horde = {
		{
			"set_master_event_running",
			name = "beacons_skaven_horde"
		},
		{
			"play_stinger",
			stinger_name = "enemy_horde_stinger"
		},
		{
			"set_freeze_condition",
			max_active_enemies = 100
		},
		{
			"event_horde",
			spawner_id = "beacon",
			composition_type = "event_large"
		},
		{
			"spawn_at_raw",
			spawner_id = "manual_special_spawners",
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = HARD
		},
		{
			"spawn_at_raw",
			spawner_id = "manual_special_spawners",
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = HARDER
		},
		{
			"delay",
			duration = 8
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "beacon",
			composition_type = "event_extra_spice_medium",
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 8,
			difficulty_requirement = HARDEST
		},
		{
			"continue_when",
			duration = 120,
			condition = function (t)
				return count_event_breed("skaven_slave") < 10 and count_event_breed("skaven_clan_rat") < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "beacon",
			composition_type = "event_extra_spice_medium",
			difficulty_requirement = HARDER
		},
		{
			"spawn_at_raw",
			spawner_id = "manual_special_spawners",
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = HARD
		},
		{
			"spawn_at_raw",
			spawner_id = "manual_special_spawners",
			breed_name = {
				"skaven_poison_wind_globadier",
				"skaven_pack_master",
				"skaven_gutter_runner",
				"skaven_ratling_gunner",
				"skaven_warpfire_thrower"
			},
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 8,
			difficulty_requirement = HARDER
		},
		{
			"continue_when",
			duration = 120,
			condition = function (t)
				return count_event_breed("skaven_slave") < 10 and count_event_breed("skaven_clan_rat") < 10
			end
		},
		{
			"event_horde",
			limit_spawners = 3,
			spawner_id = "beacon",
			composition_type = "plague_monks_small",
			difficulty_requirement = HARDEST
		},
		{
			"delay",
			duration = 10,
			difficulty_requirement = HARDEST
		},
		{
			"flow_event",
			flow_event_name = "beacons_skaven_horde_done"
		}
	}

	TerrorEventBlueprints.dlc_dwarf_beacons.dwarf_beacons_barrier = {
		{
			"set_master_event_running",
			name = "beacons_barrier"
		},
		{
			"control_pacing",
			enable = true
		},
		{
			"spawn_at_raw",
			spawner_id = "beacon_ogre_end",
			breed_name = "skaven_rat_ogre"
		},
		{
			"event_horde",
			spawner_id = "beacon_barrier",
			composition_type = "event_small"
		},
		{
			"delay",
			duration = {
				3,
				4
			}
		},
		{
			"spawn_at_raw",
			spawner_id = "beacon_ogre_end",
			breed_name = "skaven_rat_ogre"
		}
	}

	--Termite
	TerrorEventBlueprints.dlc_termite_1.termite_01_end_event_trickle = {
		{
			"set_master_event_running",
			name = "termite_01_end_event_trickle",
		},
		{
			"set_freeze_condition",
			max_active_enemies = 50,
		},
		{
			"event_horde",
			composition_type = "event_large_skaven_dutch",
			spawner_id = "end_event_trickle",
		},
		{
			"delay",
			duration = 60,
		},
		{
			"continue_when",
			duration = 10,
			condition = function (t)
				return spawned_during_event() < 10
			end
		},
		{
			"delay",
			duration = 2,
		},
		{
			"flow_event",
			flow_event_name = "termite_01_end_event_trickle_done",
		},
	}

	create_weights()

	mod:enable_all_hooks()

	mutator.active = true
end

mutator.stop = function()

	TerrorEventBlueprints = mutator.OriginalTerrorEventBlueprints
	HordeCompositions = mutator.OriginalHordeCompositions
	PackSpawningSettings = mutator.OriginalPackSpawningSettings
	PacingSettings.default = mutator.OriginalPacingSettingsDefault
	PacingSettings.chaos = mutator.OriginalPacingSettingsChaos
	SpecialsSettings = mutator.OriginalSpecialsSettings
	BossSettings = mutator.OriginalBossSettings
	RecycleSettings.push_horde_if_num_alive_grunts_above = mutator.OriginalRecycleSettings.push_horde_if_num_alive_grunts_above
	RecycleSettings.max_grunts = mutator.OriginalRecycleSettings.max_grunts

	BeastmenStandardTemplates.healing_standard.radius = 15
	UtilityConsiderations.beastmen_place_standard.distance_to_target.max_value = 10
	BuffTemplates.healing_standard.buffs = mutator.OriginalBeastmenBannerBuff

	BreedPacks.skaven_beastmen = mutator.OriginalBreedPacks.skaven_beastmen
	BreedPacks.chaos_beastmen = mutator.OriginalBreedPacks.chaos_beastmen
	BreedPacks.beastmen = mutator.OriginalBreedPacks.beastmen
	BreedPacks.beastmen_elites = mutator.OriginalBreedPacks.beastmen_elites
	BreedPacks.beastmen_light = mutator.OriginalBreedPacks.beastmen_light
	BreedPacks.standard = mutator.OriginalBreedPacks.standard
	BreedPacks.standard_no_elites = mutator.OriginalBreedPacks.standard_no_elites
	BreedPacks.skaven = mutator.OriginalBreedPacks.skaven
	BreedPacks.shield_rats = mutator.OriginalBreedPacks.shield_rats
	BreedPacks.plague_monks = mutator.OriginalBreedPacks.plague_monks
	BreedPacks.marauders_shields = mutator.OriginalBreedPacks.marauders_shields

	PackSpawningSettings.default.area_density_coefficient = mutator.OriginalPackSpawningSettings.default.area_density_coefficient
	PackSpawningSettings.default_light.area_density_coefficient = mutator.OriginalPackSpawningSettings.default_light.area_density_coefficient
	PackSpawningSettings.skaven.area_density_coefficient = mutator.OriginalPackSpawningSettings.skaven.area_density_coefficient
	PackSpawningSettings.skaven_light.area_density_coefficient = mutator.OriginalPackSpawningSettings.skaven_light.area_density_coefficient
	PackSpawningSettings.chaos.area_density_coefficient = mutator.OriginalPackSpawningSettings.chaos.area_density_coefficient
	PackSpawningSettings.chaos_light.area_density_coefficient = mutator.OriginalPackSpawningSettings.chaos_light.area_density_coefficient
	PackSpawningSettings.beastmen.area_density_coefficient = mutator.OriginalPackSpawningSettings.beastmen.area_density_coefficient
	PackSpawningSettings.skaven_beastmen.area_density_coefficient = mutator.OriginalPackSpawningSettings.skaven_beastmen.area_density_coefficient
	PackSpawningSettings.chaos_beastmen.area_density_coefficient = mutator.OriginalPackSpawningSettings.chaos_beastmen.area_density_coefficient
	PackSpawningSettings.beastmen_light.area_density_coefficient = mutator.OriginalPackSpawningSettings.beastmen_light.area_density_coefficient
	
	PackSpawningSettings.default.roaming_set.breed_packs_override = mutator.OriginalPackSpawningSettings.default.roaming_set.breed_packs_override
	PackSpawningSettings.default_light.roaming_set.breed_packs_override = mutator.OriginalPackSpawningSettings.default_light.roaming_set.breed_packs_override
	PackSpawningSettings.skaven.roaming_set.breed_packs_override = mutator.OriginalPackSpawningSettings.skaven.roaming_set.breed_packs_override
	PackSpawningSettings.skaven_light.roaming_set.breed_packs_override = mutator.OriginalPackSpawningSettings.skaven_light.roaming_set.breed_packs_override
	PackSpawningSettings.chaos.roaming_set.breed_packs_override = mutator.OriginalPackSpawningSettings.chaos.roaming_set.breed_packs_override
	PackSpawningSettings.chaos_light.roaming_set.breed_packs_override = mutator.OriginalPackSpawningSettings.chaos_light.roaming_set.breed_packs_override
	PackSpawningSettings.beastmen.roaming_set.breed_packs_override = mutator.OriginalPackSpawningSettings.beastmen.roaming_set.breed_packs_override
	PackSpawningSettings.skaven_beastmen.roaming_set.breed_packs_override = mutator.OriginalPackSpawningSettings.skaven_beastmen.roaming_set.breed_packs_override
	PackSpawningSettings.chaos_beastmen.roaming_set.breed_packs_override = mutator.OriginalPackSpawningSettings.chaos_beastmen.roaming_set.breed_packs_override
	PackSpawningSettings.beastmen_light.roaming_set.breed_packs_override = mutator.OriginalPackSpawningSettings.beastmen_light.roaming_set.breed_packs_override
	
	PackSpawningSettings.default.difficulty_overrides = mutator.OriginalPackSpawningSettings.default.difficulty_overrides
	PackSpawningSettings.skaven.difficulty_overrides = mutator.OriginalPackSpawningSettings.skaven.difficulty_overrides
	PackSpawningSettings.skaven_light.difficulty_overrides = mutator.OriginalPackSpawningSettings.skaven_light.difficulty_overrides
	PackSpawningSettings.chaos.difficulty_overrides = mutator.OriginalPackSpawningSettings.chaos.difficulty_overrides
	PackSpawningSettings.beastmen.difficulty_overrides = mutator.OriginalPackSpawningSettings.beastmen.difficulty_overrides
	PackSpawningSettings.skaven_beastmen.difficulty_overrides = mutator.OriginalPackSpawningSettings.skaven_beastmen.difficulty_overrides
	PackSpawningSettings.chaos_beastmen.difficulty_overrides = mutator.OriginalPackSpawningSettings.chaos_beastmen.difficulty_overrides

	PacingSettings.default.peak_fade_threshold = mutator.OriginalPacingSettingsDefault.peak_fade_threshold
	PacingSettings.default.peak_intensity_threshold = mutator.OriginalPacingSettingsDefault.peak_intensity_threshold
	PacingSettings.default.sustain_peak_duration = mutator.OriginalPacingSettingsDefault.sustain_peak_duration
	PacingSettings.default.relax_duration = mutator.OriginalPacingSettingsDefault.relax_duration
	PacingSettings.default.horde_frequency = mutator.OriginalPacingSettingsDefault.horde_frequency
	PacingSettings.default.multiple_horde_frequency = mutator.OriginalPacingSettingsDefault.multiple_horde_frequency
	PacingSettings.default.max_delay_until_next_horde = mutator.OriginalPacingSettingsDefault.max_delay_until_next_horde
	PacingSettings.default.horde_startup_time = mutator.OriginalPacingSettingsDefault.horde_startup_time

	PacingSettings.default.mini_patrol.only_spawn_above_intensity = mutator.OriginalPacingSettingsDefault.mini_patrol.only_spawn_above_intensity
	PacingSettings.default.mini_patrol.only_spawn_below_intensity = mutator.OriginalPacingSettingsDefault.mini_patrol.only_spawn_below_intensity
	PacingSettings.default.mini_patrol.frequency = mutator.OriginalPacingSettingsDefault.mini_patrol.frequency
	PacingSettings.default.difficulty_overrides = mutator.OriginalPacingSettingsDefault.difficulty_overrides

	PacingSettings.chaos.peak_fade_threshold = mutator.OriginalPacingSettingsChaos.peak_fade_threshold
	PacingSettings.chaos.peak_intensity_threshold = mutator.OriginalPacingSettingsChaos.peak_intensity_threshold
	PacingSettings.chaos.sustain_peak_duration = mutator.OriginalPacingSettingsChaos.sustain_peak_duration
	PacingSettings.chaos.relax_duration = mutator.OriginalPacingSettingsChaos.relax_duration
	PacingSettings.chaos.horde_frequency = mutator.OriginalPacingSettingsChaos.horde_frequency
	PacingSettings.chaos.multiple_horde_frequency = mutator.OriginalPacingSettingsChaos.multiple_horde_frequency
	PacingSettings.chaos.max_delay_until_next_horde = mutator.OriginalPacingSettingsChaos.max_delay_until_next_horde
	PacingSettings.chaos.horde_startup_time = mutator.OriginalPacingSettingsChaos.horde_startup_time
	PacingSettings.chaos.multiple_hordes = mutator.OriginalPacingSettingsChaos.multiple_hordes

	PacingSettings.chaos.mini_patrol.only_spawn_above_intensity = mutator.OriginalPacingSettingsChaos.mini_patrol.only_spawn_above_intensity
	PacingSettings.chaos.mini_patrol.only_spawn_below_intensity = mutator.OriginalPacingSettingsChaos.mini_patrol.only_spawn_below_intensity
	PacingSettings.chaos.mini_patrol.frequency = mutator.OriginalPacingSettingsChaos.mini_patrol.frequency
	PacingSettings.chaos.difficulty_overrides = mutator.OriginalPacingSettingsChaos.difficulty_overrides
	
	PacingSettings.beastmen.peak_fade_threshold = mutator.OriginalPacingSettingsBeastmen.peak_fade_threshold
	PacingSettings.beastmen.peak_intensity_threshold = mutator.OriginalPacingSettingsBeastmen.peak_intensity_threshold
	PacingSettings.beastmen.sustain_peak_duration = mutator.OriginalPacingSettingsBeastmen.sustain_peak_duration
	PacingSettings.beastmen.relax_duration = mutator.OriginalPacingSettingsBeastmen.relax_duration
	PacingSettings.beastmen.horde_frequency = mutator.OriginalPacingSettingsBeastmen.horde_frequency
	PacingSettings.beastmen.multiple_horde_frequency = mutator.OriginalPacingSettingsBeastmen.multiple_horde_frequency
	PacingSettings.beastmen.max_delay_until_next_horde = mutator.OriginalPacingSettingsBeastmen.max_delay_until_next_horde
	PacingSettings.beastmen.horde_startup_time = mutator.OriginalPacingSettingsBeastmen.horde_startup_time

	PacingSettings.beastmen.mini_patrol.only_spawn_above_intensity = mutator.OriginalPacingSettingsBeastmen.mini_patrol.only_spawn_above_intensity
	PacingSettings.beastmen.mini_patrol.only_spawn_below_intensity = mutator.OriginalPacingSettingsBeastmen.mini_patrol.only_spawn_below_intensity
	PacingSettings.beastmen.mini_patrol.frequency = mutator.OriginalPacingSettingsBeastmen.mini_patrol.frequency
	PacingSettings.beastmen.difficulty_overrides = mutator.OriginalPacingSettingsBeastmen.difficulty_overrides

	HordeCompositionsPacing.small = mutator.OriginalHordeCompositionsPacing.small
	HordeCompositionsPacing.medium = mutator.OriginalHordeCompositionsPacing.medium
	HordeCompositionsPacing.large = mutator.OriginalHordeCompositionsPacing.large
	HordeCompositionsPacing.huge = mutator.OriginalHordeCompositionsPacing.huge
	HordeCompositionsPacing.huge_shields = mutator.OriginalHordeCompositionsPacing.huge_shields
	HordeCompositionsPacing.huge_armor = mutator.OriginalHordeCompositionsPacing.huge_armor
	HordeCompositionsPacing.huge_berzerker = mutator.OriginalHordeCompositionsPacing.huge_berzerker
	HordeCompositionsPacing.chaos_medium = mutator.OriginalHordeCompositionsPacing.chaos_medium
	HordeCompositionsPacing.chaos_large = mutator.OriginalHordeCompositionsPacing.chaos_large
	HordeCompositionsPacing.chaos_huge = mutator.OriginalHordeCompositionsPacing.chaos_huge
	HordeCompositionsPacing.chaos_huge_shields = mutator.OriginalHordeCompositionsPacing.chaos_huge_shields
	HordeCompositionsPacing.chaos_huge_armor = mutator.OriginalHordeCompositionsPacing.chaos_huge_armor
	HordeCompositionsPacing.chaos_huge_berzerker = mutator.OriginalHordeCompositionsPacing.chaos_huge_berzerker
	HordeCompositionsPacing.beastmen_medium = mutator.OriginalHordeCompositionsPacing.beastmen_medium
	HordeCompositionsPacing.beastmen_large = mutator.OriginalHordeCompositionsPacing.beastmen_large
	HordeCompositionsPacing.beastmen_huge = mutator.OriginalHordeCompositionsPacing.beastmen_huge
	HordeCompositionsPacing.beastmen_huge_armor = mutator.OriginalHordeCompositionsPacing.beastmen_huge_armor

	SpecialsSettings.default.max_specials = mutator.OriginalSpecialsSettings.default.max_specials
	SpecialsSettings.default_light.max_specials = mutator.OriginalSpecialsSettings.default_light.max_specials
	SpecialsSettings.skaven.max_specials = mutator.OriginalSpecialsSettings.skaven.max_specials
	SpecialsSettings.skaven_light.max_specials = mutator.OriginalSpecialsSettings.skaven_light.max_specials
	SpecialsSettings.chaos.max_specials = mutator.OriginalSpecialsSettings.chaos.max_specials
	SpecialsSettings.chaos_light.max_specials = mutator.OriginalSpecialsSettings.chaos_light.max_specials
	SpecialsSettings.beastmen.max_specials = mutator.OriginalSpecialsSettings.beastmen.max_specials
	SpecialsSettings.skaven_beastmen.max_specials = mutator.OriginalSpecialsSettings.skaven_beastmen.max_specials
	SpecialsSettings.chaos_beastmen.max_specials = mutator.OriginalSpecialsSettings.chaos_beastmen.max_specials
	PacingSettings.default.delay_specials_threat_value = mutator.OriginalPacingSettingsDefault.delay_specials_threat_value
	PacingSettings.chaos.delay_specials_threat_value = mutator.OriginalPacingSettingsChaos.delay_specials_threat_value
	PacingSettings.beastmen.delay_specials_threat_value = mutator.OriginalPacingSettingsBeastmen.delay_specials_threat_value
	SpecialsSettings.default.methods.specials_by_slots = mutator.OriginalSpecialsSettings.default.methods.specials_by_slots
	SpecialsSettings.default_light.methods.specials_by_slots = mutator.OriginalSpecialsSettings.default_light.methods.specials_by_slots
	SpecialsSettings.skaven.methods.specials_by_slots = mutator.OriginalSpecialsSettings.skaven.methods.specials_by_slots
	SpecialsSettings.skaven_light.methods.specials_by_slots = mutator.OriginalSpecialsSettings.skaven_light.methods.specials_by_slots
	SpecialsSettings.chaos.methods.specials_by_slots = mutator.OriginalSpecialsSettings.chaos.methods.specials_by_slots
	SpecialsSettings.chaos_light.methods.specials_by_slots = mutator.OriginalSpecialsSettings.chaos_light.methods.specials_by_slots
	SpecialsSettings.beastmen.methods.specials_by_slots = mutator.OriginalSpecialsSettings.beastmen.methods.specials_by_slots
	SpecialsSettings.skaven_beastmen.methods.specials_by_slots = mutator.OriginalSpecialsSettings.skaven_beastmen.methods.specials_by_slots
	SpecialsSettings.chaos_beastmen.methods.specials_by_slots = mutator.OriginalSpecialsSettings.chaos_beastmen.methods.specials_by_slots

	SpecialsSettings.default.difficulty_overrides = mutator.OriginalSpecialsSettings.default.difficulty_overrides
	SpecialsSettings.default_light.difficulty_overrides = mutator.OriginalSpecialsSettings.default_light.difficulty_overrides
	SpecialsSettings.skaven.difficulty_overrides = mutator.OriginalSpecialsSettings.skaven.difficulty_overrides
	SpecialsSettings.skaven_light.difficulty_overrides = mutator.OriginalSpecialsSettings.skaven_light.difficulty_overrides
	SpecialsSettings.chaos.difficulty_overrides = mutator.OriginalSpecialsSettings.chaos.difficulty_overrides
	SpecialsSettings.chaos_light.difficulty_overrides = mutator.OriginalSpecialsSettings.chaos_light.difficulty_overrides
	SpecialsSettings.beastmen.difficulty_overrides = mutator.OriginalSpecialsSettings.beastmen.difficulty_overrides
	SpecialsSettings.skaven_beastmen.difficulty_overrides = mutator.OriginalSpecialsSettings.skaven_beastmen.difficulty_overrides
	SpecialsSettings.chaos_beastmen.difficulty_overrides = mutator.OriginalSpecialsSettings.chaos_beastmen.difficulty_overrides
	
	for name, value in pairs(mutator.OriginalThreatValue) do
		Breeds[name].threat_value = value
	end
	
	Managers.state.conflict:set_threat_value("skaven_rat_ogre", mutator.OriginalThreatValue["skaven_rat_ogre"])
	Managers.state.conflict:set_threat_value("skaven_stormfiend", mutator.OriginalThreatValue["skaven_stormfiend"])
	Managers.state.conflict:set_threat_value("chaos_spawn", mutator.OriginalThreatValue["chaos_spawn"])
	Managers.state.conflict:set_threat_value("chaos_troll", mutator.OriginalThreatValue["chaos_troll"])
	Managers.state.conflict:set_threat_value("beastmen_minotaur", mutator.OriginalThreatValue["beastmen_minotaur"])

	BossSettings.default.boss_events.events = mutator.OriginalBossSettings.default.boss_events.events
	BossSettings.default_light.boss_events.events = mutator.OriginalBossSettings.default_light.boss_events.events
	BossSettings.skaven.boss_events.events = mutator.OriginalBossSettings.skaven.boss_events.events
	BossSettings.skaven_light.boss_events.events = mutator.OriginalBossSettings.skaven_light.boss_events.events
	BossSettings.chaos.boss_events.events = mutator.OriginalBossSettings.chaos.boss_events.events
	BossSettings.chaos_light.boss_events.events = mutator.OriginalBossSettings.chaos_light.boss_events.events
	BossSettings.beastmen.boss_events.events = mutator.OriginalBossSettings.beastmen.boss_events.events
	BossSettings.skaven_beastmen.boss_events.events = mutator.OriginalBossSettings.skaven_beastmen.boss_events.events
	BossSettings.chaos_beastmen.boss_events.events = mutator.OriginalBossSettings.chaos_beastmen.boss_events.events
	BossSettings.beastmen_light.boss_events.events = mutator.OriginalBossSettings.beastmen_light.boss_events.events

	HordeCompositions.event_smaller = mutator.OriginalHordeCompositions.event_smaller
	HordeCompositions.event_small = mutator.OriginalHordeCompositions.event_small
	HordeCompositions.event_medium = mutator.OriginalHordeCompositions.event_medium
	HordeCompositions.event_large = mutator.OriginalHordeCompositions.event_large
	HordeCompositions.event_small_chaos = mutator.OriginalHordeCompositions.event_small_chaos
	HordeCompositions.event_medium_chaos = mutator.OriginalHordeCompositions.event_medium_chaos
	HordeCompositions.event_large_chaos = mutator.OriginalHordeCompositions.event_large_chaos
	HordeCompositions.event_extra_spice_small = mutator.OriginalHordeCompositions.event_extra_spice_small
	HordeCompositions.event_extra_spice_medium = mutator.OriginalHordeCompositions.event_extra_spice_medium
	HordeCompositions.event_extra_spice_large = mutator.OriginalHordeCompositions.event_extra_spice_large
	
	HordeCompositions.military_end_event_chaos_01 = mutator.OriginalHordeCompositions.military_end_event_chaos_01
	HordeCompositions.military_end_event_berzerkers = mutator.OriginalHordeCompositions.military_end_event_berzerkers
	HordeCompositions.event_ussingen_gate_group = mutator.OriginalHordeCompositions.event_ussingen_gate_group

	table.remove(BreedBehaviors.chaos_exalted_sorcerer[7], 2)
	HordeCompositions.sorcerer_boss_event_defensive = mutator.OriginalHordeCompositions.sorcerer_boss_event_defensive
	HordeCompositions.sorcerer_extra_spawn = mutator.OriginalHordeCompositions.sorcerer_extra_spawn
	
	BreedActions.skaven_storm_vermin_warlord.spawn_allies.difficulty_spawn_list = mutator.OriginalBreedActions.skaven_storm_vermin_warlord.spawn_allies.difficulty_spawn_list
	BreedActions.skaven_storm_vermin_warlord.spawn_sequence.considerations.time_since_last.max_value = mutator.OriginalBreedActions.skaven_storm_vermin_warlord.spawn_sequence.considerations.time_since_last.max_value
	HordeCompositions.stronghold_boss_event_defensive = mutator.OriginalHordeCompositions.stronghold_boss_event_defensive
	HordeCompositions.stronghold_boss_trickle = mutator.OriginalHordeCompositions.stronghold_boss_trickle

	HordeCompositions.warcamp_boss_event_trickle = mutator.OriginalHordeCompositions.warcamp_boss_event_trickle
	HordeCompositions.warcamp_boss_event_defensive = mutator.OriginalHordeCompositions.warcamp_boss_event_defensive
	
	BreedActions.skaven_grey_seer.ground_combat.spawn_allies_cooldown = mutator.OriginalBreedActions.skaven_grey_seer.ground_combat.spawn_allies_cooldown
	BreedActions.skaven_grey_seer.ground_combat.staggers_until_teleport = mutator.OriginalBreedActions.skaven_grey_seer.ground_combat.staggers_until_teleport
	BreedActions.skaven_grey_seer.ground_combat.warp_lightning_spell_cooldown = mutator.OriginalBreedActions.skaven_grey_seer.ground_combat.warp_lightning_spell_cooldown
	BreedActions.skaven_grey_seer.ground_combat.vermintide_spell_cooldown = mutator.OriginalBreedActions.skaven_grey_seer.ground_combat.vermintide_spell_cooldown
	BreedActions.skaven_grey_seer.ground_combat.teleport_spell_cooldown = mutator.OriginalBreedActions.skaven_grey_seer.ground_combat.teleport_spell_cooldown
	HordeCompositions.skittergate_grey_seer_trickle = mutator.OriginalHordeCompositions.skittergate_grey_seer_trickle
	HordeCompositions.skittergate_boss_event_defensive = mutator.OriginalHordeCompositions.skittergate_boss_event_defensive
	--Mutator
	MutatorTemplates.lightning_strike.max_spawns = 3
	MutatorTemplates.lightning_strike.spawn_rate = 11
	ExplosionTemplates.lightning_strike_twitch.explosion.power_level = 250
	
	Breeds.skaven_storm_vermin.primary_armor_category = nil
	Breeds.skaven_storm_vermin.max_health = BreedTweaks.max_health.stormvermin
	Breeds.skaven_storm_vermin.hit_mass_counts = BreedTweaks.hit_mass_counts.stormvermin
	Breeds.skaven_storm_vermin.bloodlust_health = BreedTweaks.bloodlust_health.skaven_elite
	Breeds.skaven_storm_vermin.size_variation_range = { 1.1, 1.175 }

	--Specials
	BreedActions.skaven_ratling_gunner.shoot_ratling_gun.fire_rate_at_start = 10
	BreedActions.skaven_ratling_gunner.shoot_ratling_gun.fire_rate_at_end = 25
	BreedActions.skaven_ratling_gunner.shoot_ratling_gun.ignore_staggers = {
		true,
		false,
		false,
		true,
		true,
		false
	}
	BreedActions.skaven_poison_wind_globadier.throw_poison_globe.time_between_throws = {
		12,
		2
	}
	BreedActions.skaven_warpfire_thrower.shoot_warpfire_thrower.ignore_staggers = {
		true,
		false,
		false,
		true,
		true,
		false
	}
	Breeds.skaven_warpfire_thrower.run_speed = 4.5
	Breeds.skaven_warpfire_thrower.max_health = BreedTweaks.max_health.warpfire_thrower
	BuffTemplates.warpfire_thrower_face_base.buffs[1].duration = 0.3
	BuffTemplates.warpfire_thrower_face_base.buffs[1].stat_buff = nil
	BuffTemplates.warpfire_thrower_face_base.buffs[1].multiplier = nil
	BreedActions.chaos_corruptor_sorcerer.grab_attack.ignore_staggers = nil
	BreedActions.chaos_corruptor_sorcerer.grab_attack.drain_life_tick_rate = 1
	BreedActions.chaos_corruptor_sorcerer.skulk_approach.initial_skulk_time = {
		10,
		12
	}
	BreedActions.chaos_corruptor_sorcerer.skulk_approach.skulk_time = {
		5,
		8
	}
	BreedActions.chaos_corruptor_sorcerer.skulk_approach.teleport_cooldown = {
		15,
		15
	}

	---------------------

	create_weights()

	mod:disable_all_hooks()

	mutator.active = false
end

local JOIN_MESSAGE = "Dutch Spice Active"

mod:hook(MatchmakingManager, "rpc_matchmaking_request_join_lobby", function (func, self, channel_id, lobby_id, friend_join, client_dlc_unlocked_array)
	local peer_id = CHANNEL_TO_PEER_ID[channel_id]

	if mutator.active then
		mod:chat_whisper(peer_id, JOIN_MESSAGE)
	end

	return func(self, channel_id, lobby_id, friend_join, client_dlc_unlocked_array)
end)

mod:network_register("rpc_activate_buffed_enemies", function (sender, enable)
	if enable ~= mutator.active then
		if enable then
			mod:dofile("scripts/mods/DutchSpice/SpicyEnemies/BuffedEnemies")
			mod:echo("Dutch Enemies modified")
		end
	end
end)

mod:hook_safe("ChatManager", "_add_message_to_list", function (self, channel_id, message_sender, local_player_id, message, is_system_message, pop_chat, is_dev, message_type, link, data)
	if message == JOIN_MESSAGE and not mutator.active then
		mod:network_send("rpc_activate_buffed_enemies", "local", true)
	end
end)

mod.on_user_joined = function (player)
	if mutator.active then
		mod:network_send("rpc_activate_buffed_enemies", player.peer_id, mutator.active)
	end
end

mutator.toggle = function()
	if Managers.state.game_mode == nil or (Managers.state.game_mode._game_mode_key ~= "inn" and Managers.player.is_server) then
		mod:echo("You must be in the keep to do that!")
		return
	end
	if Managers.matchmaking:_matchmaking_status() ~= "idle" then
		mod:echo("You must cancel matchmaking before toggling this.")
		return
	end
	if not mutator.active then
		if not Managers.player.is_server then
			mod:echo("You must be the host to activate this.")
			return
		end
		mutator.start()
		mod:dofile("scripts/mods/DutchSpice/SpicyEnemies/BuffedEnemies")

		mod:network_send("rpc_activate_buffed_enemies", "all", true)

		mod:chat_broadcast("Dutch Spice ENABLED.")
	else
		mutator.stop()
		mod:chat_broadcast("Thats FUCKING cringe")
	end
end


--[[
	Callback
--]]
-- Call when game state changes (e.g. StateLoading -> StateIngame)
mod.on_game_state_changed = function(status, state)
	if not Managers.player.is_server and mutator.active and Managers.state.game_mode ~= nil then
		mutator.stop()
		mod:echo("The Dutch Spice mutator was disabled because you are no longer the server.")
	end
	return
end

--[[
	Execution
--]]
mod:command("no_special_specials", "Disable empowered specials", function()
	BreedActions.skaven_ratling_gunner.shoot_ratling_gun.fire_rate_at_start = 10
	BreedActions.skaven_ratling_gunner.shoot_ratling_gun.fire_rate_at_end = 25
	BreedActions.skaven_ratling_gunner.shoot_ratling_gun.ignore_staggers = {
		true,
		false,
		false,
		true,
		true,
		false
	}
	BreedActions.skaven_poison_wind_globadier.throw_poison_globe.time_between_throws = {
		12,
		2
	}
	BreedActions.skaven_warpfire_thrower.shoot_warpfire_thrower.ignore_staggers = {
		true,
		false,
		false,
		true,
		true,
		false
	}
	Breeds.skaven_warpfire_thrower.run_speed = 4.5
	Breeds.skaven_warpfire_thrower.max_health = BreedTweaks.max_health.warpfire_thrower
	BuffTemplates.warpfire_thrower_face_base.buffs[1].duration = 0.3
	BuffTemplates.warpfire_thrower_face_base.buffs[1].stat_buff = nil
	BuffTemplates.warpfire_thrower_face_base.buffs[1].multiplier = nil
	BreedActions.chaos_corruptor_sorcerer.grab_attack.ignore_staggers = nil
	BreedActions.chaos_corruptor_sorcerer.grab_attack.drain_life_tick_rate = 1
	BreedActions.chaos_corruptor_sorcerer.skulk_approach.initial_skulk_time = {
		10,
		12
	}
	BreedActions.chaos_corruptor_sorcerer.skulk_approach.skulk_time = {
		5,
		8
	}
	BreedActions.chaos_corruptor_sorcerer.skulk_approach.teleport_cooldown = {
		15,
		15
	}

	empowered_specials = false
end)

mod:command("im_too_weak", "Disable event mutators and auras", function()
	auras_and_mutators = false
end)

mod:command("dutch_spice", "Toggle Dutch Spice. Must be host and in the keep.", function() mutator.toggle() end)
if not mutator.active then
	mod:disable_all_hooks()
end

mod.enable_enhanced_specials = function()
	BreedActions.skaven_ratling_gunner.shoot_ratling_gun.fire_rate_at_start = 20
	BreedActions.skaven_ratling_gunner.shoot_ratling_gun.fire_rate_at_end = 35
	BreedActions.skaven_ratling_gunner.shoot_ratling_gun.ignore_staggers = {
		true,
		true,
		true,
		true,
		true,
		true
	}
	BreedActions.skaven_poison_wind_globadier.throw_poison_globe.time_between_throws = {
		6,
		2
	}
	Breeds.skaven_warpfire_thrower.run_speed = 6
	Breeds.skaven_warpfire_thrower.max_health = BreedTweaks.max_health.stormvermin
	BreedActions.skaven_warpfire_thrower.shoot_warpfire_thrower.hit_radius = 1
	BreedActions.skaven_warpfire_thrower.shoot_warpfire_thrower.warpfire_follow_target_speed = 1.25
	BreedActions.skaven_warpfire_thrower.shoot_warpfire_thrower.ignore_staggers = {
		true,
		true,
		true,
		true,
		true,
		true
	}
	BreedActions.chaos_corruptor_sorcerer.grab_attack.ignore_staggers = {
		true,
		true,
		true,
		true,
		true,
		true
	}
	BreedActions.chaos_corruptor_sorcerer.grab_attack.drain_life_tick_rate = 0.5
	BreedActions.chaos_corruptor_sorcerer.skulk_approach.teleport_cooldown = {
		3,
		3
	}
	BreedActions.chaos_corruptor_sorcerer.skulk_approach.initial_skulk_time = {
		4,
		5
	}
	BreedActions.chaos_corruptor_sorcerer.skulk_approach.skulk_time = {
		1,
		2
	}
end

mod.enable_generic_specials = function()
	BreedActions.skaven_ratling_gunner.shoot_ratling_gun.fire_rate_at_start = 10
	BreedActions.skaven_ratling_gunner.shoot_ratling_gun.fire_rate_at_end = 25
	BreedActions.skaven_ratling_gunner.shoot_ratling_gun.ignore_staggers = {
		true,
		false,
		false,
		true,
		true,
		false
	}
	BreedActions.skaven_poison_wind_globadier.throw_poison_globe.time_between_throws = {
		12,
		2
	}
	BreedActions.skaven_warpfire_thrower.shoot_warpfire_thrower.ignore_staggers = {
		true,
		false,
		false,
		true,
		true,
		false
	}
	Breeds.skaven_warpfire_thrower.run_speed = 4.5
	Breeds.skaven_warpfire_thrower.max_health = BreedTweaks.max_health.warpfire_thrower
	BuffTemplates.warpfire_thrower_face_base.buffs[1].duration = 0.3
	BuffTemplates.warpfire_thrower_face_base.buffs[1].stat_buff = nil
	BuffTemplates.warpfire_thrower_face_base.buffs[1].multiplier = nil
	BreedActions.chaos_corruptor_sorcerer.grab_attack.ignore_staggers = nil
	BreedActions.chaos_corruptor_sorcerer.grab_attack.drain_life_tick_rate = 1
	BreedActions.chaos_corruptor_sorcerer.skulk_approach.initial_skulk_time = {
		10,
		12
	}
	BreedActions.chaos_corruptor_sorcerer.skulk_approach.skulk_time = {
		5,
		8
	}
	BreedActions.chaos_corruptor_sorcerer.skulk_approach.teleport_cooldown = {
		15,
		15
	}
end

mod.on_setting_changed = function()
	if not mod:get("enhanced_specials") then
		mod.enable_generic_specials()
	else
		mod.enable_enhanced_specials()
	end
end

mod.on_all_mods_loaded = function (self)
	check_for_buffs()

	return
end