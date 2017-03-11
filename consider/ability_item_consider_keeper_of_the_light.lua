X = {};
local myutil = require(GetScriptDirectory().."/myutil")
local util = require(GetScriptDirectory().."/util")


function CanCastAbility(target)
	return target:IsHero() and GetTeamForPlayer(target:GetPlayerID()) ~= GetTeam() 
			and not target:IsMagicImmune();
end
function X:abilityConsiderIllumiante()
	local npcBot = GetBot();
	
	local abilityIlluminate = npcBot:GetAbilityByName("keeper_of_the_light_illuminate")
	if npcBot:HasModifier("modifier_keeper_of_the_light_spirit_form") then
		return BOT_ACTION_DESIRE_NONE,0;
	end
	
	local nCastRange = abilityIlluminate:GetCastRange();
	local nTotalDamage = abilityIlluminate:GetSpecialValueInt("total_damage");
	if npcBot:GetLevel() == 25 then
		nTotalDamage = nTotalDamage +abilityIlluminate:GetSpecialValueInt("LinkedSpecialBonus");
	end
	local nRadius = abilityIlluminate:GetSpecialValueInt("radius");
	local nMaxChannelTime = abilityIlluminate:GetSpecialValueFloat("max_channel_time");
	
	
	if npcBot:GetActiveMode() == BOT_MODE_LANING then
		return 0,0;
	end
	
	if npcBot:GetActiveMode() == BOT_MODE_ATTACK then
		if npcBot:GetTarget() ~= nil then
			if CanCastAbility(npcBot:GetTarget()) then
			-- print(1);
				return BOT_ACTION_DESIRE_MODERATE,npcBot:GetTarget():GetExtrapolatedLocation(2);
			end
		end
		local TableEnemyheroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
		local nTarget = TableEnemyheroes[1];
		if nTarget ~= nil then
			return BOT_ACTION_DESIRE_MODERATE,nTarget:GetExtrapolatedLocation(2);
		end
	end
	
	if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP
	or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID
	or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then
		local locationAOE = npcBot:FindAoELocation(true,false,npcBot:GetLocation(),(nCastRange-200),nRadius,0,10000);
		if locationAOE.count >= 3 then
			return BOT_ACTION_DESIRE_MODERATE,locationAOE.targetloc;
		end
		local locationAOEheroes = npcBot:FindAoELocation(true,true,npcBot:GetLocation(),(nCastRange-200),nRadius,0,10000);
		if locationAOEheroes.count >= 2 then
			return BOT_ACTION_DESIRE_HIGH, locationAOEheroes.targetloc;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
function X:abilityConsiderManaLeak()
	local npcBot = GetBot();
	 
	local abilityManaLeak = npcBot:GetAbilityByName("keeper_of_the_light_mana_leak")
	
	local nCastRange = abilityManaLeak:GetCastRange();
	local nAttackRange = npcBot:GetAttackRange();
	
	if npcBot:GetActiveMode() == BOT_MODE_ATTACK
	or npcBot:GetActiveMode() == BOT_MODE_LANING then
		if nAttackRange > nCastRange then
			if npcBot:GetTarget() ~= nil then
				if CanCastAbility(npcBot:GetTarget()) then
					-- print(2);
					return BOT_ACTION_DESIRE_MODERATE,npcBot:GetTarget();
				end
			end
			local nTarget = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE)[1];
			if nTarget ~= nil then
				if GetUnitToUnitDistance(nTarget,npcBot) <= nAttackRange 
				and CanCastAbility(nTarget) then
					-- print(3);
					return BOT_ACTION_DESIRE_HIGH,nTarget;
				end
			end
		else
			if npcBot:GetTarget() ~= nil then
				if CanCastAbility(npcBot:GetTarget()) then
					-- print(4);
					return BOT_ACTION_DESIRE_VERYHIGH,npcBot:GetTarget();
				end
			end
			local nTarget = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE)[1];
			if nTarget ~= nil then
				if GetUnitToUnitDistance(nTarget,npcBot) <= nCastRange 
				and CanCastAbility(nTarget) then
					-- print(5);
					return BOT_ACTION_DESIRE_VERYHIGH,nTarget;
				end
			end
		end
	end
	
	if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP
	or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID
	or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT 
	or npcBot:GetActiveMode() == BOT_MODE_RETREAT then
		local nTarget = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE)[1];
		if nTarget ~= nil then
			if GetUnitToUnitDistance(npcBot,nTarget) and CanCastAbility(nTarget) then
				-- print(6);
				return BOT_ACTION_DESIRE_HIGH, nTarget;
			end
		end
	end
	return BOT_ACTION_DESIRE_NONE,0;
end
function X:abilityConsiderChakraMagic()
	local npcBot= GetBot();
	local abilityChakraMagic = npcBot:GetAbilityByName("keeper_of_the_light_chakra_magic")
	
	local TableFriendlyHeroes = npcBot:GetNearbyHeroes(1000,false,BOT_ACTION_DESIRE_NONE);
	if TableFriendlyHeroes[1] ~= nil then
		table.sort(TableFriendlyHeroes,CompareMana);
		return BOT_ACTION_DESIRE_HIGH,TableFriendlyHeroes[1];
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
function CompareMana(a,b)
	return a:GetMana()/a:GetMaxMana() < b:GetMana()/b:GetMaxMana();
end
function X:abilityConsiderSpiritForm()
	local npcBot = GetBot();
	
	local abilitySpiritForm = npcBot:GetAbilityByName("keeper_of_the_light_spirit_form")
	if  npcBot:HasScepter() then
		return BOT_ACTION_DESIRE_NONE;
	end
	local TableEnemyheroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	
	if #TableEnemyheroes >= 2 then
		return BOT_ACTION_DESIRE_MODERATE;
	end
	
	return BOT_ACTION_DESIRE_NONE;
end
function X:abilityConsiderRecall()
	local npcBot = GetBot();
	
	local abilityRecall = npcBot:GetAbilityByName("keeper_of_the_light_recall")
	
	if  not npcBot:HasModifier("modifier_keeper_of_the_light_spirit_form") then
		return BOT_ACTION_DESIRE_NONE,0;
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
function X:abilityConsiderBlindingLight()
	local npcBot = GetBot();
	
	local abilityBlindingLight = npcBot:GetAbilityByName("keeper_of_the_light_blinding_light")
	
	if not npcBot:HasModifier("modifier_keeper_of_the_light_spirit_form") then
		return BOT_ACTION_DESIRE_NONE,0;
	end
	
	local nCastRange = abilityBlindingLight:GetCastRange();
	local nRadius = abilityBlindingLight:GetSpecialValueInt("radius");
	
	if npcBot:GetActiveMode() == BOT_MODE_ATTACK
	or npcBot:GetActiveMode() == BOT_MODE_RETREAT then
		if npcBot:GetTarget() ~= nil then
			if CanCastAbility(npcBot:GetTarget()) then
				-- print(7);
				if GetUnitToLocationDistance(npcBot,npcBot:GetTarget():GetExtrapolatedLocation(1.0)) < nCastRange then
					return BOT_ACTION_DESIRE_MODERATE,npcBot:GetTarget():GetExtrapolatedLocation(1.0);
				end
			end
		end
		local nTarget = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE)[1];
		if nTarget ~= nil then
			if CanCastAbility(nTarget) then
				-- print(8);
				if GetUnitToLocationDistance(npcBot,nTarget:GetExtrapolatedLocation(1.0)) < nCastRange then
					return BOT_ACTION_DESIRE_MODERATE,nTarget:GetExtrapolatedLocation(1.0);
				end
			end
		end
	end
	
	if  npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP
	or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID
	or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then
		local locationAOE = npcBot:FindAoELocation(true,true,npcBot:GetLocation(),nCastRange,nRadius,0,10000);
		if locationAOE.count >= 3 then
			return BOT_ACTION_DESIRE_MODERATE,locationAOE.targetloc;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
function X:abilityConsiderIllumianteEnd()
	local npcBot = GetBot();
	local abilityIlluminate = npcBot:GetAbilityByName("keeper_of_the_light_illuminate")
	if not abilityIlluminate:IsChanneling()  then
		return BOT_ACTION_DESIRE_NONE,0;
	end
	
	local nCastRange = abilityIlluminate:GetCastRange();
	local nRadius = abilityIlluminate:GetSpecialValueInt("radius");
	
	local TableEnemyheroes = npcBot:GetNearbyHeroes(350,true,BOT_MODE_NONE);
	if TableEnemyheroes[1] ~= nil then
		return BOT_ACTION_DESIRE_HIGH;
	end
	
	if npcBot:GetActiveMode() == BOT_MODE_ATTACK then
		if npcBot:GetTarget() ~= nil then
			if CanCastAbility(npcBot:GetTarget()) then
				-- print(9);
				local point = util.GetXUnitsInFront(npcBot,nCastRange);
				if myutil.checkcreepinrectangle(point,npcBot:GetTarget(),nCastRange,nRadius*2) 
				and not myutil.checkcreepinrectangle(point,npcBot:GetTarget(),nCastRange-200,(nRadius-50)*2)then
					return BOT_ACTION_DESIRE_MODERATE;
				end
			end
		end
		local nTarget = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE)[1];
		if nTarget ~= nil then
			if CanCastAbility(nTarget) then
				-- print(10);
				local point = util.GetXUnitsInFront(npcBot,nCastRange);
				if myutil.checkcreepinrectangle(point,nTarget,nCastRange,nRadius*2) 
				and not myutil.checkcreepinrectangle(point,nTarget,nCastRange-200,(nRadius-50)*2)then
					return BOT_ACTION_DESIRE_MODERATE;
				end
			end
		end
	end
	return BOT_ACTION_DESIRE_NONE;
end
function X:abilityConsiderSpiritFormIlluminate()
	local npcBot = GetBot();
	if not npcBot:HasModifier("modifier_keeper_of_the_light_spirit_form") then
		return BOT_ACTION_DESIRE_NONE,0;
	end
	local abilitySpiritFormIlluminate = npcBot:GetAbilityByName("keeper_of_the_light_spirit_form_illuminate")
	
	local nCastRange = abilitySpiritFormIlluminate:GetCastRange();
	local nTotalDamage = abilitySpiritFormIlluminate:GetSpecialValueInt("total_damage");
	local nRadius = abilitySpiritFormIlluminate:GetSpecialValueInt("radius");
	local nMaxChannelTime = abilitySpiritFormIlluminate:GetSpecialValueFloat("max_channel_time");
	
	
	if npcBot:GetActiveMode() == BOT_MODE_LANING then
		return 0,0;
	end
	
	if npcBot:GetActiveMode() == BOT_MODE_ATTACK then
		if npcBot:GetTarget() ~= nil then
			if CanCastAbility(npcBot:GetTarget()) then
			-- print(11);
				return BOT_ACTION_DESIRE_MODERATE,npcBot:GetTarget():GetExtrapolatedLocation(nMaxChannelTime);
			end
		end
		local TableEnemyheroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
		local nTarget = TableEnemyheroes[1];
		if nTarget ~= nil then
			return BOT_ACTION_DESIRE_MODERATE,nTarget:GetExtrapolatedLocation(nMaxChannelTime);
		end
	end
	
	if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP
	or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID
	or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then
		local locationAOE = npcBot:FindAoELocation(true,false,npcBot:GetLocation(),nCastRange,nRadius,0,10000);
		if locationAOE.count >= 3 then
			return BOT_ACTION_DESIRE_MODERATE,locationAOE.targetloc;
		end
		local locationAOEheroes = npcBot:FindAoELocation(true,true,npcBot:GetLocation(),nCastRange,nRadius,0,10000);
		if locationAOEheroes.count >= 2 then
			return BOT_ACTION_DESIRE_HIGH, locationAOEheroes.targetloc;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
function X:abilityConsiderSpiritFormIlluminateEnd()
	local npcBot = GetBot();
	local abilitySpiritFormIlluminate = npcBot:GetAbilityByName("keeper_of_the_light_spirit_form_illuminate")
	if not abilitySpiritFormIlluminate:IsChanneling() then
		return BOT_ACTION_DESIRE_NONE;
	end
	
	local nCastRange = abilitySpiritFormIlluminate:GetCastRange();
	local nRadius = abilitySpiritFormIlluminate:GetSpecialValueInt("radius");
	
	if npcBot:GetActiveMode() == BOT_MODE_ATTACK then
		if npcBot:GetTarget() ~= nil then
			if CanCastAbility(npcBot:GetTarget()) then
			-- print(12);
				local point = util.GetXUnitsInFront(npcBot,nCastRange);
				if myutil.checkcreepinrectangle(point,npcBot:GetTarget(),nCastRange,nRadius*2) 
				and not myutil.checkcreepinrectangle(point,npcBot:GetTarget(),nCastRange-200,(nRadius-50)*2)then
					return BOT_ACTION_DESIRE_MODERATE;
				end
			end
		end
		local nTarget = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE)[1];
		if nTarget ~= nil then
			if CanCastAbility(nTarget) then
			-- print(13);
				local point = util.GetXUnitsInFront(npcBot,nCastRange);
				if myutil.checkcreepinrectangle(point,nTarget,nCastRange,nRadius*2) 
				and not myutil.checkcreepinrectangle(point,nTarget,nCastRange-200,(nRadius-50)*2)then
					return BOT_ACTION_DESIRE_MODERATE;
				end
			end
		end
	end
	return BOT_ACTION_DESIRE_NONE;
end

return X;