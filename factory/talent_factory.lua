factory = require(GetScriptDirectory().."/factory/factory_parrent")


-- factory = {};
-- function factory:New()
	-- o = {};
	-- setmetatable(o,{__index = self});
	-- return o;
-- end

-- function factory:CreatTable()
	-- print("123")
-- end

F = factory:New();
-- print(getmetatable(F)._index)
-- print(factory)
-- print(getmetatable(Factory)._index)
print(type(F["CreatTable"]))


function F:GetObject(count)
	return GetBot():GetAbilityInSlot(count);
end

function F:SetCondition(c)
	if c == nil then
		return false;
	end
	return c:IsTalent();
end

function F:SetBreakCondition(bc)
	if bc == nil then
		return true
	else
		return false
	end
end

return F;