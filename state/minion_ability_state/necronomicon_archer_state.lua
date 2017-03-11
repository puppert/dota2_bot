local PM = require(GetScriptDirectory() .. "/template/state_template");
local M = PM:New();
M.hName = "npc_dota_necronomicon_archer";
M.aName = "necronomicon_archer_mana_burn";
M.nextstate = "";

function M:specificConsider(hMinionUnit)
	if GetBot():GetTarget() ~= nil then
		local nTarget = GetBot():GetTarget();
		if nTarget:IsHero() and GetTeamForPlayer(nTarget:GetPlayerID()) == GetOpposingTeam() 
		and not nTarget:IsMagicImmune() then
			return BOT_ACTION_DESIRE_MODERATE,nTarget;
		end
	end
	local TableNearbyEnemyHeroes = hMinionUnit:GetNearbyHeroes(800,true,BOT_MODE_NONE);
	if TableNearbyEnemyHeroes[1] ~= nil and not nTarget:IsMagicImmune() then
		return BOT_ACTION_DESIRE_MODERATE,TableNearbyEnemyHeroes[1];
	end
end

function M:specificExcute(hMinionUnit,ability,abilityTarget)
	hMinionUnit:Action_UseAbilityOnEntity(ability,abilityTarget);
end

return M;