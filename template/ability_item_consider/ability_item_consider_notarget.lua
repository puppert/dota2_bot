local P = require(string.gsub(GetScriptDirectory(),"ability_item_consider","") .. "ability_item_consider_template")

local C = P:New();

function C:aSpecialConsider()
	local flag = self:noTargetConsider();
	if flag ~= nil then
		return flag;
	end
end

function C:noTargetConsider()
	
end

return C;