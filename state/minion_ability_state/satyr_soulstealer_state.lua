local PM = require(string.gsub(GetScriptDirectory(),"state/minion_ability_state","template") .. "/state_template");
local M = PM:New();
local NS = require(GetScriptDirectory() .. "/satyr_hellcaller_state");
M.hName = "npc_dota_neutral_satyr_soulstealer";
M.aName = "satyr_soulstealer_mana_burn";
M.nextstate = NS;

function M:specificConsider(hMinionUnit)
	local TableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(800,true,BOT_MODE_NONE );
	if TableNearbyEnemyHeroes[1] ~= nil then
		return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1];
	end
end

function M:specificExcute(hMinionUnit,ability,abilityTarget)
	hMinionUnit:Action_UseAbilityOnEntity(ability,abilityTarget);
end

return M;