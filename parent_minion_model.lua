_G._savedEnvMinion = getfenv()
module( "parent_minion_model", package.seeall )
----------------------------------------------------------------------------------------
attackDesire = 0;
abilityDesire = 0 ;
searchDesire = 0;
followDesire = 0;

--[==[
	1.召唤单位存在 GetBot().summon里面
	2.对仆从单位的父类，直接导入即可
	3.有除了野怪和死灵书以外的技能想要重写，请重写ConsiderOtherAbility(hMinionUnit)
	ExcuteOtherAbility(hMinionUnit,abilityTarget)
]==]


function MinionThink(hMinionUnit)
	if hMinionUnit ~= nil and not hMinionUnit.tableflag then
		if GetBot().summon == nil then
			GetBot().summon = {};
		end
		table.insert(GetBot().summon,hMinionUnit);
		hMinionUnit.tableflag = true;
		hMinionUnit.position = #GetBot().summon;
	end	
	
	if not hMinionUnit:IsAlive() then
		table.remove(GetBot().summon,hMinionUnit.position);
	end
	
	attackDesire = 0;
	abilityDesire = 0 ;
	searchDesire = 0;
	followDesire = 0;
	
	
	 attackDesire, attackTarget = ConsiderAttack(hMinionUnit);
	 abilityDesire, abilityTarget = ConsiderAbility(hMinionUnit);
	 searchDesire, searchLocation = ConsiderSearch(hMinionUnit);
	 followDesire, followTarget = ConsiderFollow(hMinionUnit);
	
	local highestDesire =  attackDesire;
	local desiredSkill = 1;

	if ( abilityDesire > highestDesire) 
	then
		highestDesire =  abilityDesire;
		desiredSkill = 2;
	elseif( searchDesire > highestDesire)
	then
		highestDesire =  searchDesire;
		desiredSkill = 3;
	elseif( followDesire > highestDesire)
	then
		highestDesire =  followDesire;
		desiredSkill = 4;
	end
	
	-- if(hMinionUnit:GetCurrentActionType() ~= BOT_ACTION_TYPE_ATTACK) then
		-- print(hMinionUnit:GetCurrentActionType());
	-- end
	
	if highestDesire == 0 then return;
    elseif desiredSkill == 1 then 
		ExecuteAttack(hMinionUnit,attackTarget);
		--print(hMinionUnit:GetUnitName().."attack");
    elseif desiredSkill == 2 then 
		ExecuteAbility(hMinionUnit, abilityTarget);
		--print(hMinionUnit:GetUnitName().."useability");
	elseif desiredSkill == 3 then 
		ExecuteSearch(hMinionUnit, searchLocation);
		--print(hMinionUnit:GetUnitName().."search");
	elseif desiredSkill == 4 then
		ExecuteFollow(hMinionUnit, followTarget);
		--print(hMinionUnit:GetUnitName().."follow");
	end	
end
----------------------------------------
---attackConsider
function ConsiderAttack(hMinionUnit)
	local hTarget = GetBot():GetTarget();
	
	if GetBot():GetAttackTarget() ~= nil then
		return BOT_ACTION_DESIRE_MODERATE,GetBot():GetAttackTarget();
	end
	
	
	if(hTarget ~= nil) then
		if(GetTeamForPlayer(hTarget:GetPlayerID()) ~= GetTeam()) then
			if hTarget:IsTower() and GetUnitToUnitDistance(hTarget,GetBot()) >  900 then
				return BOT_ACTION_DESIRE_NONE, 0;
			end
			return BOT_ACTION_DESIRE_MODERATE,hTarget;
		end
	end
	
	local TableNearbyEnemies = GetBot():GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	if(TableNearbyEnemies[1] ~= nil) then
		table.sort(TableNearbyEnemies, CompareHp);
		for k,v in ipairs(TableNearbyEnemies) do
			if(v:IsAlive() and not v:IsAttackImmune() and not v:IsInvulnerable()) then
				return BOT_ACTION_DESIRE_MODERATE,v;
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
--abilityConsider
function  ConsiderAbility(hMinionUnit)
	
	local OtherDesire,OtherTarget = ConsiderOtherAbility(hMinionUnit);
	if OtherDesire ~= BOT_ACTION_DESIRE_NONE then
		return OtherDesire,OtherTarget;
	end

	if hMinionUnit:GetUnitName() == "npc_dota_neutral_centaur_khan" then
		local abilityWarStomp = hMinionUnit:GetAbilityByName("centaur_khan_war_stomp");
		if not abilityWarStomp:IsFullyCastable() then
			return BOT_ACTION_DESIRE_NONE,0;
		end
		local locationAOE = hMinionUnit:FindAoELocation(true,true,hMinionUnit:GetLocation(),0,250,0,10000);
		if locationAOE.count >= 2 then
			return BOT_ACTION_DESIRE_HIGH,0;
		end
		local TableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(800,true,BOT_MODE_NONE );
		if TableNearbyEnemyHeroes[1] ~= nil then
			for k,v in ipairs(TableNearbyEnemyHeroes) do
				if v:IsChanneling() then
					return BOT_ACTION_DESIRE_HIGH,v;
				end
			end
			return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1];
		end
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_polar_furbolg_ursa_warrior" then
		local abilityThunderClap = hMinionUnit:GetAbilityByName("polar_furbolg_ursa_warrior_thunder_clap");
		if not abilityThunderClap:IsFullyCastable() then
			return BOT_ACTION_DESIRE_NONE,0;
		end
		local locationAOE = hMinionUnit:FindAoELocation(true,true,hMinionUnit:GetLocation(),0,300,0,10000);
		if locationAOE.count >= 2 then
			return BOT_ACTION_DESIRE_HIGH,0;
		end
		local TableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(800,true,BOT_MODE_NONE );
		if TableNearbyEnemyHeroes[1] ~= nil then
			return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1];
		end
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_mud_golem" 
	or hMinionUnit:GetUnitName() == "npc_dota_neutral_mud_golem_split" then
		local abilityHurlBoulder = hMinionUnit:GetAbilityByName("mud_golem_hurl_boulder");
		if not abilityHurlBoulder:IsFullyCastable() then
			return BOT_ACTION_DESIRE_NONE,0;
		end
		local TableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(800,true,BOT_MODE_NONE );
		if TableNearbyEnemyHeroes[1] ~= nil then
			for k,v in ipairs(TableNearbyEnemyHeroes) do
				if v:IsChanneling() then
					return BOT_ACTION_DESIRE_HIGH,v;
				end
			end
			return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1];
		end
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_ogre_magi" then
		local abilityFrostArmor = hMinionUnit:GetAbilityByName("ogre_magi_frost_armor");
		if not abilityFrostArmor:IsFullyCastable() then
			return BOT_ACTION_DESIRE_NONE,0;
		end
		local TableNearbyFriendlyHeroes = hMinionUnit:GetNearbyHeroes(800,false,BOT_MODE_NONE );
		if TableNearbyFriendlyHeroes[1] ~= nil then
			for k,v in ipairs(TableNearbyFriendlyHeroes) do
				if not v:HasModifier("modifier_ogre_magi_frost_armor") then
					return BOT_ACTION_DESIRE_MODERATE,v;
				end
			end
		end
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_satyr_soulstealer" then
		local abilityManaBurn = hMinionUnit:GetAbilityByName("satyr_soulstealer_mana_burn");
		if not abilityManaBurn:IsFullyCastable() then
			return BOT_ACTION_DESIRE_NONE,0;
		end
		local TableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(800,true,BOT_MODE_NONE );
		if TableNearbyEnemyHeroes[1] ~= nil then
			return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1];
		end
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_satyr_hellcaller" then
		local abilityShockWave = hMinionUnit:GetAbilityByName("satyr_hellcaller_shockwave");
		if not abilityShockWave:IsFullyCastable() then
			return BOT_ACTION_DESIRE_NONE,0;
		end
		local locationAOE = hMinionUnit:FindAoELocation(true,true,hMinionUnit:GetLocation(),1250,180,0,10000);
		if locationAOE.count >= 2 then
			return BOT_ACTION_DESIRE_HIGH,locationAOE.targetloc;
		end
		local TableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(800,true,BOT_MODE_NONE );
		if TableNearbyEnemyHeroes[1] ~= nil then
			return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1]:GetLocation();
		end
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_dark_troll_warlord" then
		local abilityEnsnare = hMinionUnit:GetAbilityByName("dark_troll_warlord_ensnare");
		if not abilityEnsnare:IsFullyCastable() then
			return BOT_ACTION_DESIRE_NONE,0;
		end
		if GetBot():GetTarget() ~= nil then
			local nTarget = GetBot():GetTarget();
			if nTarget:IsHero() and GetTeamForPlayer(nTarget:GetPlayerID()) == GetOpposingTeam() then
				return BOT_ACTION_DESIRE_MODERATE,nTarget;
			end
		end
		local TableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(800,true,BOT_MODE_NONE);
		if TableNearbyEnemyHeroes[1] ~= nil then
			return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1];
		end
		
		local abilityRaiseDead = hMinionUnit:GetAbilityByName("dark_troll_warlord_raise_dead");
		if not abilityRaiseDead:IsFullyCastable() then
			return BOT_ACTION_DESIRE_NONE,0;
		end
		if not abilityEnsnare:IsFullyCastable() and abilityRaiseDead:IsFullyCastable() then
			return BOT_ACTION_DESIRE_MODERATE,0;
		end
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_satyr_trickster" then
		local abilityPurge = hMinionUnit:GetAbilityByName("satyr_trickster_purge");
		if not abilityPurge:IsFullyCastable() then
			return BOT_ACTION_DESIRE_NONE,0;
		end
		if GetBot():GetTarget() ~= nil then
			local nTarget = GetBot():GetTarget();
			if nTarget:IsHero() and GetTeamForPlayer(nTarget:GetPlayerID()) == GetOpposingTeam() then
				return BOT_ACTION_DESIRE_MODERATE,nTarget;
			end
		end
		local TableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(800,true,BOT_MODE_NONE);
		if TableNearbyEnemyHeroes[1] ~= nil then
			return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1];
		end 
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_forest_troll_high_priest" then
		local abilityPriestHeal = hMinionUnit:GetAbilityByName("forest_troll_high_priest_heal");
		if not abilityPriestHeal:IsFullyCastable() then
			return BOT_ACTION_DESIRE_NONE,0;
		end
		local TableNearbyFriendlyHeroes = hMinionUnit:GetNearbyHeroes(800,false,BOT_MODE_NONE );
		if TableNearbyFriendlyHeroes[1] ~= nil then
			for k,v in ipairs(TableNearbyFriendlyHeroes) do
				if v:GetHealth() < v:GetMaxHealth() then
					return BOT_ACTION_DESIRE_MODERATE,v;
				end
			end
		end
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_harpy_storm" then
		local abilityChainLightning = hMinionUnit:GetAbilityByName("harpy_storm_chain_lightning");
		if not abilityChainLightning:IsFullyCastable() then
			return BOT_ACTION_DESIRE_NONE,0;
		end
		if GetBot():GetTarget() ~= nil then
			local nTarget = GetBot():GetTarget();
			if nTarget:IsHero() and GetTeamForPlayer(nTarget:GetPlayerID()) == GetOpposingTeam() then
				return BOT_ACTION_DESIRE_MODERATE,nTarget;
			end
		end
		local TableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(800,true,BOT_MODE_NONE);
		if TableNearbyEnemyHeroes[1] ~= nil then
			return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1];
		else
			local TableNearbyEnemies = hMinionUnit:GetNearbyCreeps(800,true);
			if #TableNearbyEnemies >= 2 then
				return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemies[1];
			end
		end
	end
	
	if string.find(hMinionUnit:GetUnitName(),"npc_dota_necronomicon_archer") ~= nil then
		abilityNecManaBurn = hMinionUnit:GetAbilityByName("necronomicon_archer_mana_burn");
		if not abilityNecManaBurn:IsFullyCastable() then
			return BOT_ACTION_DESIRE_NONE,0;
		end
		if GetBot():GetTarget() ~= nil then
			local nTarget = GetBot():GetTarget();
			if nTarget:IsHero() and GetTeamForPlayer(nTarget:GetPlayerID()) == GetOpposingTeam() 
			and not nTarget:IsMagicImmune() then
				return BOT_ACTION_DESIRE_MODERATE,nTarget;
			end
		end
		local TableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(800,true,BOT_MODE_NONE);
		if TableNearbyEnemyHeroes[1] ~= nil and not nTarget:IsMagicImmune() then
			return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1];
		end
	end
	
	return BOT_ACTION_DESIRE_NONE,0;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
--searchConsider
function  ConsiderSearch(hMinionUnit)
	return 0,0;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
-- followConsider
function  ConsiderFollow(hMinionUnit)
	if(hMinionUnit:GetCurrentActionType() ~= BOT_ACTION_TYPE_ATTACK 
	and hMinionUnit:GetCurrentActionType() ~= BOT_ACTION_TYPE_USE_ABILITY
	and hMinionUnit:GetCurrentActionType() ~= BOT_ACTION_TYPE_MOVE_TO) then
		return BOT_ACTION_DESIRE_MODERATE, GetBot();
	end
	return BOT_ACTION_DESIRE_NONE,0;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
--attackExcute
function  ExecuteAttack(hMinionUnit,attackTarget)
	hMinionUnit:Action_AttackUnit(attackTarget,true);
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
--abilityExcute
function  ExecuteAbility(hMinionUnit, abilityTarget)
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_centaur_khan" then
		local abilityWarStomp = hMinionUnit:GetAbilityByName("centaur_khan_war_stomp");
		if abilityTarget == 0 then
			hMinionUnit:Action_UseAbility(abilityWarStomp);
		elseif GetUnitToUnitDistance(hMinionUnit,abilityTarget) > 200 then
			hMinionUnit:Action_MoveToUnit(abilityTarget);
		elseif GetUnitToUnitDistance(hMinionUnit,abilityTarget) <= 200 then
			hMinionUnit:Action_UseAbility(abilityWarStomp);
		end
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_polar_furbolg_ursa_warrior" then
		local abilityThunderClap = hMinionUnit:GetAbilityByName("polar_furbolg_ursa_warrior_thunder_clap");
		if abilityTarget == 0 then
			hMinionUnit:Action_UseAbility(abilityThunderClap);
		elseif GetUnitToUnitDistance(hMinionUnit,abilityTarget) <= 250 then
			hMinionUnit:Action_UseAbility(abilityThunderClap);
		end
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_polar_furbolg_ursa_warrior" then
		local abilityHurlBoulder = hMinionUnit:GetAbilityByName("mud_golem_hurl_boulder");
		hMinionUnit:Action_UseAbilityOnEntity(abilityHurlBoulder,abilityTarget);
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_ogre_magi" then
		local abilityFrostArmor = hMinionUnit:GetAbilityByName("ogre_magi_frost_armor");
		hMinionUnit:Action_UseAbilityOnEntity(abilityFrostArmor,abilityTarget);
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_satyr_soulstealer" then
		local abilityManaBurn = hMinionUnit:GetAbilityByName("satyr_soulstealer_mana_burn");
		hMinionUnit:Action_UseAbilityOnEntity(abilityManaBurn,abilityTarget);
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_satyr_hellcaller" then
		local abilityShockWave = hMinionUnit:GetAbilityByName("satyr_hellcaller_shockwave");
		hMinionUnit:Action_UseAbilityOnLocation(abilityShockWave,abilityTarget);
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_dark_troll_warlord" then
		local abilityEnsnare = hMinionUnit:GetAbilityByName("dark_troll_warlord_ensnare");
		local abilityRaiseDead = hMinionUnit:GetAbilityByName("dark_troll_warlord_raise_dead");
		if abilityTarget == 0 then
			hMinionUnit:Action_UseAbility(abilityRaiseDead);
		else
			hMinionUnit:Action_UseAbilityOnEntity(abilityEnsnare);
		end
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_satyr_trickster" then
		local abilityPurge = hMinionUnit:GetAbilityByName("satyr_trickster_purge");
		hMinionUnit:Action_UseAbilityOnEntity(abilityPurge);
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_forest_troll_high_priest" then
		local abilityPriestHeal = hMinionUnit:GetAbilityByName("forest_troll_high_priest_heal");
		hMinionUnit:Action_UseAbilityOnEntity(abilityPriestHeal,abilityTarget);
	end
	
	if hMinionUnit:GetUnitName() == "npc_dota_neutral_harpy_storm" then
		local abilityChainLightning = hMinionUnit:GetAbilityByName("harpy_storm_chain_lightning");
		hMinionUnit:Action_UseAbilityOnEntity(abilityChainLightning,abilityTarget);
	end
	
	if string.find(hMinionUnit:GetUnitName(),"npc_dota_necronomicon_archer") ~= nil then
		abilityNecManaBurn = hMinionUnit:GetAbilityByName("necronomicon_archer_mana_burn");
		hMinionUnit:Action_UseAbilityOnEntity(abilityNecManaBurn);
	end
	
	ExcuteOtherAbility(hMinionUnit,abilityTarget);
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
--searchExcute
function  ExecuteSearch(hMinionUnit, searchLocation)
	hMinionUnit:Action_MoveToLocation(searchLocation);
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
--followExcute
function  ExecuteFollow(hMinionUnit, followTarget)
	hMinionUnit:Action_MoveToUnit(followTarget);
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function  ConsiderOtherAbility(hMinionUnit)
	-- plz rewrite this
	return 0,0;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function  ExcuteOtherAbility(hMinionUnit,abilityTarget)
	--plz rewrite this if you want to use yout own ability
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function CompareHp(a,b) 
	return a:GetHealth() < b:GetHealth();
end

for k,v in pairs( parent_minion_model ) do	_G._savedEnvMinion[k] = v end

