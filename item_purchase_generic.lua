local item_to_buy = require(GetScriptDirectory() .. "/item_to_buy")
local myutil = require(GetScriptDirectory().."/myutil")
local build ;
if(GetBot():IsHero()) then	
	build = require(GetScriptDirectory() .. "/builds/item_build_" .. string.gsub(GetBot():GetUnitName(), "npc_dota_hero_", ""))
end
if build == "NOT IMPLEMENTED" then return end
if build == nil then return end
local support = require(GetScriptDirectory().."/support_item")

----------------------------------------------------------------------------------------------------


--[[ Set up your item build.  Remember to use base items.  
To build an derived item like item_magic_wand you will just 
buy the four base items so take care to get items in your 
inventory in the correct order! ]]



-- local character = GetBot().character;
-- if character == nil then
	-- return
-- end
-- local tableItemsToBuy = build[character.."_items"]

-- Think function to purchase the items and call the skill point think
function ItemPurchaseThink()
	
	local npcBot
	if(GetBot():IsHero()) then	
		npcBot = GetBot();
	end
	
	if npcBot == nil or npcBot.character == nil or build == nil then return end
	
	--translate table ,true table is GetBot().ItemTable
	if npcBot.ItemTable == nil then
		local tableItemsToBuy = build[npcBot.character.."_items"];
		--print(npcBot.character .. "...".. npcBot:GetUnitName())
		if tableItemsToBuy ~= nil then
			item_to_buy:GetItemTable(tableItemsToBuy);
		end
	end
    
	if npcBot.ItemTable == nil then print(npcBot:GetUnitName()..",,,"..npcBot.character)return end
	
    -- check if real meepo
    if( GetBot():GetUnitName() == "npc_dota_hero_meepo") then
        if(GetBot():GetLevel() > 1) then
            for i=0, 5 do
                if(npcBot:GetItemInSlot(i) ~= nil ) then
                    if not (npcBot:GetItemInSlot(i):GetName() == "item_boots" or npcBot:GetItemInSlot(i):GetName() == "item_power_treads") then
                        break
                    end
                end
                if i == 5 then
                    return
                end
            end
        end
    end
	
    --print(npcBot:GetUnitName())
	--get Tp
	local hastp =false;
	for i=0, 8 do
        if(npcBot:GetItemInSlot(i) ~= nil ) then
            if (npcBot:GetItemInSlot(i):GetName() == "item_tpscroll" 
			or npcBot:GetItemInSlot(i):GetName() == "item_travel_boots") then
				hastp =true;
                break;
            end
        end
    end
	if(not hastp and DotaTime() > 60)then
		if(npcBot:DistanceFromFountain() == 0
		or npcBot:DistanceFromSideShop() < 300)then
			if(npcBot:IsAlive()) then
				npcBot:ActionImmediate_PurchaseItem("item_tpscroll");
				hastp = true;
			end
		end
	end
	
	
	if npcBot.character == "HardSupport" then
		local flag = support:BuySupportItem();
		if flag then
			return;
		end
	end
	
	
	
	
	if ( #npcBot.ItemTable == 0 )
	then
		npcBot:SetNextItemPurchaseValue( 0 );
		return;
	end
	
	npcBot.nextItem = npcBot.ItemTable[1];
	
	if npcBot:GetGold() < GetItemCost(npcBot.nextItem) then
		npcBot.nextItem = "";
		return
	else
		if IsItemPurchasedFromSideShop(npcBot.nextItem) and npcBot:DistanceFromSideShop() > 0 and npcBot:DistanceFromSideShop() <= 3000 then
			return
		end
        
        if IsItemPurchasedFromSecretShop(npcBot.nextItem) and  npcBot:DistanceFromSecretShop() > 0  and npcBot:DistanceFromSideShop() > 0 then
            return
        end
		if npcBot:ActionImmediate_PurchaseItem( npcBot.nextItem ) == PURCHASE_ITEM_SUCCESS then
            npcBot.nextItem = "";
			table.remove(npcBot.ItemTable,1);
        end
	end
end

----------------------------------------------------------------------------------------------------

