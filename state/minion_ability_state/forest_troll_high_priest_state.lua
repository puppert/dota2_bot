local PM = require(string.gsub(GetScriptDirectory(),"state/minion_ability_state","template") .. "/state_template");
local M = PM:New();
local NS = require(GetScriptDirectory() .. "/harpy_storm_state");
M.hName = "npc_dota_neutral_forest_troll_high_priest";
M.aName = "forest_troll_high_priest_heal";
M.nextstate = NS;

function M:specificConsider(hMinionUnit)
	local TableNearbyFriendlyHeroes = hMinionUnit:GetNearbyHeroes(800,false,BOT_MODE_NONE );
	if TableNearbyFriendlyHeroes[1] ~= nil then
		for k,v in ipairs(TableNearbyFriendlyHeroes) do
			if v:GetHealth() < v:GetMaxHealth() then
				return BOT_ACTION_DESIRE_MODERATE,v;
			end
		end
	end
end

function M:specificExcute(hMinionUnit,ability,abilityTarget)
	hMinionUnit:Action_UseAbilityOnEntity(ability,abilityTarget);
end

return M;