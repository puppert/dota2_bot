local utils = require(GetScriptDirectory() .. "/util")
local myutil = require(GetScriptDirectory() .. "/myutil")
--print("Farm mode instantiated")
----------------------------------------------------------------------------------------------------

STATUS_HARRY = "Status_Harry";
STATUS_KILL = "Status_Kill";
STATUS_TEAM = "Status_Team";

local WeaverAttackstatus = "";

local HarryDesire = 0;
local KillDesire = 0;
local TeamDesire = 0;
local npcBot = GetBot();



----------------------------------------------------------------------------------------------------

function GetDesire()
	
	HarryDesire = ConsiderHarry();
	KillDesire = ConsiderKill();
	TeamDesire = ConsiderTeam();
	
	
	if npcBot:GetHealth() <= npcBot:GetMaxHealth()*0.3 
	or npcBot:GetMana() <= 70 then
		return 0;
	end
	
	
	local highestDesire = 0;
	if HarryDesire > highestDesire then
		highestDesire = HarryDesire;
		WeaverAttackstatus = STATUS_HARRY;
	elseif KillDesire > highestDesire then
		highestDesire = KillDesire;
		WeaverAttackstatus = STATUS_KILL;
	elseif TeamDesire > highestDesire then
		highestDesire = TeamDesire;
		WeaverAttackstatus = STATUS_TEAM;
	end
	
	if WeaverAttackstatus == STATUS_HARRY and npcBot:GetNearbyTowers(1000,true)[1] ~= nil then
		return 0 ;
	end
	
	return highestDesire;
end

----------------------------------------------------------------------------------------------------
function OnStart()
	
end
----------------------------------------------------------------------------------------------------
function OnEnd() 

end
----------------------------------------------------------------------------------------------------
function Think()
	if WeaverAttackstatus == "" then
		print("weaver wrong");
		return
	else
		print(WeaverAttackstatus);
	end
	
	if not npcBot:HasModifier("modifier_weaver_shukuchi") then
		npcBot.shukuchi = false;
	end
	
	if WeaverAttackstatus == STATUS_HARRY then
		if npcBot:HasModifier("modifier_weaver_shukuchi") then
			local location = npcBot.lastlocation;
			if GetUnitToUnitDistance(npcBot:GetTarget(),npcBot) <= 50 then
				npcBot.shukuchi = true;
			end
			if not npcBot.shukuchi then 
				npcBot:Action_MoveToLocation(npcBot:GetTarget():GetLocation());
			else
				npcBot:Action_MoveToLocation(location);
			end
		else
			npcBot:Action_AttackUnit(npcBot:GetTarget(),false);
		end
	elseif WeaverAttackstatus == STATUS_KILL then
		if npcBot:HasModifier("modifier_weaver_shukuchi") then
			npcBot:Action_MoveToLocation(npcBot:GetTarget():GetLocation());
			if GetUnitToUnitDistance(npcBot:GetTarget(),npcBot) == 0 then
				npcBot:Action_AttackUnit(npcBot:GetTarget(),false);
			end
		else
			npcBot:Action_AttackUnit(npcBot:GetTarget(),false);
		end
	elseif WeaverAttackstatus == STATUS_TEAM then
		if npcBot:HasModifier("modifier_weaver_shukuchi") then
			npcBot:Action_MoveToLocation(npcBot:GetTarget():GetLocation());
			if GetUnitToUnitDistance(npcBot:GetTarget(),npcBot) == 0 then
				npcBot:Action_AttackUnit(npcBot:GetTarget(),false);
			end
		else
			npcBot:Action_AttackUnit(npcBot:GetTarget(),false);
		end
	end
end
----------------------------------------------------------------------------------------
function ConsiderHarry()
	local TableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE); 
	local TableNearbyEnemyTowers = npcBot:GetNearbyTowers(900,true);
	
	local nRange = npcBot:GetAttackRange();
	
	
	if TableNearbyEnemyHeroes[1] ~= nil and TableNearbyEnemyTowers[1] == nil then
		if GetUnitToUnitDistance(npcBot,TableNearbyEnemyHeroes[1]) <= (nRange+400) then
			if npcBot:GetHealth() >= (npcBot:GetMaxHealth()*0.7) then
				npcBot:SetTarget(TableNearbyEnemyHeroes[1])
				return BOT_MODE_DESIRE_MODERATE;
			end
		end
	end
	
	return BOT_MODE_DESIRE_NONE
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ------
function ConsiderKill()
	local TableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE); 
	local TableNearbyFriendlyHeroes = npcBot:GetNearbyHeroes(1300,false,BOT_MODE_NONE);
	local TableNearbyEnemyTowers = npcBot:GetNearbyTowers(900,true);
	
	if TableNearbyEnemyHeroes[1] ~= nil then
		if #TableNearbyEnemyHeroes <= (#TableNearbyFriendlyHeroes - 2) 
		and TableNearbyEnemyTowers[1] == nil then
			npcBot:SetTarget(TableNearbyEnemyHeroes[1])
			return BOT_MODE_DESIRE_MODERATE;
		end
		table.sort(TableNearbyEnemyHeroes,function(a,b)
											return a:GetHealth() < b:GetHealth();
										  end)
		for k,v in ipairs(TableNearbyEnemyHeroes) do
			if v:GetHealth() <= v:GetActualIncomingDamage(npcBot:GetAttackDamage()*3,DAMAGE_TYPE_PHYSICAL) then
				npcBot:SetTarget(v);
				return BOT_MODE_DESIRE_VERYHIGH;
			end
		end
	end
	
	return BOT_MODE_DESIRE_NONE
end
---------------------------------------------------------------------------------------
function ConsiderTeam()
	local EnemyHeroes = GetUnitList(UNIT_LIST_ENEMY_HEROES);
	local TableNearbyFriendlyHeroes = npcBot:GetNearbyHeroes(1300,false,BOT_MODE_ATTACK);
	table.sort(EnemyHeroes,CompareDis);
	if #TableNearbyFriendlyHeroes >= 2 and EnemyHeroes [1] ~= nil then
		if GetUnitToUnitDistance(npcBot,EnemyHeroes[1]) <= 3000 then
			npcBot:SetTarget(EnemyHeroes[1]);
			return BOT_MODE_DESIRE_HIGH;
		end
	end

	return BOT_MODE_DESIRE_NONE
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ----
function CompareDis(a,b)
	return GetUnitToUnitDistance(npcBot,a) < GetUnitToUnitDistance(npcBot,b);
end