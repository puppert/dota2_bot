local PM = require(GetScriptDirectory() .. "/template/state_template");
local M = PM:New();
local NS = require(GetScriptDirectory() .. "/polar_furbolg_ursa_warrior_state");
M.hName = "npc_dota_neutral_centaur_khan";
M.aName = "centaur_khan_war_stomp";
M.nextstate = NS;

function M:specificConsider(hMinionUnit)
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

function M:specificExcute(hMinionUnit,ability,abilityTarget)
	if abilityTarget == 0 then
		hMinionUnit:Action_UseAbility(ability);
	elseif GetUnitToUnitDistance(hMinionUnit,abilityTarget) > 200 then
		hMinionUnit:Action_MoveToUnit(abilityTarget);
	elseif GetUnitToUnitDistance(hMinionUnit,abilityTarget) <= 200 then
		hMinionUnit:Action_UseAbility(ability);
	end
end

return M;