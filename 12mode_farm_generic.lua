local utils = require(GetScriptDirectory() .. "/util")
local myutil = require(GetScriptDirectory() .. "/myutil")
local netral = require(GetScriptDirectory() .. "/netrual_util")
----------------------------------------------------------------------------------------------------
STATUS_PULL_LANE_MOVE = "Status_Pull_Lane_Move";
STATUS_PULL_LANE_WAIT = "Status_Pull_Lane_Wait";
STATUS_PULL_LANE_BEGIN = "Status_Pull_Lane_Begin"
STATUS_FARM_LANE = "Status_Farm_Lane"
STATUS_FARM_NETRAL = "Status_Farm_Netral"
local farmstatus = "";

TableNetral = netral:GetNeutral();


local team = GetTeam()
local min = 0
local sec = 0
----------------------------------------------------------------------------------------------------

function GetDesire()
	min = math.floor(DotaTime() / 60)
	sec = DotaTime() % 60
	local npcBot = GetBot()
	
	--respawn camps
	netral:RefreshNeutralStatus();
	
	--print(NetralStatus);
	
	if npcBot.character == "Carry" then
		if npcBot:GetLevel() >= 6  then
		if npcBot:GetActiveMode() ~= BOT_MODE_ATTACK then 
			local count = 0
			local ability;
			while true do 
				ability = npcBot:GetAbilityInSlot(count)
				if ability:IsUltimate() then
					break;
				end
				count = count+1
			end
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
			
			local TableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
			
			if TableNearbyEnemyHeroes[1] == nil then
				if GetLaneFrontAmount(GetTeam(),npcBot:GetAssignedLane(),true) >= 0.6 then
					if flagnum == 3 then
						local modifierName = string.gsub(ability:GetName(),"ability","modifier");
						if not ability:IsFullyCastable() and not npcBot:HasModifier(modifierName) then
							farmstatus = STATUS_FARM_NETRAL;
							return 0.6
						end
					elseif flagnum >3 then
						if not ability:IsFullyCastable() then
							farmstatus = STATUS_FARM_NETRAL;
							return 0.6
						end
					end
				else
					if flagnum == 3 then
						local modifierName = string.gsub(ability:GetName(),"ability","modifier");
						if not ability:IsFullyCastable() and not npcBot:HasModifier(modifierName) then
							farmstatus = STATUS_FARM_LANE;
							return 0.6
						end
					elseif flagnum >3 then
						if not ability:IsFullyCastable() then
							farmstatus = STATUS_FARM_LANE;
							return 0.6
						end
					end
				end
			else
				farmstatus = "";
				return 0;
			end
		end
		end
	end
	
	if npcBot.character == "Solo" then
	end
	
	if npcBot.character == "Offline" then
	end
	
	if npcBot.character == "HardSupport" then
		if npcBot:GetActiveMode() == BOT_MODE_LANING 
		or npcBot:GetActiveMode() == BOT_MODE_FARM then
			if npcBot:GetLevel() < 6 then
				local NetralStatus = GetSupportNetral().status;
				--print(farmstatus);
				if NetralStatus then
					if not IsLocationVisible(GetSupportNetral().location) and GetUnitToLocationDistance(npcBot,GetSupportNetral().location) > 600 and farmstatus == "" then
						farmstatus = STATUS_PULL_LANE_MOVE;
					elseif IsLocationVisible(GetSupportNetral().location) and GetUnitToLocationDistance(npcBot,GetSupportNetral().location) <= 600 then
						if  ((sec >= 43 and sec<=44) or (sec >= 11 and sec <= 12)) and npcBot:NumQueuedActions() <= 0 then
							farmstatus = STATUS_PULL_LANE_BEGIN;
						elseif farmstatus == STATUS_PULL_LANE_MOVE then
							farmstatus = STATUS_PULL_LANE_WAIT;
						end
					end
					if farmstatus ~= "" then
					--	print(farmstatus);
					end
					return BOT_MODE_DESIRE_HIGH; 
				else
					farmstatus = "";
				end
			end
		end
	end
	
	return 0;
end

----------------------------------------------------------------------------------------------------

function OnStart()
	
end

----------------------------------------------------------------------------------------------------

function OnEnd() 

end

----------------------------------------------------------------------------------------------------

function Think()	
	local npcBot = GetBot();
	min = math.floor(DotaTime() / 60)
	sec = DotaTime() % 60
	
	if npcBot:IsChanneling() then
		return
	end
	
	if npcBot.character == "Carry" then
		if farmstatus == STATUS_FARM_NETRAL then
			table.sort(TableNetral,function(a,b) 
									return GetUnitToLocationDistance(npcBot,a.location) < GetUnitToLocationDistance(npcBot,b.location);
									end)
			local cloestNetral;
			for k,v in ipairs(TableNetral) do
				if v.status then
					cloestNetral = v;
					break;
				end
			end
			if cloestNetral ~= nil then
				if npcBot:NumQueuedActions() <= 0 then
					npcBot:ActionQueue_AttackMove(cloestNetral.location);
				end
			end
		elseif farmstatus == STATUS_FARM_LANE then
			local TableNearbyLaneCreeps = npcBot:GetNearbyLaneCreeps(900,true);
			if TableNearbyLaneCreeps[1] ~= nil then
				local nAttack = npcBot:GetAttackDamage();
				for k,v in ipairs(TableNearbyLaneCreeps) do 
					if v:GetHealth() <= nAttack then
						npcBot:Action_AttackUnit(v,false);
						return
					end
				end
				npcBot:Action_AttackUnit(TableNearbyLaneCreeps[1],false);
				return
			else
				npcBot:Action_MoveToLocation(GetLaneFrontLocation(GetTeam(),npcBot:GetAssignedLane(),0))
				return
			end
		end
	end
	
	if npcBot.character == "Solo" then
	end
	
	if npcBot.character == "Offline" then
	end
	
	if npcBot.character == "HardSupport" then
		if farmstatus == STATUS_PULL_LANE_MOVE or farmstatus == STATUS_PULL_LANE_WAIT or farmstatus == STATUS_PULL_LANE_BEGIN  then
			if farmstatus == STATUS_PULL_LANE_MOVE then
				--print("move to pull lane");
				npcBot:Action_MoveToLocation(GetSupportNetral().location)
			elseif farmstatus == STATUS_PULL_LANE_WAIT or farmstatus == STATUS_PULL_LANE_BEGIN  then
				local TableNearbyNeutral = npcBot:GetNearbyNeutralCreeps(600);
				if TableNearbyNeutral[1] ~= nil then
					if  farmstatus == STATUS_PULL_LANE_BEGIN and npcBot:NumQueuedActions() <= 0 then
							npcBot:ActionQueue_AttackUnit(TableNearbyNeutral[1],true);
							npcBot:ActionQueue_MoveToLocation(GetSupportPoint());
							npcBot:ActionQueue_AttackMove(GetSupportNetral().location);
					elseif  farmstatus == STATUS_PULL_LANE_WAIT then
							npcBot:Action_ClearActions(true);
					end
				end
			end
		end
	end
	
	
	return
end
function GetSupportPoint()
	local X = GetSupportNetral().location[1];
	local Y = 0;
	if GetTeam() == TEAM_RADIANT then
		Y = GetTower(GetTeam(),TOWER_BOT_1):GetLocation()[2];
	elseif GetTeam() == TEAM_DIRE then
		Y = GetTower(GetTeam(),TOWER_TOP_1):GetLocation()[2];
	end
	
	return Vector(X,Y);
end

function GetSupportNetral()
	for k,v in ipairs(TableNetral) do
		if (v.name == "basic_1") then
			return v;
		end
	end
end