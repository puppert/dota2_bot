local factory = require(GetScriptDirectory().."/factory_parrent")

local Factory = factory:New();

function Factory:GetObject(count)
	return GetBot():GetAbilityInSlot(count);
end

function Factory:SetCondition(Object)
	return Object:IsTalent();
end

function Factory:SetBreakCondition(Object)
	if Object == nil then
		return true
	else
		return false
	end
end


return Factory;