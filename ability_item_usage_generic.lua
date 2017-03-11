_G._savedEnv = getfenv()
module( "ability_item_usage_generic", package.seeall )
local support = require(GetScriptDirectory().."/support_item")
local talent_factory = require(GetScriptDirectory().."/factory/talent_factory")
local assembly_shop = require(GetScriptDirectory().."/assembly_shop")
local action_template = require(GetScriptDirectory().."/template/ability_item_action_template")


function BuybackUsageThink()

end
function AbilityLevelUpThink()
	local npcBot = GetBot()
	
	if npcBot.Talent == nil then
		npcBot.Talent = talent_factory:CreatTable();
	end
	 if not npcBot:IsHero() or npcBot.character == nil then
		return
	 end
	 if npcBot.BotAbilityPriority == nil and npcBot:IsHero() then
		 local build = require(GetScriptDirectory() .. "/builds/item_build_" .. string.gsub(npcBot:GetUnitName(), "npc_dota_hero_", ""))
		 npcBot.BotAbilityPriority = build[npcBot.character .."_skills"]
	 end
	 
	 if npcBot.BotAbilityPriority == nil then
		print(npcBot:GetUnitName());
		return
	 end
	 
	 if (#npcBot.BotAbilityPriority > (25 - npcBot:GetLevel())) then  
        local ability_name = npcBot.BotAbilityPriority[1];
		if type(ability_name) == "string" then
			if ability_name ~= "-1" then
				if npcBot:HasScepter() and ability_name == "keeper_of_the_light_illuminate" then
					ability_name = "keeper_of_the_light_spirit_form_illuminate";
				end
				local ability = npcBot:GetAbilityByName(ability_name);
					
				if( ability:CanAbilityBeUpgraded() and ability:GetLevel() < ability:GetMaxLevel())  
				then
					local currentLevel = ability:GetLevel();
					npcBot:ActionImmediate_LevelAbility(npcBot.BotAbilityPriority[1]);
					if ability:GetLevel() > currentLevel then
						table.remove(npcBot.BotAbilityPriority,1)
					else
					end
				end
			else
				table.remove(npcBot.BotAbilityPriority,1)
			end
		elseif type(ability_name) == "number" then
			local ability = npcBot.Talent[ability_name];
			if ability:CanAbilityBeUpgraded() then
				local currentLevel = ability:GetLevel();
				npcBot:ActionImmediate_LevelAbility(ability:GetName());
				if ability:GetLevel() > currentLevel then
					table.remove(npcBot.BotAbilityPriority,1)
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
	
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling()) then return end;
	
	local TableAbility,_ = assembly_shop:Main();
	
	action_template:ActionTemplate(TableAbility);
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ---
function ItemUsageThink()
	local npcBot = GetBot();
	--print(nName);
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling()) then return end;
	
	support:UseSupportItem()
	
	local _,Tableitem = assembly_shop:Main();
	
	
	action_template:ActionTemplate(Tableitem);
end
----------------------------------------------------------------------------------------------------


for k,v in pairs( ability_item_usage_generic ) do	_G._savedEnv[k] = v end