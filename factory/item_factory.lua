local factory = require(GetScriptDirectory().."/factory/factory_parrent")

local Factory = factory:New();

function Factory:GetObject(count)
	return GetBot():GetItemInSlot(count);
end

function Factory:SetCondition(Object)
	if Object == nil then
		return false;
	end
	return Object:IsItem() and GetBot():FindItemSlot(Object:GetName()) <= 5;
end

function Factory:SetBreakCondition(Object)
	if Object == nil then
		return true;
	end
	if GetBot():FindItemSlot(Object:GetName()) > 5 then
		return true
	else
		return false
	end
end


return Factory;