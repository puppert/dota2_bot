X = {};
local myutil = require(GetScriptDirectory().."/myutil")


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
function X:abilityConsiderGraveChill()
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
function X:abilityConsiderSoulAssumption()
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
function X:abilityConsiderSummonFamiliars()
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

return X;