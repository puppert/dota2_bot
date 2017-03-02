local Factory = {};

function Factory:New(o)
	o = o or {};
	setmetatable(o,self);
	self._index = self
	return o;
end

function Factory:CreatTable()
	local tables = {}; 
	local count = 0;
	while true do
		local object = self:GetObject(count);
		if self:SetCondition(object) then
			local heroname = string.gsub(GetBot():GetUnitName(),"npc_dota_hero_","");
			local  name = string.gsub(object:GetName(),heroname,"ability");
			local finalname = string.gsub(name,"_%l",function(s)
													return string.upper(string.sub(s,2))
													end
													)
			tables[finalname] = object;
		elseif self:SetBreakCondition(object) then
			break;
		end
		count = count +1;
	end
	return tables;
end

function Factory:GetObject(count)
	return GetBot():GetAbilityInSlot(count);
end

function Factory:SetCondition(Object)
	return false;
end

function Factory:SetBreakCondition(Object)
	return false;
end

return Factory;