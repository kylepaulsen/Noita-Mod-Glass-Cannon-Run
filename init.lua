dofile( "data/scripts/lib/utilities.lua" )
dofile( "data/scripts/perks/perk_list.lua" )

function OnModPreInit()

end

function OnModInit()

end

function OnModPostInit()

end

function OnPlayerSpawned( player_entity )
	if tonumber(StatsGetValue("playtime")) > 1 then
		return
	end

	local START_WITH_PERK = "GLASS_CANNON"

	local perk_data
	for i = 1, #perk_list do
		local perk = perk_list[i]
		if perk.id == START_WITH_PERK then
			perk_data = perk
			break
		end
	end

	GameAddFlagRun(get_perk_picked_flag_name(perk_data.id))

	if perk_data.game_effect ~= nil then
		local game_effect_comp = GetGameEffectLoadTo( player_entity, perk_data.game_effect, true )
		if game_effect_comp ~= nil then
			ComponentSetValue( game_effect_comp, "frames", "-1" )
		end
	end

	if perk_data.func ~= nil then
		perk_data.func( nil, player_entity, nil )
	end

	local entity_ui = EntityCreateNew("")
	EntityAddComponent(entity_ui, "UIIconComponent", {
		name = perk_data.ui_name,
		description = perk_data.ui_description,
		icon_sprite_file = perk_data.ui_icon
	})
	EntityAddChild(player_entity, entity_ui)
	GamePrintImportant(GameTextGet("$log_pickedup_perk", GameTextGetTranslatedOrNot(perk_data.ui_name)), perk_data.ui_description)
end
