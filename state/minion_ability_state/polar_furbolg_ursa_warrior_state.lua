local PM = require(GetScriptDirectory() .. "/template/state_template");
local M = PM:New();
local NS = require(GetScriptDirectory() .. "/mud_golem_state");
M.hName = "npc_dota_neutral_polar_furbolg_ursa_warrior";
M.aName = "polar_furbolg_ursa_warrior_thunder_clap";
M.nextstate = NS;

function M:specificConsider(hMinionUnit)
	local locationAOE = hMinionUnit:FindAoELocation(true,true,hMinionUnit:GetLocation(),0,300,0,10000);
	if locationAOE.count >= 2 then
		return BOT_ACTION_DESIRE_HIGH,0;
	end
	local TableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(800,true,BOT_MODE_NONE );
	if TableNearbyEnemyHeroes[1] ~= nil then
		return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1];
	end
end

function M:specificExcute(hMinionUnit,ability,abilityTarget)
	if abilityTarget == 0 then
		hMinionUnit:Action_UseAbility(ability);
	elseif GetUnitToUnitDistance(hMinionUnit,abilityTarget) <= 250 then
		hMinionUnit:Action_UseAbility(ability);
	end
end

return M;