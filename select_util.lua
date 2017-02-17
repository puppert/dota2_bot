local W = {};
local Hcharacter = require(GetScriptDirectory().."/hero_character");
W.tableheroes = Hcharacter["tableheroes"];




highestPoint = 0;
chosetable = {};
count = 0;

function W:GetLane()
	local teamradiant = self:givebotcharacter();
	local lane = {};
	if teamradiant ~= nil then
		if GetTeam() == TEAM_RADIANT then
			for k,v in ipairs(teamradiant) do
				for i,j in ipairs(GetTeamPlayers(GetTeam())) do
					if k == 1 and v:GetPlayerID() == j then
						lane[i] = LANE_BOT
					elseif k == 2 and v:GetPlayerID() == j then	
						lane[i] = LANE_MID
					elseif k == 3 and v:GetPlayerID() == j then
						lane[i] = LANE_TOP
					elseif k == 4 and v:GetPlayerID() == j then
						lane[i] = LANE_BOT
					elseif k == 5 and v:GetPlayerID() == j then
						lane[i] = LANE_BOT
					end
				end
			end
		elseif GetTeam() == TEAM_DIRE then
			for k,v in ipairs(teamradiant) do
				for i,j in ipairs(GetTeamPlayers(GetTeam())) do
					if k == 1 and v:GetPlayerID() == j then
						lane[i] = LANE_TOP
					elseif k == 2 and v:GetPlayerID() == j then	
						lane[i] = LANE_MID
					elseif k == 3 and v:GetPlayerID() == j then
						lane[i] = LANE_BOT
					elseif k == 4 and v:GetPlayerID() == j then
						lane[i] = LANE_TOP
					elseif k == 5 and v:GetPlayerID() == j then
						lane[i] = LANE_TOP
					end
				end
			end
		end
	end
	
	return lane;
end



function W:givebotcharacter()
	local team = GetTeam();
	local PlayIDs = GetTeamPlayers(team);
	local players = {};
	
	for k,v in pairs(PlayIDs) do
		table.insert(players,GetTeamMember(k));
		--print(GetTeamMember(team,v-1):GetUnitName());
	end
	
	
	if self:fullpermutation(players,1) then
		if #chosetable  == 5 then
			for k,v in ipairs(chosetable) do
				--print(k..".."..v:GetUnitName());
				if k == 1 then
					v.character = "Carry";
				elseif k == 2 then	
					v.character = "Solo";
				elseif k == 3 then
					v.character = "Offline";
				elseif k == 4 then
					v.character = "Support";
				elseif k == 5 then
					v.character = "HardSupport";
				end
			end
		end
		return chosetable;
	end
end

function W:fullpermutation(Table,index)
	if index == (#Table+1) then
		local point = 0;
		for k,v in ipairs(Table) do
			local unitname = v:GetUnitName();
			if k == 1 then
				point = point + self.tableheroes[unitname].Carry;
			elseif k == 2 then
				point = point + self.tableheroes[unitname].Solo;
			elseif k == 3 then
				point = point + self.tableheroes[unitname].Offline;
			elseif k == 4 then
				point = point + self.tableheroes[unitname].Support;
			elseif k == 5 then
				point = point + self.tableheroes[unitname].HardSupport;
			end
		end
		count = count+1;
		--print("highestPoint.."..highestPoint.."point.."..point);
		if point > highestPoint then
			highestPoint = point;
			chosetable = {};
			for k,v in ipairs(Table) do
				table.insert(chosetable,v);
			end
		end
		return false;
	end
	
	local i;
	
	for i = index,#Table do
		Table[index],Table[i] = swap(Table[index],Table[i]) ;
		self:fullpermutation(Table,index+1);
		Table[index],Table[i] = swap(Table[index],Table[i]) ;
		
	end
	
	return true;
end


function swap(a,b) 
	if a:GetUnitName() == b:GetUnitName() then
		return a,b;
	end
	return b,a;
end
return W;