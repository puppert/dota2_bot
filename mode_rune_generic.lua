local utils = require(GetScriptDirectory() .. "/util")
local myutil = require(GetScriptDirectory() .. "/myutil")
----------------------------------------------------------------------------------------------------

local npcBot = GetBot()
local team = GetTeam()
local min = 0
local sec = 0
local runetime = 0;
----------------------------------------------------------------------------------------------------

function GetDesire()
	--print(tostring(GetRuneStatus( RUNE_BOUNTY_1 ) == RUNE_STATUS_AVAILABLE ))
	min = math.floor(DotaTime() / 60)
	sec = DotaTime() % 60
	
	if npcBot:GetActiveMode() == BOT_MODE_RETREAT or
		npcBot:GetActiveMode() == BOT_MODE_EVASIVE_MANEUVERS or
		npcBot:GetActiveMode() == BOT_MODE_ATTACK or
		npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY then
		return BOT_MODE_DESIRE_NONE
	end
	
	
	runetime = GetUnitToLocationDistance(npcBot,myutil.nearestrunepoint(npcBot))/npcBot:GetCurrentMovementSpeed();
	--set clone#
	--respawn camps
	if npcBot.character == "Solo" then
		local itemBottle	=	"item_bottle";
		for i=0, 5 do
			if(npcBot:GetItemInSlot(i) ~= nil) then
				local _item = npcBot:GetItemInSlot(i):GetName();
				if(_item == "item_bottle") then
						itemBottle = npcBot:GetItemInSlot(i);
				end
			end
		end
		if ( npcBot:GetActiveMode() ~= BOT_MODE_RETREAT and
		npcBot:GetActiveMode() ~= BOT_MODE_EVASIVE_MANEUVERS and
		npcBot:GetActiveMode() ~= BOT_MODE_ATTACK and
		npcBot:GetActiveMode() ~= BOT_MODE_DEFEND_ALLY and
		itemBottle ~= "item_bottle" and
		min % 2 == 1 and sec > (58-runetime)) 
		then
			return 0.7;
		end
	end
	
	if npcBot.character == "Offline" then
		if ( npcBot:GetActiveMode() ~= BOT_MODE_RETREAT and
		npcBot:GetActiveMode() ~= BOT_MODE_EVASIVE_MANEUVERS and
		npcBot:GetActiveMode() ~= BOT_MODE_ATTACK and
		npcBot:GetActiveMode() ~= BOT_MODE_DEFEND_ALLY and
		min % 2 == 1 and sec > (58-runetime)) 
		then
			return 0.6;
		end
	end
	
	--NO
	if npcBot.character == "Support" then
		if ( npcBot:GetActiveMode() ~= BOT_MODE_RETREAT and
		npcBot:GetActiveMode() ~= BOT_MODE_EVASIVE_MANEUVERS and
		npcBot:GetActiveMode() ~= BOT_MODE_ATTACK and
		npcBot:GetActiveMode() ~= BOT_MODE_DEFEND_ALLY) then
			if (min % 2 == 1 and sec > (57-runetime)) then
				return 0.9;
			elseif  min % 2 == 0 and sec < 30 then
				local runepoint,rune = myutil:nearestbountyrunepoint(npcBot);
				if GetRuneStatus(rune) == RUNE_STATUS_UNKNOWN 
				or GetRuneStatus(rune) == RUNE_STATUS_AVAILABLE  then
					return 0.6;
				end
			end
		end
	end
	
	
	if (GetUnitToLocationDistance( npcBot , GetRuneSpawnLocation(RUNE_POWERUP_1)) < 800 and
		GetRuneStatus( RUNE_POWERUP_1 ) == RUNE_STATUS_AVAILABLE )
	or	(GetUnitToLocationDistance( npcBot , GetRuneSpawnLocation(RUNE_POWERUP_2)) < 800 and
		GetRuneStatus( RUNE_POWERUP_2 ) == RUNE_STATUS_AVAILABLE )
	or (GetUnitToLocationDistance( npcBot , GetRuneSpawnLocation(RUNE_BOUNTY_1)) < 800 and
		GetRuneStatus( RUNE_BOUNTY_1 ) == RUNE_STATUS_AVAILABLE )
	or	(GetUnitToLocationDistance( npcBot , GetRuneSpawnLocation(RUNE_BOUNTY_2)) < 800 and
		GetRuneStatus( RUNE_BOUNTY_2 ) == RUNE_STATUS_AVAILABLE )
	or  (GetUnitToLocationDistance( npcBot , GetRuneSpawnLocation(RUNE_BOUNTY_3)) < 800 and
		GetRuneStatus( RUNE_BOUNTY_3 ) == RUNE_STATUS_AVAILABLE )
	or (GetUnitToLocationDistance( npcBot , GetRuneSpawnLocation(RUNE_BOUNTY_4)) < 800 and
		GetRuneStatus( RUNE_BOUNTY_4 ) == RUNE_STATUS_AVAILABLE )
	then    
    	return BOT_MODE_DESIRE_HIGH;
    end
	
end

----------------------------------------------------------------------------------------------------

function OnStart()
	
end

----------------------------------------------------------------------------------------------------

function OnEnd() 

end

----------------------------------------------------------------------------------------------------

function Think()	
	min = math.floor(DotaTime() / 60)
	sec = DotaTime() % 60

	if (npcBot:GetActiveMode() ~= BOT_MODE_RETREAT and
		npcBot:GetActiveMode() ~= BOT_MODE_EVASIVE_MANEUVERS and
		npcBot:GetActiveMode() ~= BOT_MODE_DEFEND_ALLY and
		GetUnitToLocationDistance(npcBot,myutil.nearestrunepoint(npcBot)) <= 800)
	then
		GrabRune()
		return;
	end
	
	if npcBot.character == "Offline" or npcBot.character == "Solo" then
		npcBot:Action_MoveToLocation(myutil.nearestrunepoint(npcBot));
    	return;
	end
	
	if npcBot.character == "Support" then
		if min % 2 == 1  then
			local runepoint,rune = myutil:nearestbountyrunepoint(npcBot);
			npcBot:Action_MoveToLocation(runepoint);
			return 
		elseif  min % 2 == 0 then
			local runepoint,rune = myutil:nearestbountyrunepoint(npcBot);
			npcBot:Action_MoveToLocation(runepoint);
			return
		end
	end
end

function GrabRune()
	
	-- grab a rune if we walk by it
	if (GetUnitToLocationDistance( npcBot , GetRuneSpawnLocation(RUNE_BOUNTY_1)) < 800 and
		GetRuneStatus( RUNE_BOUNTY_1 ) == RUNE_STATUS_AVAILABLE )
	then   
    	npcBot:Action_PickUpRune(RUNE_BOUNTY_1);
    elseif (GetUnitToLocationDistance( npcBot , GetRuneSpawnLocation(RUNE_BOUNTY_2)) < 800 and
		GetRuneStatus( RUNE_BOUNTY_2 ) == RUNE_STATUS_AVAILABLE )
	then   
    	npcBot:Action_PickUpRune(RUNE_BOUNTY_2);
	elseif (GetUnitToLocationDistance( npcBot , GetRuneSpawnLocation(RUNE_BOUNTY_3)) < 800 and
		GetRuneStatus( RUNE_BOUNTY_3 ) == RUNE_STATUS_AVAILABLE )
	then   
    	npcBot:Action_PickUpRune(RUNE_BOUNTY_3);
	elseif (GetUnitToLocationDistance( npcBot , GetRuneSpawnLocation(RUNE_BOUNTY_4)) < 800 and
		GetRuneStatus( RUNE_BOUNTY_4 ) == RUNE_STATUS_AVAILABLE )
	then    
    	npcBot:Action_PickUpRune(RUNE_BOUNTY_4);
    elseif (GetUnitToLocationDistance( npcBot , GetRuneSpawnLocation(RUNE_POWERUP_1)) < 800 and
		GetRuneStatus( RUNE_POWERUP_1 ) == RUNE_STATUS_AVAILABLE )
	then    
    	npcBot:Action_PickUpRune(RUNE_POWERUP_1);
    elseif (GetUnitToLocationDistance( npcBot , GetRuneSpawnLocation(RUNE_POWERUP_2)) < 800 and
		GetRuneStatus( RUNE_POWERUP_2 ) == RUNE_STATUS_AVAILABLE )
	then    
    	npcBot:Action_PickUpRune(RUNE_POWERUP_2);
    end
end

