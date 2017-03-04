local myutil = require(GetScriptDirectory().."/myutil")

function abilityConsiderTheSwarm()
	local npcBot = GetBot()
	
	--print("swarm "..abilitySwarm:GetBehavior());
	local abilityTheSwarm = npcBot:GetAbilityByName("weaver_the_swarm")
	
	
	
	if npcBot:HasModifier("modifier_weaver_shukuchi") then
		return BOT_ACTION_DESIRE_NONE;
	end
	
	local aRange = abilityTheSwarm:GetCastRange();
	local aRadius = abilityTheSwarm:GetSpecialValueInt("spawn_radius");
	
	
	local TableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	
	
	if npcBot:GetActiveMode() == BOT_MODE_ATTACK then
		local nTarget = myutil.ChoseEnemyTarget();
		if nTarget:GetHealth() <= (nTarget():GetMaxHealth() * 0.4) then
			return BOT_ACTION_DESIRE_MODERATE,nTarget:GetLocation();
		end
	end
	
	if npcBot:GetActiveMode() ~= BOT_MODE_LANING then
		if #TableNearbyEnemyHeroes >= 2 then
			local locationAOE = npcBot:FindAoELocation(true,true,npcBot:GetLocation(),aRange,aRadius,0.4,10000);	
			if locationAOE.count >= 2 then
				return BOT_ACTION_DESIRE_HIGH,locationAOE.targetloc;
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
function abilityConsiderShukuchi()
	local npcBot = GetBot();
	
	local abilityShukuchi = npcBot:GetAbilityByName("weaver_shukuchi");
	
	
	local TableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	local TableNearbyEnemyTowers = npcBot:GetNearbyTowers(1300,true);
	
	if npcBot:GetActiveMode() == BOT_MODE_ATTACK then
		local nTarget;
		if TableNearbyEnemyHeroes[1] ~= nil then
			nTarget = TableNearbyEnemyHeroes[1]
		end
		if npcBot:GetTarget() ~= nil then
			if npcBot:GetTarget():IsHero() and GetTeamForPlayer(npcBot:GetTarget():GetPlayerID()) ~= GetTeam() then
				nTarget = npcBot:GetTarget();
			end
		end
		if npcBot:GetAttackTarget() ~= nil then
			if npcBot:GetAttackTarget():IsHero() then
				nTarget = npcBot:GetAttackTarget();
			end
		end
		if nTarget ~= nil then
			if GetUnitToUnitDistance(npcBot,nTarget) > npcBot:GetAttackRange() then
				npcBot.lastlocation = npcBot:GetLocation();
				return BOT_ACTION_DESIRE_HIGH;
			end
		end
	end
	
	if npcBot:GetActiveMode() == BOT_MODE_RETREAT then
		if #TableNearbyEnemyHeroes >= 2 then
			return BOT_ACTION_DESIRE_MODERATE;
		end
		
		if npcBot:GetHealth() <= (npcBot:GetMaxHealth()*0.35) then
			return BOT_ACTION_DESIRE_HIGH;
		end
	end
	
	if GetUnitToUnitDistance(npcBot,TableNearbyEnemyHeroes[1]) <= 600
	and #TableNearbyEnemyHeroes >= 1 then
		npcBot.lastlocation = npcBot:GetLocation();
		return BOT_ACTION_DESIRE_MODERATE;
	end
	
	return BOT_ACTION_DESIRE_NONE ;
end
function abilityConsiderTimeLapse()
	local npcBot = GetBot();
	
	local abilityTimeLapse = npcBot:GetAbilityByName("weaver_time_lapse")
	
	
	local TableNearbyFriendlyHeroes = npcBot:GetNearbyHeroes(1300,false,BOT_MODE_NONE);
	
	if npcBot:HasScepter() then
		for k,v in ipairs(TableNearbyFriendlyHeroes) do
			if v:GetNearbyHeroes(800,false,BOT_MODE_NONE)[1] ~= nil and v:GetHealth() <= (v:GetMaxHealth()*0.35) then
				return BOT_ACTION_DESIRE_HIGH,v;
			end
		end
	else
		local TableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(600,true,BOT_MODE_NONE);
		if npcBot:GetHealth() <= (npcBot:GetMaxHealth()*0.3) then
			if TableNearbyEnemyHeroes[1] ~= nil then
				return BOT_ACTION_DESIRE_MODERATE;
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end