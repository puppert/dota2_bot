function GetDesire()
	local npcBot = GetBot();
	
	--check hero status
	if npcBot:GetHealth() <= npcBot:GetMaxHealth()*0.3 and
	npcBot:GetMana() <= npcBot:GetMaxMana() *0.2 then
		return BOT_MODE_DESIRE_HIGH
	end
	
	if npcBot:GetMana() <= npcBot:GetMaxMana() * 0.1 and
	(not npcBot:HasModifier("modifier_clarity_potion") or npcBot:GetManaRegen() < 10)then 
		return BOT_MODE_DESIRE_MODERATE
	end
	
	if npcBot:GetHealth() <= npcBot:GetMaxHealth()* 0.3 and
	(not npcBot:HasModifier("modifier_tango_heal") or not npcBot:HasModifier("modifier_flask_healing") or npcBot:GetHealthRegen() < 15) then
		return BOT_MODE_DESIRE_HIGH
	end
	
	-- check if dangerous
	
	if npcBot:WasRecentlyDamagedByTower(0.3) then
		return BOT_MODE_DESIRE_MODERATE
	end
	
	local TableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1600,true,BOT_MODE_NONE);
	local TableNearbyFriendlyHeroes = npcBot:GetNearbyHeroes(1000,false,BOT_MODE_NONE);
	
	if #TableNearbyEnemyHeroes - #TableNearbyFriendlyHeroes >= 2 then
		return BOT_MODE_DESIRE_HIGH
	elseif #TableNearbyEnemyHeroes - #TableNearbyFriendlyHeroes == 1 then
		return BOT_MODE_DESIRE_LOW
	end
	
	return 0;
end



function OnStart()
end


function OnEnd()
end
