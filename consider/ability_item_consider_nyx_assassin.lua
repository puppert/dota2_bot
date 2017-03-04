local myutil = require(GetScriptDirectory() .. "/myutil")

function CanUseImpale()
	local npcBot = GetBot();
	if(npcBot:GetTarget() ~= nil )then
		--print(npcBot:GetTarget():GetUnitName());
		return npcBot:GetTarget():IsHero() and GetTeamForPlayer(npcBot:GetTarget():GetPlayerID()) ~= GetTeam()
			and not npcBot:GetTarget():IsMagicImmune();
	end
end
function abilityConsiderImpale()
	local npcBot = GetBot();
	local abilityImpale = npcBot:GetAbilityByName("nyx_assassin_impale")
	
	
	if(npcBot:HasModifier("modifier_nyx_assassin_vendetta")) then
		return BOT_ACTION_DESIRE_NONE,0;
	end
	
	local nWidth = abilityImpale:GetSpecialValueInt("width");
	local nDuration = abilityImpale:GetSpecialValueFloat("duration");
	local nRange = abilityImpale:GetCastRange();
	local nPoint = abilityImpale:GetCastPoint();
	local nDamage = abilityImpale:GetAbilityDamage();
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	local nTarget = tableNearbyEnemyHeroes[1];
	
	if(npcBot:GetActiveMode() == BOT_MODE_LANING) then
		local weakcreep = nil;
		local tableNearbyEnemy = npcBot:GetNearbyCreeps(nRange,true);
		if(tableNearbyEnemy[1] ~= nil) then
			if(nTarget ~= nil) then
				for k,v in pairs(tableNearbyEnemy) do
					if(v:GetHealth() <= (nDamage+30)) then
						weakcreep = v;
						break;
					end	
				end
				if(weakcreep ~= nil and npcBot:GetMana() >= (npcBot:GetMaxMana()*0.95)) then
					if(myutil.checkcreepinrectangle(nTarget:GetLocation(),weakcreep,nRange,nWidth)) then
						return BOT_ACTION_DESIRE_HIGH,nTarget:GetLocation();
					end
				end
			end
			if(npcBot:GetMana() >= (npcBot:GetMaxMana()*0.4)) then
				local locationAoE = npcBot:FindAoELocation(true,false,npcBot:GetLocation(),nRange,nWidth/2,0,nDamage);
				if(locationAoE.count >= 3) then
					return BOT_ACTION_DESIRE_MODERATE,locationAoE.targetloc;
				end
			end
		end
	end
	
	if(npcBot:GetActiveMode() == BOT_MODE_ATTACK
	or npcBot:GetActiveMode() == BOT_MODE_ROAM
	or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM) then
		if(CanUseImpale()) then
			local point = npcBot:GetTarget():GetLocation();
			if(GetUnitToLocationDistance(npcBot,point) <= nRange) then
				return BOT_ACTION_DESIRE_HIGH,point;
			end
		else 
			local locationAoE = npcBot:FindAoELocation(true,true,npcBot:GetLocation(),nRange,nWidth/2,0,10000);
			if(locationAoE.count >= 2) then
				--print("444444");
				return BOT_ACTION_DESIRE_HIGH,locationAoE.targetloc;
			end
		end
	end
	
	if(npcBot:GetActiveMode()== BOT_MODE_FARM) then
		local locationAoE = npcBot:FindAoELocation(true,false,npcBot:GetLocation(),nRange,nWidth/2,0,nDamage);
		if(locationAoE.count >= 3) then
			return BOT_ACTION_DESIRE_MODERATE,locationAoE.targetloc;
		end
	end
	
	
	if(npcBot:GetActiveMode() == BOT_MODE_RETREAT) then
		if(nTarget ~= nil) then
			if(GetUnitToUnitDistance(npcBot,nTarget) <= 400) then
				return BOT_ACTION_DESIRE_HIGH,nTarget:GetLocation();
			end
		end
	end
	
	if(	npcBot:GetActiveMode() ~= BOT_MODE_LANING
	and npcBot:GetActiveMode() ~= BOT_MODE_ATTACK
	and npcBot:GetActiveMode() ~= BOT_MODE_ROAM
	and npcBot:GetActiveMode() ~= BOT_MODE_TEAM_ROAM
	and npcBot:GetActiveMode() ~= BOT_MODE_RETREAT
	and npcBot:GetActiveMode() ~= BOT_MODE_FARM) then
		if(npcBot:GetMana() >= (npcBot:GetMaxMana()*0.6)) then
			local locationAoE = npcBot:FindAoELocation(true,false,npcBot:GetLocation(),nRange,nWidth/2,0,10000);
			if(locationAoE.count >= 3) then
				return BOT_ACTION_DESIRE_MODERATE,locationAoE.targetloc;
			end
		end
		local locationAoE = npcBot:FindAoELocation(true,true,npcBot:GetLocation(),nRange,nWidth/2,0,10000);
		if(locationAoE.count >= 2) then
			return BOT_ACTION_DESIRE_HIGH,locationAoE.targetloc;
		end
		if(nTarget ~= nil) then
			for k,v in pairs(tableNearbyEnemyHeroes) do 
				if(v:GetHealth() < v:GetActualIncomingDamage(nDamage,DAMAGE_TYPE_MAGICAL)) then
					return BOT_ACTION_DESIRE_HIGH,v:GetLocation();
				end
			end
		end			
	end
	
	if(npcBot:HasModifier("modifier_nyx_assassin_burrow"))then
		--print("1111");
		if(nTarget ~= nil) then
			return BOT_ACTION_DESIRE_HIGH,nTarget:GetLocation();
		end
	end
	
	
	return BOT_ACTION_DESIRE_NONE ,0;
end
function abilityConsiderManaBurn()
	local npcBot = GetBot();
	local abilityManaBurn = npcBot:GetAbilityByName("nyx_assassin_mana_burn")
	
	if(npcBot:HasModifier("modifier_nyx_assassin_vendetta")) then
		return BOT_ACTION_DESIRE_NONE,0;
	end
	
	local nRange = abilityManaBurn:GetCastRange();
	local nFloat = abilityManaBurn:GetSpecialValueFloat("float_multiplier");
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	local nTarget = tableNearbyEnemyHeroes[1];
	
	if(npcBot:GetActiveMode() == BOT_MODE_LANING 
	or npcBot:GetActiveMode() == BOT_MODE_RETREAT)then
		return BOT_ACTION_DESIRE_NONE,0;
	end
	
	if(npcBot:GetActiveMode() ~= BOT_MODE_LANING)then
		if(nTarget ~= nil ) then
			if(nTarget:GetMana() >= 140) then
				return BOT_ACTION_DESIRE_MODERATE,nTarget;
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
end
function abilityConsiderSpikedCarapace()
	local npcBot = GetBot();
	local abilitySpikedCarapace = npcBot:GetAbilityByName("nyx_assassin_spiked_carapace")
	
	
	local nAOE = abilitySpikedCarapace:GetSpecialValueInt("burrow_aoe");
	local nDuration = abilitySpikedCarapace:GetSpecialValueFloat("reflect_duration");
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	local nTarget = tableNearbyEnemyHeroes[1];
	
	local TrackingProjectiles = npcBot:GetIncomingTrackingProjectiles();
	
	if TrackingProjectiles[1] ~= nil then
		table.sort(TrackingProjectiles,function(a,b) 
												return GetUnitToLocationDistance(npcBot,a["location"]) < GetUnitToLocationDistance(npcBot,b["location"]);
										end)
		local cloestProjectiles = TrackingProjectiles[1];
		if GetUnitToLocationDistance(npcBot,cloestProjectiles.location) <= 500 then
			if npcBot:GetHealth() <= 300 or npcBot:GetMana() >= (npcBot:GetMaxMana() * 0.8)then
				return 0.8
			elseif not cloestProjectiles.is_attack then
				return 0.8
			end
		end
	end
	
	if(nTarget ~= nil) then
		if(GetUnitToUnitDistance(npcBot,nTarget) <= 200
		and nTarget:GetStunDuration(true) <=0.2) then
			return 0.7;
		end
	end
	
	if(npcBot:HasModifier("modifier_nyx_assassin_burrow"))then
		--print("1111");
		if(nTarget ~= nil) then
			if(GetUnitToUnitDistance(nTarget,npcBot) <= 300
			and nTarget:GetStunDuration(true) <= 0.2) then
				return BOT_ACTION_DESIRE_HIGH;
			end
		end
	end
	
	
	return BOT_ACTION_DESIRE_NONE;
end
function abilityConsiderVendetta()
	local npcBot = GetBot();
	
	local abilityVendetta = npcBot:GetAbilityByName("nyx_assassin_vendetta")
	
	
	local nDamage = abilityVendetta:GetSpecialValueInt("bonus_damage");
	local nDuration = abilityVendetta:GetSpecialValueFloat("duration");
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	local nTarget = tableNearbyEnemyHeroes[1];
	
	
	if(npcBot:GetActiveMode() == BOT_MODE_ROAM) then
		return BOT_MODE_DESIRE_ABSOLUTE;
	end
	
	
	return BOT_ACTION_DESIRE_NONE;
end
function abilityConsiderBurrow()
	local npcBot = GetBot();
	
	local abilityBurrow = npcBot:GetAbilityByName("nyx_assassin_burrow")
	
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	local nTarget = tableNearbyEnemyHeroes[1];
	
	if(nTarget ~= nil and npcBot:HasScepter() and not npcBot:HasModifier("modifier_nyx_assassin_burrow")) then
		if((abilityImpale:GetCastRange()+500) > GetUnitToUnitDistance(npcBot,nTarget)) then
			return BOT_ACTION_DESIRE_HIGH;
		end	
	end
	
	
	return BOT_ACTION_DESIRE_NONE;
end
function abilityConsiderUnburrow()
	local npcBot = GetBot();
	
	local abilityUnburrow = npcBot:GetAbilityByName("nyx_assassin_unburrow")
	
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	local nTarget = tableNearbyEnemyHeroes[1];
	
	if(nTarget ~= nil and npcBot:HasScepter() and npcBot:HasModifier("modifier_nyx_assassin_burrow")) then
		if((abilityImpale:GetCastRange()+500) < GetUnitToUnitDistance(npcBot,nTarget)) then
			return BOT_ACTION_DESIRE_HIGH;
		end	
	end
	
	if(nTarget == nil)then
		return BOT_ACTION_DESIRE_HIGH;
	end
	
	return BOT_ACTION_DESIRE_NONE ;
end