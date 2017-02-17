local TableSecret = {};


function GetDesire()
	if #TableSecret ~= 2 then
		table.insert(TableSecret,GetShopLocation(GetTeam(),SHOP_SECRET));
		table.insert(TableSecret,GetShopLocation(GetTeam(),SHOP_SECRET2));
	end
	--print(TableSecret[1]);
	
	local npcBot = GetBot();
	local desire = 0.0;
	if IsItemPurchasedFromSideShop(npcBot.nextItem) and IsItemPurchasedFromSecretShop( npcBot.nextItem ) then
		if npcBot:DistanceFromSecretShop() < npcBot:DistanceFromSideShop() then
			desire = 0.8;
		end
	end
	
	if not IsItemPurchasedFromSideShop(npcBot.nextItem) and IsItemPurchasedFromSecretShop( npcBot.nextItem ) then
			desire = 0.8;
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
	table.sort(TableSecret,CompareDistance);
	
	npcBot:Action_MoveToLocation(TableSecret[1]);
	
end

function CompareDistance(a,b)
	local npcBot = GetBot();
	disA = GetUnitToLocationDistance(npcBot,a);
	disB = GetUnitToLocationDistance(npcBot,b);
	return disA < disB
end
