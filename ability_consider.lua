
module("ability_consider", package.seeall )
local myutil = require(GetScriptDirectory() .. "/myutil")
local utils = require(GetScriptDirectory() .. "/util")

--abaddon
function ConsiderDeathCoil()
	local npcBot = GetBot();
	local abilityDeathCoil = npcBot:GetAbilityByName("abaddon_death_coil");
	
	local aTargetDamage = abilityDeathCoil:GetSpecialValueFloat("target_damage");
	local aHealAmount = abilityDeathCoil:GetSpecialValueInt("heal_amount");
	local aSelfDamage = abilityDeathCoil:GetSpecialValueFloat("self_damage");
	
	local TableFriendlyHeroes = npcBot:GetNearbyHeroes(1300,false,BOT_MODE_NONE);
	local TableEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	
	if npcBot:GetActiveMode() == BOT_MODE_LANING then
		if npcBot:GetMana() >= (npcBot:GetMaxMana()*0.6) and
		npcBot:GetHealth() >= (npcBot:GetMaxHealth() *0.5) then
			if TableFriendlyHeroes[1] ~= nil then
				for k,v in ipairs(TableFriendlyHeroes) do
					if v:GetPlayerID() ~= npcBot:GetPlayerID() then
						if v:GetHealth() <= v:GetMaxHealth()*0.5 then
							return BOT_ACTION_DESIRE_MODERATE,v;
						end
					end
				end
			end
			local nTarget = myutil:ChoseEnemyTarget();
			if	nTarget ~= nil then
				return BOT_ACTION_DESIRE_MODERATE,TableEnemyHeroes[1];
			end
		end
	end
	
	if npcBot:GetActiveMode() == BOT_MODE_RETREAT then
		if npcBot:GetHealth()-100 >= npcBot:GetActualIncomingDamage(aSelfDamage) then
			if TableFriendlyHeroes[1] ~= nil then
				table.sort(TableFriendlyHeroes,function(a,b) 
													return a:GetHealth() < b:GetHealth() 
												end)
				return	BOT_ACTION_DESIRE_MODERATE,TableFriendlyHeroes[1];
			end
			if TableEnemyHeroes[1] ~= nil then
				table.sort(TableFriendlyHeroes,function(a,b) 
													return a:GetHealth() < b:GetHealth() 
												end)
				if TableEnemyHeroes[1]:GetActualIncomingDamage(aTargetDamage) <= TableEnemyHeroes[1]:GetHealth() then
					return BOT_ACTION_DESIRE_HIGH,TableEnemyHeroes[1];
				end
			end
		end
	end
	
	if npcBot:GetActiveMode() ~= BOT_MODE_LANING and npcBot:GetActiveMode() == BOT_MODE_RETREAT then
		if npcBot:HasModifier("modifier_abaddon_borrowed_time") or (npcBot:GetHealth() >= aSelfDamage + 100) then
			if TableFriendlyHeroes[1] ~= nil then
				local nTarget = myutil:ChoseFriendlyTarget();
				if nTarget:GetHealth() <= nTarget:GetMaxHealth()*0.65 then
					return BOT_ACTION_DESIRE_MODERATE,nTarget;
				end
			end
			if TableEnemyHeroes[1] ~= nil then
				local nTarget = myutil:ChoseEnemyTarget();
				return BOT_ACTION_DESIRE_LOW,nTarget;
			end
		end 
	end
	return BOT_ACTION_DESIRE_NONE,0
end
function ConsiderAphoticShield()
	local npcBot = GetBot();
	local abilityAphoticShield = npcBot:GetAbilityByName("abaddon_aphotic_shield"); 
	
	local TableFriendlyHeroes = npcBot:GetNearbyHeroes(1300,false,BOT_MODE_NONE);
	
	if npcBot:GetActiveMode() == BOT_MODE_LANING then
		if npcBot:GetMana() >= npcBot:GetMaxMana()*0.6 then
			if TableFriendlyHeroes[1] ~= nil then
				for k,v in ipairs(TableFriendlyHeroes) do
					if v:HasModifier("modifier_abaddon_aphotic_shield") then
						return BOT_ACTION_DESIRE_NONE,0;
					end
					if v:WasRecentlyDamagedByTower(0.2) then
						return BOT_ACTION_DESIRE_MODERATE,v;
					end
					if v:WasRecentlyDamagedByAnyHero(0.2) then
						return BOT_ACTION_DESIRE_MODERATE,v;
					end
					if v:GetHealth() <= v:GetMaxHealth()*0.3 
					and v:GetNearbyHeroes(600,true,BOT_MODE_NONE)[1] ~= nil then
						return BOT_ACTION_DESIRE_MODERATE,v;
					end
				end
			end
		end
	end
	
	if	npcBot:GetActiveMode() ~= BOT_MODE_LANING then
		if TableFriendlyHeroes[1] ~= nil then
			for k,v in ipairs(TableFriendlyHeroes) do
				if v:HasModifier("modifier_abaddon_aphotic_shield") then
					return BOT_ACTION_DESIRE_NONE,0;
				end
				if v:WasRecentlyDamagedByTower(0.2) then
					return BOT_ACTION_DESIRE_MODERATE,v;
				end
				if v:WasRecentlyDamagedByAnyHero(0.2) then
					return BOT_ACTION_DESIRE_MODERATE,v;
				end
				if v:GetHealth() <= v:GetMaxHealth()*0.3 
				and v:GetNearbyHeroes(600,true,BOT_MODE_NONE)[1] ~= nil then
					return BOT_ACTION_DESIRE_MODERATE,v;
				end
			end
		end
	end
	
	return BOT_ACTION_DESIRE_MODERATE,0
end
-- keeper_of_the_light
function CanCastAbility(target)
	return target:IsHero() and GetTeamForPlayer(target:GetPlayerID()) ~= GetTeam() 
			and not target:IsMagicImmune();
end
function ConsiderIllumiante()
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
function ConsiderManaLeak()
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
function ConsiderChakraMagic()
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
function ConsiderSpiritForm()
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
function ConsiderRecall()
	local npcBot = GetBot();
	
	local abilityRecall = npcBot:GetAbilityByName("keeper_of_the_light_recall")
	
	if  not npcBot:HasModifier("modifier_keeper_of_the_light_spirit_form") then
		return BOT_ACTION_DESIRE_NONE,0;
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
function ConsiderBlindingLight()
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
function ConsiderIllumianteEnd()
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
function ConsiderSpiritFormIlluminate()
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
function ConsiderSpiritFormIlluminateEnd()
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
-- lycan
function CanCastShapeDesireOnTarget( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsInvulnerable();
end
function ConsiderHowl()
	local npcBot = GetBot();
	
	
	local abilityHowl = npcBot:GetAbilityByName("lycan_howl")
	-- Make sure it's castable
	if ( abilityHowl:IsFullyCastable() and not npcBot:IsUsingAbility()) then 
		return BOT_ACTION_DESIRE_MODERATE;
	end;

	return BOT_ACTION_DESIRE_NONE;

end
function ConsiderSummonWolves()
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
function ConsiderShapeshift()
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
-- queenofpain
function CanCastStrikeOnTarget( npcTarget )
	return npcTarget:CanBeSeen()  and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end
function CanCastSonicOnTarget( npcTarget )
	return npcTarget:CanBeSeen() and npcTarget:IsHero() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end
function ConsiderShadowStrike()
	-- for k,v in pairs(GetBot().ability) do
		-- print(k);
	-- end
	local npcBot = GetBot();
	
	local abilityShadowStrike = npcBot:GetAbilityByName("queenofpain_shadow_strike")
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(800,true,BOT_MODE_NONE);
	local npcTarget = tableNearbyEnemyHeroes[1];
	
	local nCastRange = abilityShadowStrike:GetCastRange();
	if(npcBot:GetActiveMode()== BOT_MODE_LANING)
	then
		if(npcTarget~=nil) then
			if(CanCastStrikeOnTarget(npcTarget) 
			and	npcBot:GetHealth() >= (npcBot:GetMaxHealth()*0.6)
			and npcBot:GetMana() >= (npcBot:GetMaxMana()*0.8))
			then 	
				return 0.6, npcTarget;
			end
			
			if(CanCastStrikeOnTarget(npcTarget)
			and npcTarget:GetHealth() <= 170
			and npcBot:GetMana() >= 210
			)
			then
				return 0.7, npcTarget;
			end
		end
	end
	
	if(npcBot:GetActiveMode() ~= BOT_MODE_FARM
	and npcBot:GetActiveMode() ~=BOT_MODE_LANING)
	then 
		if(npcTarget ~= nil) then
			if(CanCastStrikeOnTarget(npcTarget)
			and (GetUnitToUnitDistance(npcBot,npcTarget) <= 600))
			then
				return 0.4,npcTarget;
			end
			
		end
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
function ConsiderScreamOfPain()
	local npcBot = GetBot();
	
	local abilityScreamOfPain = npcBot:GetAbilityByName("queenofpain_scream_of_pain")
	--print("abilityScream".. abilityScream:GetBehavior());
	-- print("ScreamOfPain")
	
	local nRadius = abilityScreamOfPain:GetSpecialValueInt("area_of_effect");
	local nDamage = abilityScreamOfPain:GetAbilityDamage();
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1000, true, BOT_MODE_NONE);
	local npcTarget = tableNearbyEnemyHeroes[1];
	
	if(npcBot:GetActiveMode() ==  BOT_MODE_LANING) then
		if(npcTarget ~= nil and GetUnitToUnitDistance( npcBot, npcTarget ) < nRadius-20) then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), 0, nRadius-20, 0.0, nDamage );
			if ( locationAoE.count >= 1 and npcBot:GetMana() >= (npcBot:GetMaxMana()*0.5)) then
				--print("kill creep and hit hero");
				return BOT_ACTION_DESIRE_HIGH;
			end
		end
		if(npcBot:GetMana() >= (npcBot:GetMaxMana()*0.6)) then
			local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), 0, nRadius-20, 0.0, nDamage );
				if(locationAoE.count >= 2) then
					--print("kill creeps");
					return BOT_ACTION_DESIRE_HIGH;
				end
		end
	end
	
	if(npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP
	or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID
	or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID
	or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT) then
		if(npcBot:GetMana()>=(npcBot:GetMaxMana()*0.4)) then
			local tableNearbyEnemy = npcBot:GetNearbyCreeps(465,true);
			if(#tableNearbyEnemy >= 2) then
				--print("push");
				return BOT_ACTION_DESIRE_MODERATE;
			end
		end
	end
	
	if(npcBot:GetActiveMode() ~= BOT_MODE_FARM
	and npcBot:GetActiveMode() ~= BOT_MODE_LANING) then
		local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), 0, nRadius, 0.0, 10000 );
		if(npcTarget ~= nil and GetUnitToUnitDistance( npcBot, npcTarget ) < nRadius) then
			if ( locationAoE.count >= 2) then
			--print("hit hero");
			return BOT_ACTION_DESIRE_VERYHIGH;
			end
			if(npcBot:GetActiveMode() == BOT_MODE_ATTACK
			and GetUnitToUnitDistance(npcBot,npcTarget) < nRadius) 
			then 
			--print("1234");
				return BOT_ACTION_DESIRE_VERYHIGH ;
			end
		end
	end
	
	return 	BOT_ACTION_DESIRE_NONE;
end	
function ConsiderBlink()
	local npcBot = GetBot();
	
	local abilityBlink = npcBot:GetAbilityByName("queenofpain_blink")
	
	local nRange = abilityBlink:GetSpecialValueFloat("blink_range");
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300, true, BOT_MODE_NONE);
	local tableNearbyFriendlyHeroes = npcBot:GetNearbyHeroes(1300, false, BOT_MODE_NONE);
	local npcTarget = tableNearbyEnemyHeroes[1];
	
	if(npcBot:GetActiveMode() ==  BOT_MODE_LANING 
	or npcBot:GetActiveMode() == BOT_MODE_ATTACK) then
		if(npcTarget ~= nil and npcTarget:CanBeSeen()) then
			if(npcTarget:GetHealth() <= 200 
			and #tableNearbyEnemyHeroes <= 2
			and npcBot:GetMana() >= 200
			and npcBot:GetHealth() >= 300)
			then
				--print("blink1");
				return 0.7, npcTarget:GetLocation();
			end
			
			if(npcTarget:GetHealth() <= (npcTarget:GetActualIncomingDamage(npcBot:GetAttackDamage(),DAMAGE_TYPE_PHYSICAL)*2)
			and #tableNearbyEnemyHeroes <= 2
			and npcBot:GetHealth() >= 300)
			then
			--	print("blink2");
				return 0.7, npcTarget:GetLocation();
			end
			
		end
	end
	
	if(npcBot:GetActiveMode() == BOT_MODE_ATTACK) then
		if(#tableNearbyEnemyHeroes == 1
		and #tableNearbyFriendlyHeroes >= 3) then
			--print("blink3");
			return 0.7, npcTarget:GetLocation();
		end
	end
	
	if(npcBot:GetActiveMode() ~=BOT_MODE_RETREAT 
	and npcBot:GetActiveMode() ~= BOT_MODE_LANING
	and npcTarget ~= nil) then
		if abilityBlink:IsFullyCastable() 
		then
			local target = nil;
			for k,v in ipairs(tableNearbyEnemyHeroes) do
				if(v:GetHealth() < npcBot:GetAttackDamage())
				then
					target = v;
					break;
				end
			end
			if(target ~= nil) then
				local point = target:GetLocation();	
				--print("blink4");
				return BOT_ACTION_DESIRE_HIGH, point;
			end
		end
	end
	
	if(npcBot:GetActiveMode() == BOT_MODE_RETREAT
	or npcBot:GetActiveMode() == BOT_MODE_EVASIVE_MANEUVERS)
	then
		
		if( tableNearbyEnemyHeroes[1] ~= nil)
		then
			--print("blink5");
			return BOT_ACTION_DESIRE_MODERATE, myutil.farthestPoint(tableNearbyEnemyHeroes[1]:GetLocation()
					,npcBot:GetLocation(),1300,GetUnitToUnitDistance(npcBot,npcTarget));
		end
	end
	
	-- if(myutil.checkifblocked()) then
		-- --print("blink6");
		-- return BOT_ACTION_DESIRE_MODERATE,utils.GetXUnitsInFront(npcBot,1000);
	-- end	
	if not IsLocationPassable(npcBot:GetLocation()) then
		return BOT_ACTION_DESIRE_MODERATE,utils.GetXUnitsInFront(npcBot,1000);
	end
	
	return BOT_ACTION_DESIRE_NONE;
end
function ConsiderSonicWave()
	local npcBot = GetBot();
	local abilitySonicWave = npcBot:GetAbilityByName("queenofpain_sonic_wave")
	
	
	local nDamage = abilitySonicWave:GetAbilityDamage();
	local nCastRange = abilitySonicWave:GetCastRange();
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1200, true, BOT_ACTION_DESIRE_NONE);
	local npcTarget = tableNearbyEnemyHeroes[1];
	
	if(npcTarget ~= nil and GetUnitToUnitDistance(npcBot,npcTarget) <= (nCastRange+50)) then
		local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), nCastRange, 250, 0, 0);
		if(locationAoE.count >= 2)
		then 
			return BOT_ACTION_DESIRE_HIGH,locationAoE.targetloc;
		end
		if npcTarget:CanBeSeen() then
			if(npcTarget:GetHealth() <= nDamage)
			then
				return BOT_ACTION_DESIRE_ABSOLUTE ,npcTarget:GetLocation();
			end
		end
	end
	return BOT_ACTION_DESIRE_NONE;
end
-- nyx_assassin
function CanUseImpale()
	local npcBot = GetBot();
	if(npcBot:GetTarget() ~= nil )then
		--print(npcBot:GetTarget():GetUnitName());
		return npcBot:GetTarget():IsHero() and GetTeamForPlayer(npcBot:GetTarget():GetPlayerID()) ~= GetTeam()
			and not npcBot:GetTarget():IsMagicImmune();
	end
end
function ConsiderImpale()
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
function ConsiderManaBurn()
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
function ConsiderSpikedCarapace()
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
function ConsiderVendetta()
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
function ConsiderBurrow()
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
function ConsiderUnburrow()
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
-- weaver
function ConsiderTheSwarm()
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
function ConsiderShukuchi()
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
function ConsiderTimeLapse()
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
--visage
function CanCastGrave(target)
	return target:CanBeSeen() and target:IsHero() and GetTeamForPlayer(target:GetPlayerID()) ~= GetTeam() 
			and not target:IsMagicImmune();
end
----------------------------------------------------------------------------------------------------
function CanCastSoul(target)
	return target:CanBeSeen() and target:IsHero() and GetTeamForPlayer(target:GetPlayerID()) ~= GetTeam() 
			and not target:IsMagicImmune();
end
---------------------------------------------------------------------------------------------------
function CompareHp(a,b) 
	return a:GetHealth() > b:GetHealth();
end
-----------------------------------------------------------------------------------------------------------
function ConsiderGraveChill()
	local npcBot = GetBot();
	local abilityGraveChill = npcBot:GetAbilityByName("visage_grave_chill")
	
	
	local nCastRange = abilityGraveChill:GetCastRange();
	
	local TableNearbyEnemies = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	local nTarget = TableNearbyEnemies[1];
	
	if(npcBot:GetActiveMode() == BOT_MODE_LANING) then
		if npcBot:GetMana() > (npcBot:GetMaxMana()*0.8) then
			if(npcBot:GetAttackTarget() ~= nil) then
				if(CanCastGrave(npcBot:GetAttackTarget())) then
					return	BOT_ACTION_DESIRE_MODERATE,npcBot:GetAttackTarget();
				end
			end
		end
	end
	
	if(npcBot:GetActiveMode() == BOT_MODE_RETREAT) then
		if(nTarget ~= nil) then
			if(GetUnitToUnitDistance(npcBot,nTarget) <= nCastRange) then
				return BOT_ACTION_DESIRE_MODERATE,nTarget;
			end
		end
	end
	
	if(npcBot:GetActiveMode() ~= BOT_MODE_LANING and npcBot:GetActiveMode() ~= BOT_MODE_RETREAT) then
		if(npcBot:GetTarget() ~= nil) then
			if(CanCastGrave(npcBot:GetTarget())) then
				return BOT_ACTION_DESIRE_MODERATE,npcBot:GetTarget();
			end
		end
		if(nTarget ~= nil) then
			if(CanCastGrave(nTarget)) then
				return BOT_ACTION_DESIRE_HIGH,nTarget;
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
---------------------------------------------------------------------------------------------------------
function ConsiderSoulAssumption()
	local npcBot = GetBot();
	local abilitySoulAssumption = npcBot:GetAbilityByName("visage_soul_assumption")
	
	local nCastRange = abilitySoulAssumption:GetCastRange();
	local nMaxLimit = abilitySoulAssumption:GetSpecialValueInt("stack_limit");
	
	local nChargeDamage = abilitySoulAssumption:GetSpecialValueInt("soul_charge_damage");
	local nCount = 0;
	for i=0,npcBot:NumModifiers()-1 do
		if npcBot:GetModifierName(i) == "modifier_visage_soul_assumption" then
			nCount = npcBot:GetModifierStackCount(i);
		end
	end
	
	local nDamage = nCount* nChargeDamage;
	
	local TableNearbyEnemies = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	local nTarget = TableNearbyEnemies[1];
	
	
	if(npcBot:GetActiveMode() == BOT_MODE_RETREAT) then
		if(nTarget ~= nil)then
			if CanCastSoul(nTarget) then
				if(GetUnitToUnitDistance(npcBot,nTarget) <= nCastRange 
				and nTarget:GetActualIncomingDamage(nDamage,DAMAGE_TYPE_MAGICAL) >= nTarget:GetHealth()) then
					return BOT_ACTION_DESIRE_MODERATE, nTarget;
				end
			end
		end
	end
	
	if(npcBot:GetActiveMode() ~= BOT_MODE_RETREAT) then
		if(npcBot:GetTarget() ~= nil) then
			if(CanCastSoul(npcBot:GetTarget())) then
				if(npcBot:GetTarget():GetActualIncomingDamage(nDamage,DAMAGE_TYPE_MAGICAL) >= npcBot:GetTarget():GetHealth()
				or nCount == nMaxLimit) then
					return BOT_ACTION_DESIRE_VERYHIGH,npcBot:GetTarget();
				end
			end
		end
		if(nTarget ~= nil) then
			table.sort(TableNearbyEnemies,CompareHp);
			nTarget = TableNearbyEnemies[1];
			if(CanCastSoul(nTarget)) then
				if(nTarget:GetActualIncomingDamage(nDamage,DAMAGE_TYPE_MAGICAL) >= nTarget:GetHealth()
				or nCount == nMaxLimit) then
					return BOT_ACTION_DESIRE_VERYHIGH,nTarget;
				end
			end
		end
	end
	return BOT_ACTION_DESIRE_NONE,0;
end
----------------------------------------------------------------------------------------------------
function ConsiderSummonFamiliars()
	local npcBot = GetBot();
	local abilitySummonFamiliars = npcBot:GetAbilityByName("visage_summon_familiars")
	
	
	if npcBot.summon == nil then
		npcBot.summon = {};
	end
	
	local TableMonion = npcBot.summon;
	if(TableMonion[1] == nil) then
		return 	BOT_ACTION_DESIRE_MODERATE;
	end
	
	return BOT_ACTION_DESIRE_NONE;
end


-- antimage
function ConsiderAMBlink()
	local npcBot = GetBot();
	local abilityBlink = npcBot:GetAbilityByName("antimage_blink");
	
	local BlinkRange = abilityBlink:GetSpecialValueInt("blink_range");
	
	local TableNearbyEnemyTowers = npcBot:GetNearbyTowers(1400,true);
	local TableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1400,true,BOT_MODE_NONE);
	
	
	if npcBot:GetActiveMode() == BOT_MODE_ATTACK then
		if #TableNearbyEnemyHeroes == 1 and #TableNearbyEnemyTowers == 0 then
			if npcBot:GetEstimatedDamageToTarget(true,TableNearbyEnemyHeroes[1],2.0,DAMAGE_TYPE_ALL) >= TableNearbyEnemyHeroes[1]:GetHealth() then
				return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1]:GetLocation();
			end
		end
		
		if npcBot:GetTarget() ~= nil then
			local nTarget = npcBot:GetTarget();
			if nTarget:IsHero() and nTarget:GetTeam() ~= GetTeam() then
				if nTarget:GetNearbyHeroes(1000,false,BOT_MODE_NONE) > 2 then
					if npcBot:GetHealth() >= (npcBot:GetMaxHealth() * 0.6) then
						return BOT_ACTION_DESIRE_MODERATE,nTarget:GetLocation();
					end
					if nTarget:GetHealth() <= (npcBot:GetAttackDamage() * 2) then
						return BOT_ACTION_DESIRE_HIGH,nTarget:GetLocation();
					end
				else
					if nTarget:GetHealth() <= (npcBot:GetAttackDamage() * 2) then
						return BOT_ACTION_DESIRE_HIGH,nTarget:GetLocation();
					end
					if #npcBot:GetNearbyHeroes(1000,false,BOT_MODE_ATTACK) >= (#TableNearbyEnemyHeroes + 2) then
						return BOT_ACTION_DESIRE_MODERATE,nTarget:GetLocation()
					end
				end
			end
		end
	end
	
	if npcBot:GetActiveMode() == BOT_MODE_FARM then
		if npcBot.farmpoint ~= nil then
			return BOT_ACTION_DESIRE_HIGH,npcBot.farmpoint;
		end
	end
	
	if npcBot:GetActiveMode() ==  BOT_MODE_RETREAT then
		if TableNearbyEnemyHeroes[1] ~= nil then
			return BOT_ACTION_DESIRE_MODERATE,utils.GetXUnitsInFront(npcBot,1000);
		else
			return BOT_ACTION_DESIRE_MODERATE, myutil.farthestPoint(tableNearbyEnemyHeroes[1]:GetLocation()
					,npcBot:GetLocation(),1300,GetUnitToUnitDistance(npcBot,npcTarget));
		end
	end
	
	if not IsLocationPassable(npcBot:GetLocation()) then
		return BOT_ACTION_DESIRE_MODERATE,utils.GetXUnitsInFront(npcBot,1000);
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
function ConsiderManaVoid()
	local npcBot = GetBot();
	local abilityManaVoid = npcBot:GetAbilityByName("antimage_mana_void");
	
	local aRadius = abilityManaVoid:GetSpecialValueInt("mana_void_aoe_radius");
	local aDamage = abilityManaVoid:GetSpecialValueFloat("mana_void_damage_per_mana");
	
	local TableEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	if TableEnemyHeroes[1] ~= nil then
		for k,v in ipairs(TableEnemyHeroes) do
			if v:IsChanneling() and v:IsMagicImmune() then
				return BOT_ACTION_DESIRE_HIGH,v;
			end
			local AOElocation = v:FindAoELocation(false,true,v:GetLocation(),0,aRadius,0,10000);
			local ActualDamage = (v:GetMaxMana() - v:GetMana()) * aDamage;
			if AOElocation.count >= 3 then
				if ActualDamage >= 500 then
					return BOT_ACTION_DESIRE_HIGH,v;
				end
			end
			if not v:IsMagicImmune() and v:GetHealth() < v:GetActualIncomingDamage(ActualDamage,DAMAGE_TYPE_MAGICAL)then
				return BOT_ACTION_DESIRE_HIGH,v;
			end
		end
	end
	return BOT_ACTION_DESIRE_NONE,0;
end




