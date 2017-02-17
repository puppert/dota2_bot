S = {};
if S.supportitem == nil then
	S.supportitem = {["item_courier"] = false, ["item_flying_courier"] = false, ["item_ward_observer"] = false
		,["item_ward_sentry"] = false,["item_smoke_of_deceit"] = false, ["item_dust"] = false, ["item_gem"] = false};
end


--support
----------------------------------------------------------------------------------------
-- Buy support item
function S:BuySupportItem()
	local npcBot = GetBot();
	local enemyheroes = GetUnitList(UNIT_LIST_ENEMY_HEROES);
	
	if(not self.supportitem["item_courier"]) then
		if(GetNumCouriers() == 0) then
			self.supportitem["item_courier"] = true;
			print("ready to buy courier..");
		end
	else 
		if(GetNumCouriers() > 0 ) then
			self.supportitem["item_courier"] = false;
			print("had courier");
		end
	end
	
	if(not self.supportitem["item_flying_courier"]) then
		if(GetNumCouriers() >=1) then
			local cSpeed = GetCourier(GetNumCouriers() - 1):GetBaseMovementSpeed();
			if(cSpeed == 350) then
				self.supportitem["item_flying_courier"] = true;
			end
		end
	else
		local cSpeed = GetCourier(GetNumCouriers() - 1):GetBaseMovementSpeed();
		if(cSpeed >= 400) then
			self.supportitem["item_flying_courier"] = false;
		end
	end
	
	-- if(enemyheroes[1] ~= nil) then
		-- for k,v in pairs(enemyheroes) do
			-- if v:HasInvisibility(true) then
				-- self.supportitem["item_dust"] = true;
			-- end
		-- end
	-- end
	
	for k,v in pairs(self.supportitem) do
		if(v and npcBot:GetGold() >= GetItemCost(k) and GetItemStockCount(k) > 0) then
			npcBot:ActionImmediate_PurchaseItem(k);
			self.supportitem[k] = false;
			return true;
		end
	end
	
	return false;
end

-------------------------------------------------------------------------------------
function S:UseSupportItem()
	
	if S:OpenCourier() then
		return
	elseif S:PutWardObserver() then
		return
	elseif S:PutWardSentry() then
		return
	elseif S:UseSmoke() then
		return
	elseif S:UseDust() then
		return
	end
	
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
-- use Courier and FlyingCourier
function S:OpenCourier()
	local npcBot = GetBot();
	
	itemCourier =  "item_courier";
	itemFlyingCourier = "item_flying_courier";
	for i=0, 5 do
		if(npcBot:GetItemInSlot(i) ~= nil) then
			local _item = npcBot:GetItemInSlot(i):GetName()
			if(_item == itemCourier) then
				itemCourier = npcBot:GetItemInSlot(i);
			end
			if(_item == itemFlyingCourier) then
				itemFlyingCourier = npcBot:GetItemInSlot(i);
			end
		end
	end
	if(itemCourier ~= "item_courier") then
		print(GetBot():GetUnitName() .. "..open courier")
		npcBot:ActionQueue_UseAbility(itemCourier);
		return true;
	end
	
	return false;
end
-------------------------------------------------------------------------------------
-- use WardObserver
function S:PutWardObserver()
	return false;
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- use WardSentry
function S:PutWardSentry()
	return false;
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
function S:UseDust()
	-- local npcBot = GetBot();
	-- local PValue = 0;
	-- local Invisible = {};
		
	-- local enemyheroes = GetUnitList(UNIT_LIST_ENEMY_HEROES);
	
	-- if enemyheroes[1] ~= nil then
		-- for k,v in pairs(enemyheroes) do
			-- if	v:HasInvisibility(true) then
				-- table.insert(Invisible,v);
			-- end
		-- end
	-- end
	-- if Invisible[1] ~= nil then
		-- for k,v in ipairs(Invisible) do
			-- PValue = GetUnitPotentialValue(v,npcBot:GetLocation(),900);
			-- if PValue > 160 and v:IsInvisible() then
			
			-- end
		-- end
	-- end
	

	return false;
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
function S:UseSmoke()
	return false;
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ----
return S;