X = {}

function X:ConsiderComplete(env) 
	local npcBot = GetBot();
	local abilityTable = {};
	local count = 0;
	while not GetBot():GetAbilityInSlot(count):IsTalent() do
		table.insert(abilityTable,GetBot():GetAbilityInSlot(count));
		count = count + 1;
	end
	
	for _,name in pairs(TableConsider) do
		local flag = false ;
		for k,v in pairs(env) do
			if name == k then
				flag = true;
			end
		end
		if not flag then
			env[name] = self:ConsiderFactory(name);
		end
	end
	
	return env;
end

function X:ConsiderFactory(ConsiderName)
	local npcBot = GetBot();
	
	local abilityName = string.gsub(ConsiderName,"Consider","ability");
	local ability = npcBot["ability"][abilityName];
	
	local behavior = ability:GetBehavior()
	local behaviorbit = myutil:GetBehavior(behavior);
	local flagnum = 0;
	for k,v in ipairs(behaviorbit) do
		if v == 1 and k <= 9 then
		--[==[
			DOTA_ABILITY_BEHAVIOR_HIDDEN = 1 : This ability can be owned by a unit but can't be casted and wont show up on the HUD.
			DOTA_ABILITY_BEHAVIOR_PASSIVE = 2 : Can't be casted like above but this one shows up on the ability HUD
			DOTA_ABILITY_BEHAVIOR_NO_TARGET = 3 : Doesn't need a target to be cast, ability fires off as soon as the button is pressed
			DOTA_ABILITY_BEHAVIOR_UNIT_TARGET = 4 : Ability needs a target to be casted on.
			DOTA_ABILITY_BEHAVIOR_POINT = 5 : Ability can be cast anywhere the mouse cursor is (If a unit is clicked it will just be cast where the unit was standing)
			DOTA_ABILITY_BEHAVIOR_AOE = 6 : This ability draws a radius where the ability will have effect. YOU STILL NEED A TARGETTING BEHAVIOR LIKE DOTA_ABILITY_BEHAVIOR_POINT FOR THIS TO WORK.
			DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE = 7 : This ability probably can be casted or have a casting scheme but cannot be learned (these are usually abilities that are temporary like techie's bomb detonate)
			DOTA_ABILITY_BEHAVIOR_CHANNELLED = 8 : This abillity is channelled. If the user moves or is silenced the ability is interrupted.
			DOTA_ABILITY_BEHAVIOR_ITEM = 9 : This ability is tied up to an item.
		]==]--
			flagnum = k;
		end
	end
	
	local Function;
	
	if flagnum == 1 then
		Function = function() return 0 end
	elseif flagnum == 2 then
		Function = function() return 0 end
	elseif flagnum == 3 then
		Function = self.ConsiderNoTarget;
	elseif flagnum == 4 then
		Function = self.ConsiderUnitTarget;
	elseif flagnum == 5 then
		Function = self.ConsiderPoint;
	elseif flagnum == 6 then
		Function = self.ConsiderAOE;
	elseif flagnum == 7 then

	elseif flagnum == 8 then
	
	elseif flagnum == 9 then
	
	end
	
	return Function;
end  

function X:ConsiderNoTarget()

end

return X