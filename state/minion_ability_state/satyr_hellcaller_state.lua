local PM = require(string.gsub(GetScriptDirectory(),"state/minion_ability_state","template") .. "/state_template");
local M = PM:New();
local NS = require(GetScriptDirectory() .. "/dark_troll_warlord_state");
M.hName = "npc_dota_neutral_satyr_hellcaller";
M.aName = "satyr_hellcaller_shockwave";
M.nextstate = NS;

function M:specificConsider(hMinionUnit)
	local locationAOE = hMinionUnit:FindAoELocation(true,true,hMinionUnit:GetLocation(),1250,180,0,10000);
	if locationAOE.count >= 2 then
		return BOT_ACTION_DESIRE_HIGH,locationAOE.targetloc;
	end
	local TableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(800,true,BOT_MODE_NONE );
	if TableNearbyEnemyHeroes[1] ~= nil then
		return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1]:GetLocation();
	end
end

function M:specificExcute(hMinionUnit,ability,abilityTarget)
	hMinionUnit:Action_UseAbilityOnLocation(ability,abilityTarget);
end

return M;