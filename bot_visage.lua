require(GetScriptDirectory() .. "/parent_minion_model")

--print(#W);
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------

function ConsiderOtherAbility(hMinionUnit)
	if string.find(hMinionUnit:GetUnitName(),"npc_dota_visage_familiar") ~= nil then
		local abilityStoneForm = hMinionUnit:GetAbilityByName("visage_summon_familiars_stone_form");
		if(not abilityStoneForm:IsFullyCastable()) then
			return BOT_ACTION_DESIRE_NONE,0;
		end
		
		local EnemyHeroes = GetUnitList(UNIT_LIST_ENEMY_HEROES)
		SortbyDistance(hMinionUnit,EnemyHeroes);
		
		if hMinionUnit:GetHealth() <= (0.5*hMinionUnit:GetMaxHealth()) then
			return BOT_ACTION_DESIRE_HIGH,hMinionUnit:GetLocation();
		end
	
		for k,v in ipairs(EnemyHeroes) do
			if(v:CanBeSeen())then
				if(GetUnitToUnitDistance(v,hMinionUnit) <= 900 and v:IsChanneling()
				and not v:IsMagicImmune()) then
					return BOT_ACTION_DESIRE_VERYHIGH,v:GetLocation();
				end
			end
		end
	
		local TableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(390,true,BOT_MODE_NONE);
		if #TableNearbyEnemyHeroes >= 2 then
			for k,v in ipairs(TableNearbyEnemyHeroes) do
				local locationAOE = v:FindAoELocation(true,true,v:GetLocation(),0,300,0,10000);
				if(locationAOE.count >= 2) then
					return BOT_ACTION_DESIRE_HIGH,locationAOE.targetloc;
				end
			end
		end
	
		if(not hMinionUnit:HasModifier("modifier_visage_summon_familiars_damage_charge")) then
			return BOT_ACTION_DESIRE_MODERATE,hMinionUnit:GetLocation();
		end
		return BOT_ACTION_DESIRE_NONE,0;
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function ExcuteOtherAbility(hMinionUnit,abilityTarget)
	if string.find(hMinionUnit:GetUnitName(),"npc_dota_visage_familiar") ~= nil then
	local abilityStoneForm = hMinionUnit:GetAbilityByName("visage_summon_familiars_stone_form");
		if(GetUnitToLocationDistance(hMinionUnit,abilityTarget) <= 20) then
			hMinionUnit:Action_MoveToLocation(abilityTarget);
		end
		hMinionUnit:Action_UseAbility( abilityStoneForm );
	end
end

function SortbyDistance(npc,tabletosort)
	table.sort(tabletosort,function(a,b) 
		return GetUnitToLocationDistance(npc,a:GetLocation()) 
			< GetUnitToLocationDistance(npc,b:GetLocation()) end);
end
