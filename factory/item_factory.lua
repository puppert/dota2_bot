local factory = require(GetScriptDirectory().."/factory_parrent")

local Factory = factory:New();

function Factory:GetObject(count)
	return GetBot():GetItemInSlot(count);
end

function Factory:SetCondition(Object)
	return Object:IsItem() and GetBot():FindItemSlot(Object:GetName()) <= 5;
end

function Factory:SetBreakCondition(Object)
	if GetBot():FindItemSlot(Object:GetName()) > 5 then
		return true
	else
		return false
	end
end


return Factory;