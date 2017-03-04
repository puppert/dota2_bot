local PM = require(string.gsub(GetScriptDirectory(),"state/minion_ability_state","template") .. "/state_template");
local M = PM:New();
local NS = require(GetScriptDirectory() .. "/ogre_magi_state");
M.hName = "npc_dota_neutral_mud_golem";
M.aName = "mud_golem_hurl_boulder";
M.nextstate = NS;

function M:specificConsider(hMinionUnit)
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
	hMinionUnit:Action_UseAbilityOnEntity(ability,abilityTarget);
end

return M;