local Monion = {}

function State:New(o)
	o = o or {};
	setmetatable(o,self)
	self._index = self;
	o.current = require(GetScriptDirectory() .. "/state/minion_ability_state/centaur_khan_state");
	return o;
end

function Monion:sethMinionUnit(hMinionUnit)
	self.hMinionUnit = hMinionUnit;
end

function Monion:setState(c)
	self.current = c;
end

function Monion:setTarget(t)
	self.target = t;
end

function Monion:Consider()
	self.current:Consider(Monion);
end

function Monion:Excute()
	self.current:Excute(Monion);
end


return Monion;