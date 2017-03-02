local factory = require(GetScriptDirectory().."/factory_parrent")

local Factory = factory:New();

function Factory:GetObject(count)
	return GetBot():GetAbilityInSlot(count);
end

function Factory:SetCondition(Object)
	return not Object:IsTalent();
end


function Factory:SetBreakCondition(Object)
	return Object:IsTalent();
end


return Factory;