local utils = require(GetScriptDirectory() .. "/util")
local myutil = require(GetScriptDirectory() .. "/myutil")
--print("Farm mode instantiated")
----------------------------------------------------------------------------------------------------

GANK_STATUS = "gank_status";
SEARCH_STATUS = "search_status";


local GankDesire = 0;
local SearchDesire = 0;

local npcBot = GetBot();
status = "";
local min = 0
local sec = 0
local enemyHeroes = {};
local nTarget = enemyHeroes[1];


----------------------------------------------------------------------------------------------------

function GetDesire()
	--print("desire");
	enemyHeroes = GetUnitList(UNIT_LIST_ENEMY_HEROES);
	misEnemise = {};
	nTarget = enemyHeroes[1];
	
	if(DotaTime() > 10 and npcBot:GetActiveMode() ~= BOT_MODE_ROAM)then
		--print("sort");
		nTarget = choseEnemy();
	end
	if(nTarget ~= nil)then
		npcBot:SetTarget(nTarget);
	end
	abilityVendetta = npcBot:GetAbilityByName( "nyx_assassin_vendetta" );
	abilityImpale = npcBot:GetAbilityByName( "nyx_assassin_impale" );
	abilityBurn = npcBot:GetAbilityByName( "nyx_assassin_mana_burn" );
	
	for k,v in pairs(GetTeamPlayers(GetTeam())) do
		local flag = false;
		for i,j in pairs(enemyHeroes) do
			if j:GetPlayerID() == v then
				flag = true;
			end
		end
		if not flag and IsHeroAlive(v) then
			table.insert(misEnemise,v);
		end
	end
	
	if not abilityVendetta:IsFullyCastable() and not npcBot:HasModifier("modifier_nyx_assassin_vendetta") then
		return BOT_MODE_DESIRE_NONE;
	end
	
	-- status = "highest";
	-- return 1.0;
	
	GankDesire = ConsiderGank(enemyHeroes);
	SearchDesire = ConsiderSearch(misEnemise);
	
	local highestDesire = 0;
	if GankDesire > highestDesire then
		highestDesire = GankDesire;
		status = GANK_STATUS;
	elseif SearchDesire > highestDesire then
		highestDesire = SearchDesire;
		status = SEARCH_STATUS;
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
	--print("think");
	local npcBot = GetBot();
	local nTarget = npcBot:GetTarget();
	if status == "" then
		print("wrong");
		return
	end
	
	--print(status);
	
	if status == GANK_STATUS then
		if (npcBot:IsInvisible() and nTarget ~= nil) then
			if(GetUnitToUnitDistance(npcBot,nTarget) < 800) then
				npcBot:Action_AttackUnit(nTarget,true);
				return
			end
			npcBot:Action_MoveToLocation(nTarget:GetLocation());
			return
		end
	elseif status == SEARCH_STATUS then
		return;
	end
end

----------------------------------------------------------------------------------------
function ConsiderGank(enemyHeroes)
	for k,v in pairs(enemyHeroes) do
		if ThinkIfDangerous(v) then
			npcBot:SetTarget(v);
			return BOT_MODE_DESIRE_HIGH;
		end
	end
	return BOT_MODE_DESIRE_NONE;
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function ConsiderSearch(mis)
	-- if mis[1] ~= nil then
		-- return BOT_MODE_DESIRE_MODERATE;
	-- end
	
	return BOT_MODE_DESIRE_NONE;
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function choseEnemy()
	--print("chose");
	table.sort(enemyHeroes,compTarget);
	for k,v in ipairs(enemyHeroes) do
		if(ThinkIfDangerous(v)) then
			return v;
		end
	end
end

----------------------------------------------------------------------------------------
function compTarget(a,b)
	local pointA = npcBot:GetEstimatedDamageToTarget(true,a,2.0,DAMAGE_TYPE_ALL) - a:GetHealth();
	local pointB = npcBot:GetEstimatedDamageToTarget(true,b,2.0,DAMAGE_TYPE_ALL) - b:GetHealth();
	return pointA > pointB;
end

--------------------------------------------------------------------------------------------

function ThinkIfDangerous(target)
	local TableEnemies = target:GetNearbyHeroes(500,false,BOT_MODE_NONE);	
	if TableEnemies ~= nil then
		if #TableEnemies >=3 then
			return false;
		end
		if #TableEnemies == 1 then
			return true;
		end
	end
	return false;
end