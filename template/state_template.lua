local State = {}

State.hName = "";
State.aName = "";
State.nextstate = "";

function State:New(o)
	o = o or {};
	setmetatable(o,self)
	self._index = self;
	return o;
end

function State:Consider(minion)
	if string.find(minion.hMinionUnit:GetUnitName(),self.hName) ~= nil then
		self.ability = minion.hMinionUnit:GetAbilityByName(self.aName);
		if not self.ability :IsFullyCastable() then
			return BOT_ACTION_DESIRE_NONE,0;
		end
		return self:specificConsider(minion.hMinionUnit);
	elseif self.nextstate ~= "" then
		minion:setState(self.nextstate);
		minion:Consider();
	else
		return nil;
	end
end

function State:specificConsider(hMinionUnit)
	return 0;
end

function State:Excute(minion)
	if string.find(minion.hMinionUnit:GetUnitName(),self.hName) ~= nil then
		self:specificExcute(minion.hMinionUnit,self.ability,minion.target);
	elseif self.nextstate ~= "" then
		minion:setState(self.nextstate);
		minion:Excute();
	end
end

function State:specificExcute(hMinionUnit,ability,abilityTarget)
end

return State;
