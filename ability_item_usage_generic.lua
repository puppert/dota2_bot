_G._savedEnv = getfenv()
module( "ability_item_usage_generic", package.seeall )
local item_to_use = require(GetScriptDirectory().."/item_to_use");
local myutil = require(GetScriptDirectory().."/myutil")
local home = require(GetScriptDirectory().."/constant_each_side")
local support = require(GetScriptDirectory().."/support_item")
 require(GetScriptDirectory().."/ability_consider")


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
	local TableAbility = {};
	
	local count = 0;
	while true do
		local ability = npcBot:GetAbilityInSlot(count);
		if not ability:IsTalent() then
			local heroname = string.gsub(npcBot:GetUnitName(),"npc_dota_hero_","");
			local  name = string.gsub(ability:GetName(),heroname,"ability");
			local abilityname = string.gsub(name,"_%l",function(s)
													return string.upper(string.sub(s,2))
													end
													)
			TableAbility[abilityname] = ability;
		else
			break;
		end
		count = count +1;
	end
	
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling()) then return end;
	
	for k,v in pairs(TableAbility) do
		local functionname = string.gsub(k,"ability","Consider");
		if functionname == "ConsiderBlink" and v:GetName() == "antimage_blink" then
			functionname = "ConsiderAMBlink";
		end
		local tablecast = {};
		if v["Consider"] == nil then
			v["Consider"] = ability_consider[functionname];
		end
		if v["Consider"] ~= nil and v:IsFullyCastable() then
			tablecast[1],tablecast[2] = v["Consider"](); 
		else
			tablecast[1],tablecast[2] = 0, 0;
		end
		if tablecast[1] == nil then
			print(k)
		end
		cast[k] = tablecast;
	end
	
	local TableKey = {};
	for k,v in pairs(cast) do
		table.insert(TableKey,k);
	end
	--print(#TableKey);
	table.sort(TableKey,function(a,b) return cast[a][1] > cast[b][1] end);
	local firstkey = TableKey[1];
	
	if cast[firstkey] ~= nil then
		if cast[firstkey][1] > 0 then
			local abilitytouse = TableAbility[firstkey];
			local target = cast[firstkey][2];
			if type(target) == "nil" then
				npcBot:Action_UseAbility(abilitytouse);
			elseif type(target) == "number" then
				npcBot:Action_UseAbilityOnTree(abilitytouse,target);
			elseif type(target) == "userdata" then
				npcBot:Action_UseAbilityOnLocation(abilitytouse,target);
			elseif type(target) == "table" then
				npcBot:Action_UseAbilityOnEntity(abilitytouse,target);
			end
		end
	end
	
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ---
function ItemUsageThink()
	local npcBot = GetBot();
	nName = npcBot:GetUnitName();
	--print(nName);
	if ( npcBot:IsUsingAbility() or npcBot:IsChanneling()) then return end;
	
	support:UseSupportItem()
	
	local Tableitem = item_to_use.Tableitem;
	local item = {};
	local cast = {};
	
	for _,itemname in ipairs(Tableitem) do
		item[string.gsub(itemname,"_%l",function(s)
			return string.upper(string.sub(s,2))
		end
		)] = itemname;
	end
	
	
	for i=0, 5 do
		if(npcBot:GetItemInSlot(i) ~= nil) then
			local _item = npcBot:GetItemInSlot(i):GetName()
			for k,v in pairs(item) do
				if(_item == v) then
					item[k] = npcBot:GetItemInSlot(i);
				end
			end
		end
	end
	
	for k,v in pairs(item) do
		if type(v) ~= "string" then
			--print(nName..".."..v:GetName().."..type.."..type(v))
			local functionname = string.gsub(k,"item","Consider");
			local tablecast = {};
			if (npcBot:IsInvisible() and npcBot:UsingItemBreaksInvisibility()) or  not v:IsFullyCastable() then
				tablecast[1],tablecast[2] = 0, 0;
			else
				if npcBot.tablefunction ~= nil and npcBot.tablefunction[functionname] ~= nil then
					if not v:IsFullyCastable() then
						tablecast[1],tablecast[2] = 0, 0;
					else
						tablecast[1],tablecast[2] = load("return GetBot().tablefunction:" .. functionname .. "()")();
					end
				elseif _G[functionname] ~= nil then
					if not v:IsFullyCastable() then
						tablecast[1],tablecast[2] = 0, 0;
					else
						tablecast[1],tablecast[2] = load("return " .. functionname .. "()")();
					end
				else
					tablecast[1],tablecast[2] = 0, 0;
				end
			end
			cast[k] = tablecast;
		end
	end
	
	local TableKey = {};
	for k,v in pairs(cast) do
		table.insert(TableKey,k);
	end
	--print(#TableKey);
	table.sort(TableKey,function(a,b) return cast[a][1] > cast[b][1] end);
	local firstkey = TableKey[1];
	
	if cast[firstkey] ~= nil then
		if cast[firstkey][1] > 0 then
			local itemtouse = item[firstkey];
			local target = cast[firstkey][2];
			if type(target) == "nil" then
				npcBot:Action_UseAbility(itemtouse);
			elseif type(target) == "number" then
				npcBot:Action_UseAbilityOnTree(itemtouse,target);
			elseif type(target) == "userdata" then
				npcBot:Action_UseAbilityOnLocation(itemtouse,target);
			elseif type(target) == "table" then
				npcBot:Action_UseAbilityOnEntity(itemtouse,target);
			end
		end
	end
	
end
----------------------------------------------------------------------------------------------------
function ConsiderTango()
	local npcBot = GetBot();
	if(npcBot:HasModifier("modifier_tango_heal")) then
		return BOT_ACTION_DESIRE_NONE,0;
	end
	local TableNearbyTower = npcBot:GetNearbyTowers(1300,true);
	local TableNearbyTree = npcBot:GetNearbyTrees(1000);
	
	if (npcBot:GetHealth()+175) < npcBot:GetMaxHealth() then
		if TableNearbyTower[1] == nil then
			if npcBot:GetNearbyTrees(1000)[1] ~= nil then
				return BOT_ACTION_DESIRE_MODERATE,npcBot:GetNearbyTrees(1000)[1];
			end
		else
			if npcBot:GetNearbyTrees(1000)[1] ~= nil then
				for k,v in ipairs(npcBot:GetNearbyTrees(1000)) do
					if GetUnitToLocationDistance(TableNearbyTower[1],GetTreeLocation(v)) >= 1000 then
						return BOT_ACTION_DESIRE_MODERATE,v;
					end
				end
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
-------------------------------------------------------------------------------------
function ConsiderClarity()
	local npcBot = GetBot();
	if(npcBot:HasModifier("modifier_clarity_potion")) then
		return BOT_ACTION_DESIRE_NONE,0;
	end
	
	if(npcBot:GetMana() <= (npcBot:GetMaxMana()*0.6)) then
		return BOT_ACTION_DESIRE_MODERATE,npcBot;
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
----------------------------------------------------------------------------------
function ConsiderTpscroll()
	local npcBot = GetBot();
	--print("tp.."..type(home.HomePosition()));
	if(npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP
	or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID
	or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT) 
	then
		local tower, lane = myutil.GetTowertoTp();
		--print(lane);
		--print(tower:GetUnitName());
		if(GetUnitToLocationDistance(npcBot,GetLaneFrontLocation(GetTeam(),lane,0))>5000) then
			if(tower == nil) then
				if(GetUnitToLocationDistance(GetTower(GetTeam(),TOWER_BASE_1),GetLaneFrontLocation(GetTeam(),lane,0)) 
					< 3000 and npcBot:DistanceFromFountain() >= 4000) then
					
					return BOT_ACTION_DESIRE_HIGH,home.HomePosition();
				end
			elseif(GetUnitToUnitDistance( npcBot, tower) > 5000) then
				
				return BOT_ACTION_DESIRE_HIGH,tower:GetLocation();
			end
		end
	end
	
	if(npcBot:GetActiveMode() == BOT_MODE_LANING) then
		if(npcBot:DistanceFromFountain()<=10
		and npcBot:GetHealth() == npcBot:GetMaxHealth()
		and npcBot:GetMana() == npcBot:GetMaxMana()) then
			local tower,lane = myutil.GetTowertoTp();
			return BOT_ACTION_DESIRE_MODERATE, tower:GetLocation();
		end
	end
	
	if(npcBot:GetActiveMode() == BOT_MODE_RETREAT)then
		if((npcBot:GetHealth() == (npcBot:GetMaxHealth()*0.3)
		or npcBot:GetMana() == (npcBot:GetMaxMana()*0.3))
		and npcBot:DistanceFromFountain() > 5000) then
			return BOT_ACTION_DESIRE_MODERATE, home.HomePosition();
		end
	end
	
	return BOT_ACTION_DESIRE_NONE,0
end
-----------------------------------------------------------------------------------------------
function ConsiderGhost()
	local npcBot = GetBot();
	
	local TableEnemyheroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	
	if TableEnemyheroes[1] ~= nil then
		if GetUnitToUnitDistance(npcBot,TableEnemyheroes[1]) <= 400 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	
	if npcBot:WasRecentlyDamagedByAnyHero(0.1) or npcBot:WasRecentlyDamagedByTower(0.1) then
		return	BOT_ACTION_DESIRE_MODERATE
	end
	
	return BOT_ACTION_DESIRE_NONE;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ---
function ConsiderGlimmerCape()
	local npcBot = GetBot();
	
	local TableEnemyheroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	local TableFriendlyHeroes = npcBot:GetNearbyHeroes(1000,false,BOT_MODE_RETREAT);
	
	if TableEnemyheroes[1] ~= nil then
		if TableFriendlyHeroes[1] ~= nil then
			local weakest;
			local lowestHp = 10000;
			for k,v in ipairs(TableFriendlyHeroes) do
				if v:GetHealth() < lowestHp then
					weakest = v;
					lowestHp = v:GetHealth();
				end
			end
			if weakest ~= nil then
				return BOT_ACTION_DESIRE_MODERATE,weakest;
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE,0;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ---
function ConsiderSheepstick()
	local npcBot = GetBot();
	
	local TableEnemyheroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	
	if TableEnemyheroes[1] ~= nil then
		local target;
		local highest = 0;
		for k,v in ipairs(TableEnemyheroes) do		
			if v:IsChanneling() then
				return BOT_ACTION_DESIRE_HIGH,v;
			end
			if v:GetRawOffensivePower() > highest then
				highest = v:GetRawOffensivePower();
				target = v;
			end
		end
		return BOT_ACTION_DESIRE_MODERATE,target;
	end
	
	return 0,0;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function ConsiderFlask()
	local npcBot = GetBot();
	if(npcBot:HasModifier("modifier_flask_healing")) then
		return BOT_ACTION_DESIRE_NONE,0;
	end
	
	if((npcBot:GetHealth()) <= npcBot:GetMaxHealth()
	  and itemTango == "item_tango") then
	--print("use");
		return BOT_ACTION_DESIRE_ABSOLUTE,npcBot;
	end
	
	if((npcBot:GetHealth()+500) < npcBot:GetMaxHealth()) then
		return BOT_ACTION_DESIRE_MODERATE,npcBot;
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
----------------------------------------------------------------------------------
function ConsiderArmlet()
	local npcBot = GetBot();
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true, BOT_MODE_NONE);
	local opentime = myutil.GetOpentime();
	local closetime = myutil.GetClosetime();
	
	
	if(npcBot:GetActiveMode() ~= BOT_MODE_FARM) then
		if(tableNearbyEnemyHeroes[1] ~= nil
		and not npcBot:HasModifier("modifier_item_armlet_unholy_strength")
		and DotaTime() > (closetime + 0.6) and npcBot:GetHealth()>500) then
			if(npcBot:GetAttackTarget() ~= nil) then
				if(npcBot:GetAttackTarget():IsHero())then
					myutil.updateOpentime(DotaTime());
					return BOT_ACTION_DESIRE_MODERATE
				end
			elseif (npcBot:WasRecentlyDamagedByAnyHero(0.3))then
				myutil.updateOpentime(DotaTime());
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
		if(tableNearbyEnemyHeroes[1] == nil
		and npcBot:HasModifier("modifier_item_armlet_unholy_strength")
		and DotaTime() > (opentime + 0.6)) then
			myutil.updateClosetime(DotaTime());
			return BOT_ACTION_DESIRE_MODERATE
		end
		if(	npcBot:HasModifier("modifier_item_armlet_unholy_strength")
		--and not npcBot:WasRecentlyDamagedByAnyHero( 0.1 )
		and npcBot:GetHealth()<= 150
		and DotaTime() > (closetime + 0.6))
		then 
			myutil.updateClosetime(DotaTime());
			return BOT_ACTION_DESIRE_HIGH;
		end; 
		if( not npcBot:HasModifier("modifier_item_armlet_unholy_strength")
		and npcBot:GetHealth()<=20 and DotaTime() > (opentime + 0.6))
		then
			myutil.updateOpentime(DotaTime());
			return BOT_MODE_DESIRE_ABSOLUTE ;
		end;
	end
	return BOT_ACTION_DESIRE_NONE;
end
------------------------------------------------------------------------------------
function ConsiderBlackKingBar()
	local npcBot = GetBot();
	
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	
	
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT) then
		if npcBot:GetAttackTarget() ~= nil then
			if(tableNearbyEnemyHeroes[1] ~= nil
			and npcBot:GetAttackTarget():IsHero()
			and npcBot:GetCurrentMovementSpeed() == 650) then
				return BOT_ACTION_DESIRE_MODERATE;
			end;	
		end
	end;
	
	
	return BOT_ACTION_DESIRE_NONE;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ---
function ConsiderBottle()
	local npcBot = GetBot();
	
	local itemBottle = "item_bottle";
	
	for i=0, 5 do
		if(npcBot:GetItemInSlot(i) ~= nil) then
			local _item = npcBot:GetItemInSlot(i):GetName()
			if(_item == itemBottle) then
				itemBottle = npcBot:GetItemInSlot(i);
			end
		end
	end
	
	if itemBottle == "item_bottle" then
		return BOT_ACTION_DESIRE_NONE,0;
	end
	
	if(npcBot:HasModifier("modifier_bottle_regeneration")) then
		return BOT_ACTION_DESIRE_NONE,0;
	end
	
	if(npcBot:GetMana()<(npcBot:GetMaxMana()*0.6)
	or npcBot:GetHealth() <(npcBot:GetMaxMana()*0.7))then
		if (itemBottle:GetCurrentCharges() > 0 )then
			return BOT_ACTION_DESIRE_VERYHIGH,npcBot;
		end
	end
	
	if(npcBot:DistanceFromFountain() == 0) then
		if(npcBot:GetHealth() < npcBot:GetMaxHealth()
		or npcBot:GetMaxMana() < npcBot:GetMaxMana()) then
			return BOT_ACTION_DESIRE_HIGH,npcBot;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
-------------------------------------------------------------------------------------------------------
function ConsiderBladeMail()
	local npcBot = GetBot();
	
	
	local tableNearbyEnemyHeroes300 = npcBot:GetNearbyHeroes(300,true,BOT_MODE_NONE);
	
	if(tableNearbyEnemyHeroes300[1] ~= nil) then
		return BOT_ACTION_DESIRE_HIGH;
	end
	
	if(npcBot:WasRecentlyDamagedByAnyHero(1.0)) then
		return BOT_ACTION_DESIRE_MODERATE;
	end
	
	if(npcBot:IsStunned() or npcBot:IsRooted() or npcBot:IsSilenced()) then
		return BOT_ACTION_DESIRE_MODERATE;
	end
	return BOT_ACTION_DESIRE_NONE;
end
---------------------------------------------------------------------------------------
function ConsiderShivasGuard()
	local npcBot = GetBot();
	
	
	local tableNearbyEnemy = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	local nTarget = tableNearbyEnemy[1]
	
	if(nTarget ~= nil) then
		if(GetUnitToUnitDistance(nTarget,npcBot) <= 800) then
			return BOT_ACTION_DESIRE_HIGH;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE;
end
-------------------------------------------------------------------------------------------------
function ConsiderMjollnir()
	local npcBot = GetBot();
	
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	if(tableNearbyEnemyHeroes[1] ~= nil) then
		return BOT_ACTION_DESIRE_MODERATE;
	end
	
	
	return BOT_ACTION_DESIRE_NONE;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function ConsiderPowerTreads()
	local npcBot = GetBot();
	
	local itemPowerTreads = "item_power_treads";
	
	for i=0, 5 do
		if(npcBot:GetItemInSlot(i) ~= nil) then
			local _item = npcBot:GetItemInSlot(i):GetName()
			if(_item == itemPowerTreads) then
				itemPowerTreads = npcBot:GetItemInSlot(i);
			end
		end
	end
	
	if(itemPowerTreads == "item_power_treads") then
		return BOT_ACTION_DESIRE_NONE;
	end
	
	if npcBot:HasModifier("modifier_bottle_regeneration") then
		if itemPowerTreads:GetPowerTreadsStat() ~= 2 then
			return BOT_ACTION_DESIRE_MODERATE;
		else
			return BOT_ACTION_DESIRE_NONE;
		end
	end
	
	if npcBot:GetHealth() <= 200 then
		if itemPowerTreads:GetPowerTreadsStat() ~= 0 then
			return BOT_ACTION_DESIRE_MODERATE;
		else
			return BOT_ACTION_DESIRE_NONE;
		end
	
	end
	
	if itemPowerTreads:GetPowerTreadsStat() ~= (npcBot:GetPrimaryAttribute() - 1) then
		return BOT_ACTION_DESIRE_MODERATE;
	end
	
	return BOT_ACTION_DESIRE_NONE;
end
-----------------------------------------------------------------------------------------------
function ConsiderArcaneBoots()
	local npcBot = GetBot();
	
	
	local nRadius = 900;
	local rMana = 135;
	
	if npcBot:GetMana() <= (npcBot:GetMaxMana() - 135) then
		return BOT_ACTION_DESIRE_HIGH;
	end
	
	return BOT_ACTION_DESIRE_NONE;
end
----------------------------------------------------------------------------------------------------
function ConsiderMekansm()
	local npcBot = GetBot();
	
	
	local TableNearbyFriendlyHeroes = npcBot:GetNearbyHeroes(900,false,BOT_MODE_NONE);
	
	if(TableNearbyFriendlyHeroes[1] ~= nil) then
		local count = 0;
		for k,v in pairs(TableNearbyFriendlyHeroes) do 
			if v:GetHealth() <= (v:GetMaxHealth()*0.4) then
				return BOT_ACTION_DESIRE_MODERATE;
			end
			if v:GetHealth() <= (v:GetMaxHealth()*0.5) then
				count = count +1;
			end
			if count >= 3 then
				return BOT_ACTION_DESIRE_HIGH;
			end
		end
	end
	return BOT_ACTION_DESIRE_NONE;
end
-----------------------------------------------------------------------------------------------
function ConsiderGuardianGreaves()
	local npcBot = GetBot();
	
	
	local TableNearbyFriendlyHeroes = npcBot:GetNearbyHeroes(900,false,BOT_MODE_NONE);
	
	if(TableNearbyFriendlyHeroes[1] ~= nil) then
		local count = 0;
		for k,v in pairs(TableNearbyFriendlyHeroes) do 
			if v:GetHealth() <= (v:GetMaxHealth()*0.4) then
				return BOT_ACTION_DESIRE_MODERATE;
			end
			if v:GetHealth() <= (v:GetMaxHealth()*0.5) then
				count = count +1;
			end
			if count >= 3 then
				return BOT_ACTION_DESIRE_HIGH;
			end
		end
	end
	
	if(npcBot:IsRooted() or npcBot:IsSilenced()) then
		return BOT_ACTION_DESIRE_HIGH;
	end
	
	if(npcBot:HasModifier("modifier_keeper_of_the_light_mana_leak")) then
		return BOT_ACTION_DESIRE_MODERATE;
	end
	
	return BOT_ACTION_DESIRE_NONE;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
function ConsiderMedallionOfCourage()
	local npcBot = GetBot();
	
	if(npcBot:GetAttackTarget() ~= nil) then
		local unitname = npcBot:GetAttackTarget():GetUnitName();
		if string.find(unitname,"npc_dota_creep") ~= nil or (npcBot:GetAttackTarget():IsHero() and npcBot:GetAttackTarget():GetTeam() ~= GetTeam())then
			return BOT_ACTION_DESIRE_MODERATE, npcBot:GetAttackTarget();
		end
	end
	
	if(npcBot:GetTarget() ~= nil) then
		local unitname = npcBot:GetTarget():GetUnitName();
		if string.find(unitname,"npc_dota_creep") ~= nil 
		or (npcBot:GetAttackTarget():IsHero() and npcBot:GetAttackTarget():GetTeam() ~= GetTeam()) then
			return BOT_ACTION_DESIRE_MODERATE,npcBot:GetTarget();
		end
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
function ConsiderSolarCrest()
	local npcBot = GetBot();
	
	if(npcBot:GetAttackTarget() ~= nil) then
		local unitname = npcBot:GetAttackTarget():GetUnitName();
		if string.find(unitname,"npc_dota_creep") ~= nil then
			return BOT_ACTION_DESIRE_MODERATE, npcBot:GetAttackTarget();
		end
	end
	
	if(npcBot:GetTarget() ~= nil) then
		local unitname = npcBot:GetTarget():GetUnitName();
		if string.find(unitname,"npc_dota_creep") ~= nil 
		and IsTeamPlayer(npcBot:GetTarget():GetPlayerID())then
			return BOT_ACTION_DESIRE_MODERATE,npcBot:GetTarget();
		end
	end

	return BOT_ACTION_DESIRE_NONE,0;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ---k
function ConsiderBlink()
	if npcBot:GetActiveMode() == BOT_MODE_ATTACK then
		local nTarget = myutil.ChoseEnemyTarget();
		return BOT_ACTION_DESIRE_MODERATE,nTarget:GetLocation();
	end	
	
	if not IsLocationPassable(npcBot:GetLocation()) then
		return BOT_ACTION_DESIRE_MODERATE,utils.GetXUnitsInFront(npcBot,1000);
	end
	
	return 0,0;
end
---------------------------
function ConsiderAncientJanggo()
	local npcBot = GetBot() 
	
	if npcBot:GetActiveMode() == BOT_MODE_ATTACK then
		local TableFriendlyHeroes = npcBot:GetNearbyHeroes(900,false,BOT_MODE_ATTACK);
		if #TableFriendlyHeroes >= 2 then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end
	
	if npcBot:GetActiveMode() == BOT_MODE_RETREAT then
		local TableFriendlyHeroes = npcBot:GetNearbyHeroes(900,false,BOT_MODE_RETREAT);
		if #TableFriendlyHeroes >= 2 then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end

	return BOT_ACTION_DESIRE_NONE;
end
-----------------------------------------------
function ConsiderNecronomicon()
	if npcBot:GetAttackTarget() ~= nil then
		if npcBot:GetAttackTarget():IsHero() then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function ConsiderManta()
	local npcBot = GetBot()
	if npcBot:IsSilenced() then
		return BOT_ACTION_DESIRE_HIGH;
	end
	
	if npcBot:GetAttackTarget() ~= nil then
		if npcBot:GetAttackTarget():IsHero() then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function ConsiderHandOfMidas()
	local npcBot = GetBot();
	local TableNearbyEnemyCreeps = npcBot:GetNearbyCreeps(1000,true);
	
	if TableNearbyEnemyCreeps[1] ~= nil then
		return BOT_ACTION_DESIRE_HIGH,TableNearbyEnemyCreeps[1];
	end
	
	return 0,0;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function ConsiderMagicStick()
	local npcBot = GetBot()
	local itemMagicStick = "item_magic_stick";
	
	for i=0, 5 do
		if(npcBot:GetItemInSlot(i) ~= nil) then
			local _item = npcBot:GetItemInSlot(i):GetName()
			if(_item == itemMagicStick) then
				itemMagicStick = npcBot:GetItemInSlot(i);
			end
		end
	end
	
	if itemMagicStick == "item_magic_stick" then
		return 0;
	end
	
	if npcBot:GetHealth() <= npcBot:GetMaxHealth() * 0.3 or 
		npcBot:GetMana() <= npcBot:GetMaxMana() * 0.3 then
		if itemMagicStick:GetCurrentCharges() > 1 then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE;
end

for k,v in pairs( ability_item_usage_generic ) do	_G._savedEnv[k] = v end