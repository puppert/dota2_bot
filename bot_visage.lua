require(GetScriptDirectory() .. "/parent_minion_model")
local state_template = require(GetScriptDirectory() .. "/state/state_template")
--print(#W);
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------

function OtherMonion(hMinionUnit)
	local familiar_state = state_template:New();
	familiar_state.hName = "npc_dota_visage_familiar";
	familiar_state.aName = "visage_summon_familiars_stone_form";
	
	function familiar_state:specificConsider(hMinionUnit)
		local EnemyHeroes = GetUnitList(UNIT_LIST_ENEMY_HEROES)
		table.sort(EnemyHeroes,function(a,b) 
		return GetUnitToLocationDistance(hMinionUnit,a:GetLocation()) 
			< GetUnitToLocationDistance(hMinionUnit,b:GetLocation()) end);
		
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
	end
	
	function familiar_state:specificExcute(hMinionUnit,ability,abilityTarget)
		if(GetUnitToLocationDistance(hMinionUnit,abilityTarget) <= 20) then
			hMinionUnit:Action_MoveToLocation(abilityTarget);
		end
		hMinionUnit:Action_UseAbility( ability );
	end
	
	return familiar_state;
end


