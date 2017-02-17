-- local utils = require(GetScriptDirectory() .. "/util")
-- local myutil = require(GetScriptDirectory() .. "/myutil")
----------------------------------------------------------------------------------------------------
local player = nil;
local TableNetralSpawners; 
local TableNetral = {};
local flag = false;

function AbilityUsageThink()
	local npcBot = GetBot();
	if player == nil then
		for k,v in pairs(GetTeamPlayers(GetTeam())) do
		--print(GetTeamMember(GetTeam(),k):GetUnitName());
			if not IsPlayerBot(v) then
				player = GetTeamMember(k);
				print(player:GetUnitName());
			end
		end
	end

	-- if player ~= nil then
		-- print(#player:GetNearbyCreeps(900,true));
		-- if player:GetNearbyCreeps(900,true)[1] ~= nil then
			-- print("has neutral")
		-- end
		-- if player:GetNearbyNeutralCreeps(900)[1] ~= nil then
			-- print("has neutral 2")
		-- end
		-- --npcBot:Action_MoveToUnit(player);
		-- --print(player:GetUnitName());
		-- -- if player:DistanceFromSecretShop() == 0 then
			-- -- print(player:GetLocation());
		-- -- end
		-- -- if npcBot:DistanceFromSideShop() == 0 then
			-- -- --print(npcBot:GetLocation());
		-- -- end
		-- -- if player:DistanceFromSideShop() == 0 then
			-- -- print(player:GetLocation());
		-- -- end
	-- end
	-- if TableNetralSpawners == nil then
		-- local TableNameLocation = {};
		-- TableNetralSpawners = GetNeutralSpawners();
		-- --table.sort(TableNetralSpawners,CompareDis);
		-- --print(#TableNetralSpawners);
		-- for k,v in ipairs(TableNetralSpawners) do
			-- if k%2 == 1 then
				-- table.insert(TableNameLocation,v);
			-- end
			-- if k%2 == 0 then
				-- table.insert(TableNameLocation,v);
				-- table.insert(TableNetral,TableNameLocation);
				-- TableNameLocation = {};
			-- end
		-- end
	-- end
	
	-- if #TableNetral == 18 and not flag then
		-- table.sort(TableNetral,CompareDis);
		-- for k,v in ipairs(TableNetral) do
			-- for i,j in ipairs(v) do
				-- print(j);
				-- if i == 2 then
					-- --print(GetUnitToLocationDistance(player,j));
					-- print(player:GetLocation());
				-- end
			-- end
		-- end
		-- flag = true;
	-- end
	
	--abilitystone = npcBot:GetAbilityByName("earth_spirit_stone_caller");
	
	-- if(abilitystone:IsFullyCastable())then
	-- npcBot:Action_UseAbilityOnLocation(abilitystone,npcBot:GetLocation());
	-- end
	-- if(DotaTime() <5) then
	-- local  a = RandomFloat(0.0,2.0);
	-- local 	b = RandomFloat(0.0,1.0);
	-- print("Clamp..a.."..a.."clampa.."..Clamp(a, 0.0, 1.0 ) );
	-- print("Clamp..b.."..b.."clampb.."..Clamp(b, 0.0, 1.0 ) );
	-- print("RemapVal..a.."..a.."remapa.."..RemapVal( a, 0.0, 2.0, 0.0, 1.0 ));
	-- print("RemapVal..b.."..b.."remapb.."..RemapVal( b, 0.0, 2.0, 0.0, 1.0 ));
	-- print("RemapValClamped..a.."..a.."remapa.."..RemapValClamped( a, 0.0, 2.0, 0.0, 1.0));
	-- print("RemapValClamped..b.."..b.."remapb.."..RemapValClamped( b, 0.0, 2.0, 0.0, 1.0));
	-- end
	
	-- if(npcBot:GetGold() > GetItemCost("item_flying_courier")) then
		-- local msg = npcBot:Action_PurchaseItem("item_ward_observer");
		-- print(msg);
	-- end
	
	-- if(math.fmod(DotaTime(),10) == 0) then
		-- local wardlist = GetUnitList(UNIT_LIST_ALLIED_WARDS);
		-- for k,v in pairs(wardlist) do
			-- print(".."..v:GetLocation());
		-- end
	-- end
	
	-- if(math.fmod(DotaTime(),10)) then
		-- print("item_ward_observer.."..GetItemStockCount("item_ward_observer"));
		-- print("item_gem.."..GetItemStockCount("item_gem"));
		-- print("item_smoke_of_deceit.."..GetItemStockCount("item_smoke_of_deceit"));
	-- end
	
	
end
function CompareDis(a,b)
	-- n
	local tower = GetTower(GetTeam(),TOWER_TOP_1);
	return GetUnitToLocationDistance(player,a[2]) < GetUnitToLocationDistance(player,b[2])
end
----------------------------------------------------------------------------------------------------

