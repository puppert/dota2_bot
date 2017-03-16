X = {};
local myutil =require(GetScriptDirectory().."/myutil")

function CanCastShapeDesireOnTarget( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsInvulnerable();
end
function X:abilityConsiderHowl()
	local npcBot = GetBot();
	
	--print("use howl")
	local abilityHowl = npcBot:GetAbilityByName("lycan_howl")
	-- Make sure it's castable
	if ( abilityHowl:IsFullyCastable() and not npcBot:IsUsingAbility()) then 
		return BOT_ACTION_DESIRE_MODERATE;
	end;

	return BOT_ACTION_DESIRE_NONE;

end
function X:abilityConsiderSummonWolves()
	local npcBot = GetBot();
	
	local abilitySunmonWolves = npcBot:GetAbilityByName("lycan_summon_wolves")
	
	if npcBot.summon == nil then
		npcBot.summon = {};
	end
	
	local summonwolves = npcBot.summon;
	
	if(npcBot:GetMana() >400 and summonwolves[1] == nil) then
		return BOT_ACTION_DESIRE_MODERATE;
	end
	
	return BOT_ACTION_DESIRE_NONE;
end
function X:abilityConsiderShapeshift()
	local npcBot = GetBot();
	
	local abilityShapeShift = npcBot:GetAbilityByName("lycan_shapeshift")
	
	if(npcBot:GetActiveMode() == BOT_MODE_FARM)
		then
		return BOT_ACTION_DESIRE_NONE;
	end
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( 1300, true, BOT_MODE_NONE );
	local npcTarget = tableNearbyEnemyHeroes[1];
	
	if(npcBot:GetActiveMode() ~= BOT_MODE_LANING
	and npcBot:GetActiveMode() ~= BOT_MODE_FARM
	and npcBot:GetActiveMode() ~= BOT_MODE_RETREAT
	and npcTarget ~= nil) then
		if(GetUnitToUnitDistance(npcBot,npcTarget)<900) then
			--print("use shape attack");
			return BOT_ACTION_DESIRE_HIGH;
		end
	end
	
	if(npcBot:GetActiveMode() == BOT_MODE_RETREAT
		and not npcBot:IsUsingAbility()
		and abilityShapeShift:IsFullyCastable()
		) then
		if(#tableNearbyEnemyHeroes >= 2) then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE;
end 

return X;