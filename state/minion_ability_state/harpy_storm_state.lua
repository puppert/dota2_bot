local PM = require(string.gsub(GetScriptDirectory(),"state/minion_ability_state","template") .. "/state_template");
local M = PM:New();
local NS = require(GetScriptDirectory() .. "/necronomicon_archer_state");
M.hName = "npc_dota_neutral_harpy_storm";
M.aName = "harpy_storm_chain_lightning";
M.nextstate = NS;

function M:specificConsider(hMinionUnit)
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

function M:specificExcute(hMinionUnit,ability,abilityTarget)
	hMinionUnit:Action_UseAbilityOnEntity(ability,abilityTarget);
end

return M;