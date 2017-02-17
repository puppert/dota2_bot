local TableSide = {};


function GetDesire()
	if #TableSide ~= 2 then
		table.insert(TableSide,GetShopLocation(GetTeam(),SHOP_SIDE));
		table.insert(TableSide,GetShopLocation(GetTeam(),SHOP_SIDE2));
	end

	local npcBot = GetBot();
	local desire = 0.0;
	
	if npcBot.nextItem == "" then
		return 0.0;
	end
	
	if IsItemPurchasedFromSideShop(npcBot.nextItem) and IsItemPurchasedFromSecretShop( npcBot.nextItem ) then
		if npcBot:DistanceFromSecretShop() > npcBot:DistanceFromSideShop() then
			desire = 0.8;
		end
	end
	
	if IsItemPurchasedFromSideShop(npcBot.nextItem) and not IsItemPurchasedFromSecretShop( npcBot.nextItem ) then
		desire = 0.8;
	end
	
	if npcBot:DistanceFromSideShop() > 3000 then
		desire = 0.0;
	end
	--print("secret desire:"..desire .. " secretdistance:".. npcBot:DistanceFromSecretShop())
	return Clamp( desire, BOT_MODE_DESIRE_NONE, BOT_MODE_DESIRE_ABSOLUTE );
end

function OnStart()
	
end

----------------------------------------------------------------------------------------------------

function OnEnd() 

end

----------------------------------------------------------------------------------------------------

function Think()
	local npcBot = GetBot();
	table.sort(TableSide,CompareDistance);
	
	npcBot:Action_MoveToLocation(TableSide[1]);
	
end

function CompareDistance(a,b)
	local npcBot = GetBot();
	disA = GetUnitToLocationDistance(npcBot,a);
	disB = GetUnitToLocationDistance(npcBot,b);
	return disA < disB
end
