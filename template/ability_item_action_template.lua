local template = {};

function template:ActionTemplate(cast,Table)
	local npcBot = GetBot();
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