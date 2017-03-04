_G._savedEnvMinion = getfenv()
module( "parent_minion_model", package.seeall )
local monion = require(GetScriptDirectory() .. "/minion");
local necronomicon_archer = require(GetScriptDirectory() .. "/state/minion_ability_state/necronomicon_archer_state");
----------------------------------------------------------------------------------------
--[==[
	1.召唤单位存在 GetBot().summon里面
	2.对仆从单位的父类，直接导入即可
	3.有除了野怪和死灵书以外的技能想要重写，请重写OtherMonion(hMinionUnit) (用/template/state_template 内的New方法生成新的子类)
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
	hminion = minion:New();
	hminion:sethMinionUnit(hMinionUnit);
	necronomicon_archer.nextstate = OtherMonion(hMinionUnit) or "";
	local aDesire,aTarget = hminion:Consider();
	
	if aDesire ~= nil then
		return aDesire,aTarget;
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
	hminion:setTarget(abilityTarget);
	hminion:Excute();
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
function OtherMonion(hMinionUnit)

	return nil;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function CompareHp(a,b) 
	return a:GetHealth() < b:GetHealth();
end

for k,v in pairs( parent_minion_model ) do	_G._savedEnvMinion[k] = v end

