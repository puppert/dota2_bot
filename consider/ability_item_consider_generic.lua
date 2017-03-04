module("ability_item_consider_generic",package.seeall)
local myutil = require(string.gsub(GetScriptDirectory(),"consider","") .. "myutil");
local utils = require(string.gsub(GetScriptDirectory(),"consider","") .. "util");


function itemConsiderTango()
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
function itemConsiderClarity()
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
function itemConsiderTpscroll()
	local npcBot = GetBot();
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
					
					return BOT_ACTION_DESIRE_HIGH,GetAncient(GetTeam()):GetLocation();
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
			return BOT_ACTION_DESIRE_MODERATE, GetAncient(GetTeam()):GetLocation();
		end
	end
	
	return BOT_ACTION_DESIRE_NONE,0
end
-----------------------------------------------------------------------------------------------
function itemConsiderGhost()
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
function itemConsiderGlimmerCape()
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
function itemConsiderSheepstick()
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
function itemConsiderFlask()
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
function itemConsiderArmlet()
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
function itemConsiderBlackKingBar()
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
function itemConsiderBottle()
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
function itemConsiderBladeMail()
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
function itemConsiderShivasGuard()
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
function itemConsiderMjollnir()
	local npcBot = GetBot();
	
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	if(tableNearbyEnemyHeroes[1] ~= nil) then
		return BOT_ACTION_DESIRE_MODERATE;
	end
	
	
	return BOT_ACTION_DESIRE_NONE;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function itemConsiderPowerTreads()
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
function itemConsiderArcaneBoots()
	local npcBot = GetBot();
	
	
	local nRadius = 900;
	local rMana = 135;
	
	if npcBot:GetMana() <= (npcBot:GetMaxMana() - 135) then
		return BOT_ACTION_DESIRE_HIGH;
	end
	
	return BOT_ACTION_DESIRE_NONE;
end
----------------------------------------------------------------------------------------------------
function itemConsiderMekansm()
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
function itemConsiderGuardianGreaves()
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
function itemConsiderMedallionOfCourage()
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
function itemConsiderSolarCrest()
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
function itemConsiderBlink()
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
function itemConsiderAncientJanggo()
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
function itemConsiderNecronomicon()
	if npcBot:GetAttackTarget() ~= nil then
		if npcBot:GetAttackTarget():IsHero() then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function itemConsiderManta()
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
function itemConsiderHandOfMidas()
	local npcBot = GetBot();
	local TableNearbyEnemyCreeps = npcBot:GetNearbyCreeps(1000,true);
	
	if TableNearbyEnemyCreeps[1] ~= nil then
		return BOT_ACTION_DESIRE_HIGH,TableNearbyEnemyCreeps[1];
	end
	
	return 0,0;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function itemConsiderMagicStick()
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