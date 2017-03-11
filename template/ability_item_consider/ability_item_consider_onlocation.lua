local P = require(string.gsub(GetScriptDirectory(),"ability_item_consider","") .. "ability_item_consider_template")

local C = P:New();

function C:aSpecialConsider()
	local self.aCastRange = self.ability:GetCastRange();
	local flag = self:onLocationConsider();
	if flag ~= nil then
		return flag;
	end
end

function C:onLocationConsider()
	
end

return C;