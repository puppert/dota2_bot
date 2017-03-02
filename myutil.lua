local W={};
----------------------------------------------------------------------------------------

--find the closet point to pointA in range of PointB
function W.closestPoint(PointA,PointB,range,distance)
	local sdcos = (PointA[1] - PointB[1])/ distance;
	local sdsin = (PointA[2] - PointB[2])/ distance;
	
	local pointC = Vector(PointB[1] + range * sdcos,PointB[2] + range * sdsin);
	return pointC;
end

-----------------------------------------------------------------------------------------

--find the farthest point to pointA in range of PointB
function W.farthestPoint(PointA,PointB,range,distance)
	local sdcos = (PointB[1] - PointA[1])/ distance;
	local sdsin = (PointB[2] - PointA[2])/ distance;
	
	local pointC = Vector(PointB[1] + range * sdcos,PointB[2] + range * sdsin);
	return pointC;

end

------------------------------------------------------------------------------------------
-- find the farthest point to tablepoint in circle of PointT
function W.farthestpointtotable(tablepoint,PointT,Radius)
	local maxdistance = 0;
	local x1 = 0;
	local y1 = 0;
	for k,v in ipairs(tablepoint) do
		maxdistance = maxdistance + math.pow((PointT[1] + Radius - v:GetLocation()[1]),2)
					+  math.pow((PointT[2] - v:GetLocation()[2]),2);
	end
	for angle=0,2*math.pi,10/Radius do 
		local x=PointT[1]+Radius*math.cos(angle);
		local y=PointT[2]+Radius*math.sin(angle);
		local distance = 0;
		for k,v in pairs(tablepoint) do
			distance = distance + math.pow((x - v:GetLocation()[1]),2)
					+  math.pow((y - v:GetLocation()[2]),2);
		end
		if distance > maxdistance then
			maxdistance = distance;
			x1=x;
			y1=y;
		end
	end
	local point = Vector(x1,y1);
	return point;
end

---------------------------------------------------------------------------------------------------
--find nearest rune location
function W.nearestrunepoint(hunit)
	local tablerune = {RUNE_POWERUP_1,RUNE_POWERUP_2,RUNE_BOUNTY_1,RUNE_BOUNTY_2,RUNE_BOUNTY_3,RUNE_BOUNTY_4};
	local distance = 1000000;
	local runepoint = nil;
	for k,v in ipairs(tablerune) do
		if GetUnitToLocationDistance( hunit , GetRuneSpawnLocation(v)) < distance
		then
			distance = GetUnitToLocationDistance( hunit , GetRuneSpawnLocation(v))
			runepoint = GetRuneSpawnLocation(v);
		end
	end
	return runepoint;
end

function W:nearestbountyrunepoint(hunit)
	local tablerune = {RUNE_BOUNTY_1,RUNE_BOUNTY_2,RUNE_BOUNTY_3,RUNE_BOUNTY_4};
	local distance = 1000000;
	local runepoint = nil;
	local rune = 0;
	for k,v in ipairs(tablerune) do
		if GetUnitToLocationDistance( hunit , GetRuneSpawnLocation(v)) < distance
		then
			distance = GetUnitToLocationDistance( hunit , GetRuneSpawnLocation(v));
			runepoint = GetRuneSpawnLocation(v);
			rune = v;
		end
	end
	return runepoint,rune;
end
--------------------------------------------------------------------------------------------------

function W.updateOpentime(opentime)
	if(W["opentime"] == nil) then
		W["opentime"] = 0
	end
	W["opentime"] = opentime;
end
-------------------------------------------------------------------------------------------
function W.GetOpentime()
	local opentime = W["opentime"];
	if(opentime == nil) then
		opentime = 0;
	end
	return opentime;
end
----------------------------------------------------------------------------------------------------
function W.updateClosetime(closetime)
	if(W["closetime"] == nil) then
		W["closetime"] = 0
	end
	W["closetime"] = closetime;
end
-------------------------------------------------------------------------------------------
function W.GetClosetime()
	local closetime = W["closetime"];
	if(closetime == nil) then
		closetime = 0;
	end
	return closetime;
end
----------------------------------------------------------------------------------------------------
--get the tower to tp to attack or defend

function W.GetTowertoTp()
	local npcBot = GetBot();
	local mode = "";
	local tower = nil;
	local lane = 0;
	local modes={};
	modes["MODE_PUSH_TOWER_TOP"] = BOT_MODE_PUSH_TOWER_TOP;
	modes["MODE_DEFEND_TOWER_TOP"] = BOT_MODE_DEFEND_TOWER_TOP;
	modes["MODE_PUSH_TOWER_MID"] = BOT_MODE_PUSH_TOWER_MID;
	modes["MODE_DEFEND_TOWER_MID"] = BOT_MODE_DEFEND_TOWER_MID;
	modes["MODE_PUSH_TOWER_BOT"] = BOT_MODE_PUSH_TOWER_BOT;
	modes["MODE_DEFEND_TOWER_BOT"] = BOT_MODE_DEFEND_TOWER_BOT;
	modes["MODE_LANING"] = BOT_MODE_LANING;
	--GetActiveMode:string
	for k,v in pairs(modes) do
		if(npcBot:GetActiveMode() == v) then
			mode = k;
			break;
		end
	end
	--print(mode);
	if(mode == "MODE_LANING") then
		lane = npcBot:GetAssignedLane();
		local lanestring = W.GetLanestring(lane);
		tower = W.GetTowerbystring(lanestring);
	else
		tower = W.GetTowerbystring(mode);
		lane = W.GetLanebyModestring(mode);
	end
	-- if(tower ~= nil) then
		-- print(tower:GetUnitName().."++"..lane);
	-- end
	return tower,lane;
end
------------------------------------------------------------------------------------------
function W.GetLanestring(lane)
	local lanes = {};
	lanes["TOP"] = LANE_TOP;
	lanes["MID"] = LANE_MID;
	lanes["BOT"] = LANE_BOT;
	
	local lanestring = "";
	for k,v in pairs(lanes) do
		if(lane == v) then
			lanestring = k;
		end
	end
	return lanestring;
end
-----------------------------------------------------------------------------------
function W.GetLanebyModestring(modestring)
	local lanes = {};
	lanes["TOP"] = LANE_TOP;
	lanes["MID"] = LANE_MID;
	lanes["BOT"] = LANE_BOT;
	local lane = 0;
	for k,v in pairs(lanes) do
		if(string.find(modestring,k) ~= nil) then
			lane = v;
		end
	end
	return lane;
end
-------------------------------------------------------------------------------------
function W.GetTowerbystring(strings)
	local towers={};
	towers["TOP"] = {TOWER_TOP_1,TOWER_TOP_2,TOWER_TOP_3};
	towers["MID"] = {TOWER_MID_1,TOWER_MID_2,TOWER_MID_3};
	towers["BOT"] = {TOWER_BOT_1,TOWER_BOT_2,TOWER_BOT_3};
	local tower = nil;
	for k,v in pairs(towers) do
		--print(k.."++"..strings.."find"..string.find(strings,k));
		if(string.find(strings,k) ~= nil) then
			for i,j in ipairs(towers[k]) do
				--print(k.."++"..strings.."find++"..GetTower(GetTeam(),j):GetUnitName());
				if(GetTower(GetTeam(),j)~=nil) then
					tower = GetTower(GetTeam(),j);
					break;
				end
			end
		end
	end
	return tower;
end
-------------------------------------------------------------------------------------
-----use Armlet when Hp <= lowHp
-- function W.lowHpUseArmlet(lowhp)
	-- local  npcBot = GetBot();
	-- local opentime = W.GetOpentime();
	-- local closetime = W.GetClosetime();
	
	-- if(	npcBot:HasModifier("modifier_item_armlet_unholy_strength")
		-- --and not npcBot:WasRecentlyDamagedByAnyHero( 0.3 )
		-- and npcBot:GetHealth()<=lowhp
		-- and DotaTime() > (closetime + 0.6))
		-- then 
			-- W.updateClosetime(DotaTime());
			-- return BOT_ACTION_DESIRE_HIGH;
		-- end; 
		-- if( not npcBot:HasModifier("modifier_item_armlet_unholy_strength")
		-- and npcBot:GetHealth()<=20 and DotaTime() > (opentime + 0.6))
		-- then
			-- W.updateOpentime(DotaTime());
			-- return BOT_MODE_DESIRE_ABSOLUTE ;
		-- end;
-- end

-----------------------------------------------------------------------------------------
function W.checkcreepinrectangle(targetloc,creep,length,width)
	local npcBot = GetBot();
	local pointN = npcBot:GetLocation();
	local pointT = targetloc;
	local pointC = creep:GetLocation();
	
	local NT = Vector(pointT[1]-pointN[1],pointT[2]-pointN[2]);
	local NC = Vector(pointC[1]-pointN[1],pointC[2]-pointN[2]);
	
	local lNT = GetUnitToLocationDistance(npcBot,targetloc);
	local lNC = GetUnitToUnitDistance(npcBot,creep);
	
	local cosCNT = (NT[1]*NC[1]+NT[2]*NC[2])/(lNT*lNC);
	local sinCNT = math.sqrt(1-math.pow(cosCNT,2));
	
	if((lNC*cosCNT) < length and (lNC*sinCNT) < (width/2)) then
		return true;
	else
		return false;
	end
end
-----------------------------------------------------------------------------------------
function W.checkifblocked()
	local npcBot = GetBot();
	if(npcBot:GetCurrentActionType() == BOT_ACTION_TYPE_MOVE_TO
	and (npcBot:GetVelocity()[1] <= 1 and npcBot:GetVelocity()[2] <= 1
	and #npcBot:GetNearbyTrees(150) >=3 and npcBot:GetActiveMode() ~= BOT_MODE_LANING))then
		return true;
	end
	if GetHeightLevel(npcBot:GetLocation()) == 5 then
		return true;
	end
	return false;
end
--------------------------------------------------------------------------------------------
function W:ChoseEnemyTarget()
	local npcBot = GetBot()
	local TableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	if npcBot:GetTarget() ~= nil then
		local nTarget = npcBot:GetTarget();
		if nTarget:IsHero() and GetTeamForPlayer(nTarget:GetPlayerID()) ~= GetTeam() then
			return nTarget;
		end
	end
	if TableNearbyEnemyHeroes[1] ~= nil then
		return TableNearbyEnemyHeroes[1];
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function W:ChoseFriendlyTarget()
	local npcBot = GetBot()
	local TableNearbyFriendlyHeroes = npcBot:GetNearbyHeroes(1300,false,BOT_MODE_NONE);
	if npcBot:GetTarget() ~= nil then
		local nTarget = npcBot:GetTarget();
		if nTarget:IsHero() and GetTeamForPlayer(nTarget:GetPlayerID()) == GetTeam() then
			return nTarget;
		end
	end
	if TableNearbyFriendlyHeroes[1] ~= nil then
		return TableNearbyFriendlyHeroes[1];
	end
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function W:GetBehavior(Behavior)
	local BehaviorBit = {};
	local B = Behavior;
	while B >= 1 do
		local n = B % 2 ;
		table.insert(BehaviorBit,n);
		B,_ = math.modf(B / 2);
	end
	return BehaviorBit;
end
return W;