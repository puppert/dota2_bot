local factory = require(GetScriptDirectory().."/factory/factory_parrent")

local Factory = factory:New();

function Factory:GetObject(count)
	return GetBot():GetAbilityInSlot(count);
end

function Factory:SetCondition(Object)
	if Object == nil then
		return false;
	end
	return not Object:IsTalent();
end


function Factory:SetBreakCondition(Object)
	if Object == nil then
		return true
	end
	return Object:IsTalent();
end


return Factory;