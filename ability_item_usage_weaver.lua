local myutil = require(GetScriptDirectory().."/myutil")
local home = require(GetScriptDirectory().."/constant_each_side")
local support = require(GetScriptDirectory().."/support_item")
require( GetScriptDirectory().."/ability_item_usage_generic" );
----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

function BuybackUsageThink()
	if GetBot().tablefunction == nil then
		GetBot().tablefunction = getfenv();
	end
end

------------------------------------------------------------------------------------------------------

-- function ConsiderTheSwarm()
	-- local npcBot = GetBot()
	
	-- --print("swarm "..abilitySwarm:GetBehavior());
	-- local abilityTheSwarm = npcBot.ability["abilityTheSwarm"]
	
	
	
	-- if npcBot:HasModifier("modifier_weaver_shukuchi") then
		-- return BOT_ACTION_DESIRE_NONE;
	-- end
	
	-- local aRange = abilityTheSwarm:GetCastRange();
	-- local aRadius = abilityTheSwarm:GetSpecialValueInt("spawn_radius");
	
	
	-- local TableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	
	
	-- if npcBot:GetActiveMode() == BOT_MODE_ATTACK then
		-- if #TableNearbyEnemyHeroes >= 2 then
			-- local locationAOE = npcBot:FindAoELocation(true,true,npcBot:GetLocation(),aRange,aRadius,0.4,10000);	
			-- if locationAOE.count >= 2 then
				-- return BOT_ACTION_DESIRE_HIGH,locationAOE.targetloc;
			-- end
		-- end
		-- if npcBot:GetTarget() ~= nil then
			-- local nTarget = npcBot:GetTarget();
			-- if nTarget:IsHero() and GetTeamForPlayer(nTarget:GetPlayerID()) ~= GetTeam() then
				-- return BOT_ACTION_DESIRE_MODERATE,nTarget:GetLocation();
			-- end
		-- end
		-- if TableNearbyEnemyHeroes[1] ~= nil then
			-- return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1]:GetLocation();
		-- end
	-- end
	
	-- if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT
	-- and npcBot:GetActiveMode() ~= BOT_MODE_LANING then
		-- if #TableNearbyEnemyHeroes >= 2 then
			-- local locationAOE = npcBot:FindAoELocation(true,true,npcBot:GetLocation(),aRange,aRadius,0.4,10000);	
			-- if locationAOE.count >= 2 then
				-- return BOT_ACTION_DESIRE_HIGH,locationAOE.targetloc;
			-- end
		-- end
	-- end
	
	-- return BOT_ACTION_DESIRE_NONE,0;
-- end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ---

-- function ConsiderShukuchi()
	-- local npcBot = GetBot();
	
	-- local abilityShukuchi = npcBot.ability["abilityShukuchi"];
	
	
	-- local TableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	-- local TableNearbyEnemyTowers = npcBot:GetNearbyTowers(1300,true);
	
	-- if npcBot:GetActiveMode() == BOT_MODE_ATTACK then
		-- local nTarget;
		-- if TableNearbyEnemyHeroes[1] ~= nil then
			-- nTarget = TableNearbyEnemyHeroes[1]
		-- end
		-- if npcBot:GetTarget() ~= nil then
			-- if npcBot:GetTarget():IsHero() and GetTeamForPlayer(npcBot:GetTarget():GetPlayerID()) ~= GetTeam() then
				-- nTarget = npcBot:GetTarget();
			-- end
		-- end
		-- if npcBot:GetAttackTarget() ~= nil then
			-- if npcBot:GetAttackTarget():IsHero() then
				-- nTarget = npcBot:GetAttackTarget();
			-- end
		-- end
		-- if nTarget ~= nil then
			-- if GetUnitToUnitDistance(npcBot,nTarget) > npcBot:GetAttackRange() then
				-- npcBot.lastlocation = npcBot:GetLocation();
				-- return BOT_ACTION_DESIRE_HIGH;
			-- end
		-- end
	-- end
	
	-- if npcBot:GetActiveMode() == BOT_MODE_RETREAT then
		-- if #TableNearbyEnemyHeroes >= 2 then
			-- return BOT_ACTION_DESIRE_MODERATE;
		-- end
		
		-- if npcBot:GetHealth() <= (npcBot:GetMaxHealth()*0.35) then
			-- return BOT_ACTION_DESIRE_HIGH;
		-- end
	-- end
	
	-- if GetUnitToUnitDistance(npcBot,TableNearbyEnemyHeroes[1]) <= 600
	-- and #TableNearbyEnemyHeroes >= 1 then
		-- return BOT_ACTION_DESIRE_MODERATE;
	-- end
	
	-- return BOT_ACTION_DESIRE_NONE ;
-- end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- function ConsiderTimeLapse()
	-- local npcBot = GetBot();
	
	-- local abilityTimeLapse = npcBot.ability["abilityTimeLapse"]
	
	
	-- local TableNearbyFriendlyHeroes = npcBot:GetNearbyHeroes(1300,false,BOT_MODE_NONE);
	
	-- if npcBot:HasScepter() then
		-- for k,v in ipairs(TableNearbyFriendlyHeroes) do
			-- if v:GetNearbyHeroes(800,false,BOT_MODE_NONE)[1] ~= nil and v:GetHealth() <= (v:GetMaxHealth()*0.35) then
				-- return BOT_ACTION_DESIRE_HIGH,v;
			-- end
		-- end
	-- else
		-- local TableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(600,true,BOT_MODE_NONE);
		-- if npcBot:GetHealth() <= (npcBot:GetMaxHealth()*0.3) then
			-- if TableNearbyEnemyHeroes[1] ~= nil then
				-- return BOT_ACTION_DESIRE_MODERATE;
			-- end
		-- end
	-- end
	
	-- return BOT_ACTION_DESIRE_NONE,0;
-- end
	
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


