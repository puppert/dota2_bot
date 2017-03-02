_G._savedEnv = getfenv()
module( "ability_item_usage_generic", package.seeall )
local support = require(GetScriptDirectory().."/support_item")
local assembly_shop = require(GetScriptDirectory().."/assembly_shop")
local action_template = require(GetScriptDirectory().."/template/ability_item_action_template")


function BuybackUsageThink()

end
function AbilityLevelUpThink()
	if GetBot().Talent == nil then
		GetBot().Talent = {};
		local count = 0;
		while GetBot():GetAbilityInSlot(count) ~= nil do
			local ability = GetBot():GetAbilityInSlot(count);
			if ability:IsTalent() then
				table.insert(GetBot().Talent,ability:GetName());
			end
			count = count + 1;
		end
	end
	 if not GetBot():IsHero() or GetBot().character == nil then
		return
	 end
	 if GetBot().BotAbilityPriority == nil and GetBot():IsHero() then
		 local build = require(GetScriptDirectory() .. "/builds/item_build_" .. string.gsub(GetBot():GetUnitName(), "npc_dota_hero_", ""))
		 GetBot().BotAbilityPriority = build[GetBot().character.."_skills"]
	 end
	 
	 if (#GetBot().BotAbilityPriority > (25 - GetBot():GetLevel())) then  
        local ability_name = GetBot().BotAbilityPriority[1];
		--print(ability_name);
        -- Can I slot a skill with this skill point?
		if type(ability_name) == "string" then
			if ability_name ~= "-1" then
				if GetBot():HasScepter() and ability_name == "keeper_of_the_light_illuminate" then
					ability_name = "keeper_of_the_light_spirit_form_illuminate";
				end
				local ability = GetBot():GetAbilityByName(ability_name);
					
				if( ability:CanAbilityBeUpgraded() and ability:GetLevel() < ability:GetMaxLevel())  
				then
					local currentLevel = ability:GetLevel();
					GetBot():ActionImmediate_LevelAbility(GetBot().BotAbilityPriority[1]);
					if ability:GetLevel() > currentLevel then
						table.remove(GetBot().BotAbilityPriority,1)
					else
					end
				end
			else
				table.remove(GetBot().BotAbilityPriority,1)
			end
		elseif type(ability_name) == "number" then
			local ability = GetBot():GetAbilityByName(GetBot().Talent[ability_name]);
			if( ability:CanAbilityBeUpgraded() and ability:GetLevel() < ability:GetMaxLevel())  
			then
				local currentLevel = ability:GetLevel();
				GetBot():ActionImmediate_LevelAbility(GetBot().Talent[ability_name]);
				if ability:GetLevel() > currentLevel then
					table.remove(GetBot().BotAbilityPriority,1)
				end
			end
		end
	end
end

function CourierUsageThink()
	local npcBot = GetBot();
	--print("use")
	if not IsCourierAvailable() then
		return
	end
	
	if GetCourierState(GetCourier(GetNumCouriers() -1)) ~= COURIER_STATE_IDLE
	and  GetCourierState(GetCourier(GetNumCouriers() -1)) ~= COURIER_STATE_AT_BASE then
		return
	end
	
	if GetCourierState(GetCourier(GetNumCouriers() -1)) == COURIER_STATE_IDLE 
	and GetCourier(GetNumCouriers() -1):DistanceFromFountain() > 200 then
		npcBot:ActionImmediate_Courier(GetCourier(GetNumCouriers() -1), COURIER_ACTION_RETURN );
		return
	end
	
	
	if npcBot:IsAlive() and (npcBot:GetStashValue() > 50 or npcBot:GetCourierValue() > 50) then
		npcBot:ActionImmediate_Courier(GetCourier(GetNumCouriers() -1), COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS );
		return
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function AbilityUsageThink()
	local npcBot = GetBot();
	
	if not GetBot():IsHero() then
		return
	 end
	
	local cast = {};
	local TableAbility,_ = assembly_shop:Main();
	
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling()) then return end;
	
	for k,v in pairs(TableAbility) do
		if v["Consider"] ~= nil and v:IsFullyCastable() then
			tablecast[1],tablecast[2] = v["Consider"](); 
		else
			tablecast[1],tablecast[2] = 0, 0;
		end
		cast[k] = tablecast;
	end
	
	action_template:ActionTemplate(cast,TableAbility);
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ---
function ItemUsageThink()
	local npcBot = GetBot();
	nName = npcBot:GetUnitName();
	--print(nName);
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling()) then return end;
	
	support:UseSupportItem()
	
	local _,Tableitem = assembly_shop:Main();;
	local cast = {};
	
	
	for k,v in pairs(Tableitem) do
		if v["Consider"] ~= nil and v:IsFullyCastable() then
			tablecast[1],tablecast[2] = v["Consider"](); 
		else
			tablecast[1],tablecast[2] = 0, 0;
		end
		cast[k] = tablecast;
	end
	
	action_template:ActionTemplate(cast,Tableitem);
end
----------------------------------------------------------------------------------------------------


for k,v in pairs( ability_item_usage_generic ) do	_G._savedEnv[k] = v end