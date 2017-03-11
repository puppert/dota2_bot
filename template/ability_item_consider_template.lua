P = {}

function P:New(o)
	o = o or {}
	setmetatable(o,self);
	self._index = self
	return o;
end

P.aName = "";
P.specialName = {};

function P:aConsider()
	local npcBot = GetBot();
	self.ability = npcBot:GetAbilityByName(self.aName);
	self.specialValue = {};
	for k,v in ipairs(self.specialName) do 
		local sValue = ability:GetSpecialValueInt(v) or ability:GetSpecialValueFloat(v);
		self.specialValue[v] = sValue;
	end
	self:aSpecialConsider();
	
	
	return BOT_ACTION_DESIRE_NONE,0
end

function P:aSpecialConsider()

end



return P;