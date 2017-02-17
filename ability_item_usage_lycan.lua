local myutil =require(GetScriptDirectory().."/myutil")
require( GetScriptDirectory().."/ability_item_usage_generic" );
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------

function BuybackUsageThink()
	--print(GetLaneFrontAmount(GetTeam(),LANE_MID,true));
	GetBot().tablefunction = getfenv();
end

------------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------
-- function CanCastShapeDesireOnTarget( npcTarget )
	-- return npcTarget:CanBeSeen() and not npcTarget:IsInvulnerable();
-- end
-- ----------------------------------------------------------------------------------------------------

-- function ConsiderHowl()
	-- local npcBot = GetBot();
	
	
	-- local abilityHowl = npcBot.ability["abilityHowl"]
	-- -- Make sure it's castable
	-- if ( abilityHowl:IsFullyCastable() and not npcBot:IsUsingAbility()) then 
		-- return BOT_ACTION_DESIRE_MODERATE;
	-- end;

	-- return BOT_ACTION_DESIRE_NONE;

-- end
-- ----------------------------------------------------------------------------------------------------
-- function ConsiderSummonWolves()
	-- local npcBot = GetBot();
	
	-- local abilitySunmonWolves = npcBot.ability["abilitySunmonWolves"]
	
	-- if npcBot.summon == nil then
		-- npcBot.summon = {};
	-- end
	
	-- local summonwolves = npcBot.summon;
	
	-- if(npcBot:GetMana() >400 and summonwolves[1] == nil) then
		-- return BOT_ACTION_DESIRE_MODERATE;
	-- end
	
	-- return BOT_ACTION_DESIRE_NONE;
-- end

-- ----------------------------------------------------------------------------------------------------
-- function ConsiderShapeshift()
	-- local npcBot = GetBot();
	
	-- local abilityShapeShift = npcBot.ability["abilityShapeshift"]
	
	-- if(npcBot:GetActiveMode() == BOT_MODE_FARM)
		-- then
		-- return BOT_ACTION_DESIRE_NONE;
	-- end
	
	-- local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 1300, true, BOT_MODE_NONE );
	-- local npcTarget = tableNearbyEnemyHeroes[1];
	
	-- if(npcBot:GetActiveMode() ~= BOT_MODE_LANING
	-- and npcBot:GetActiveMode() ~= BOT_MODE_FARM
	-- and npcBot:GetActiveMode() ~= BOT_MODE_RETREAT
	-- and npcTarget ~= nil) then
		-- if(GetUnitToUnitDistance(npcBot,npcTarget)<900) then
			-- --print("use shape attack");
			-- return BOT_ACTION_DESIRE_HIGH;
		-- end
	-- end
	
	-- if(npcBot:GetActiveMode() == BOT_MODE_RETREAT
		-- and not npcBot:IsUsingAbility()
		-- and abilityShapeShift:IsFullyCastable()
		-- ) then
		-- if(#tableNearbyEnemyHeroes >= 2) then
			-- return BOT_ACTION_DESIRE_MODERATE;
		-- end
	-- end
	
	-- return BOT_ACTION_DESIRE_NONE;
-- end 

----------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
