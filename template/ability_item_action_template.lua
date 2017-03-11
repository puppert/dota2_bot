local template = {};

function template:ActionTemplate(Table)
	local npcBot = GetBot();
	local cast = {};
	for k,v in pairs(Table) do
		local tablecast = {};
		if v["Consider"] ~= nil and v:IsFullyCastable() then
			tablecast[1],tablecast[2] = v["Consider"](); 
		else
			tablecast[1],tablecast[2] = 0, 0;
		end
		cast[k] = tablecast;
	end
	local TableKey = {};
	for k,v in pairs(cast) do
		table.insert(TableKey,k);
	end
	table.sort(TableKey,function(a,b) return cast[a][1] > cast[b][1] end);
	local firstkey = TableKey[1];
	
	if cast[firstkey] ~= nil then
		if cast[firstkey][1] > 0 then
			local abilitytouse = Table[firstkey];
			local target = cast[firstkey][2];
			if type(target) == "nil" then
				npcBot:Action_UseAbility(abilitytouse);
			elseif type(target) == "number" then
				npcBot:Action_UseAbilityOnTree(abilitytouse,target);
			elseif type(target) == "userdata" then
				npcBot:Action_UseAbilityOnLocation(abilitytouse,target);
			elseif type(target) == "table" then
				npcBot:Action_UseAbilityOnEntity(abilitytouse,target);
			end
		end
	end
end	

return template;