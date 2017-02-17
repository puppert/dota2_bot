local myutil = require(GetScriptDirectory() .. "/myutil")
require( GetScriptDirectory().."/ability_item_usage_generic" );


function BuybackUsageThink()
	GetBot().tablefunction = getfenv();
end

-- function ConsiderDeathCoil()
	-- local npcBot = GetBot();
	-- local abilityDeathCoil = npcBot.ability["abilityDeathCoil"];
	
	-- local aTargetDamage = abilityDeathCoil:GetSpecialValueFloat("target_damage");
	-- local aHealAmount = abilityDeathCoil:GetSpecialValueInt("heal_amount");
	-- local aSelfDamage = abilityDeathCoil:GetSpecialValueFloat("self_damage");
	
	-- local TableFriendlyHeroes = npcBot:GetNearbyHeroes(1300,false,BOT_MODE_NONE);
	-- local TableEnemyHeroes = npcBot:GetNearbyHeroes(1300,true,BOT_MODE_NONE);
	
	-- if npcBot:GetActiveMode() == BOT_MODE_LANING then
		-- if npcBot:GetMana() >= (npcBot:GetMaxMana()*0.6) and
		-- npcBot:GetHealth() >= (npcBot:GetMaxHealth() *0.5) then
			-- if TableFriendlyHeroes[1] ~= nil then
				-- for k,v in ipairs(TableFriendlyHeroes) do
					-- if v:GetPlayerID() ~= npcBot:GetPlayerID() then
						-- if v:GetHealth() <= v:GetMaxHealth()*0.5 then
							-- return BOT_ACTION_DESIRE_MODERATE,v;
						-- end
					-- end
				-- end
			-- end
			-- local nTarget = myutil:ChoseEnemyTarget();
			-- if	nTarget ~= nil then
				-- return BOT_ACTION_DESIRE_MODERATE,TableEnemyHeroes[1];
			-- end
		-- end
	-- end
	
	-- if npcBot:GetActiveMode() == BOT_MODE_RETREAT then
		-- if npcBot:GetHealth()-100 >= npcBot:GetActualIncomingDamage(aSelfDamage) then
			-- if TableFriendlyHeroes[1] ~= nil then
				-- table.sort(TableFriendlyHeroes,function(a,b) 
													-- return a:GetHealth() < b:GetHealth() 
												-- end)
				-- return	BOT_ACTION_DESIRE_MODERATE,TableFriendlyHeroes[1];
			-- end
			-- if TableEnemyHeroes[1] ~= nil then
				-- table.sort(TableFriendlyHeroes,function(a,b) 
													-- return a:GetHealth() < b:GetHealth() 
												-- end)
				-- if TableEnemyHeroes[1]:GetActualIncomingDamage(aTargetDamage) <= TableEnemyHeroes[1]:GetHealth() then
					-- return BOT_ACTION_DESIRE_HIGH,TableEnemyHeroes[1];
				-- end
			-- end
		-- end
	-- end
	
	-- if npcBot:GetActiveMode() ~= BOT_MODE_LANING and npcBot:GetActiveMode() == BOT_MODE_RETREAT then
		-- if npcBot:HasModifier("modifier_abaddon_borrowed_time") or (npcBot:GetHealth() >= aSelfDamage + 100) then
			-- if TableFriendlyHeroes[1] ~= nil then
				-- local nTarget = myutil:ChoseFriendlyTarget();
				-- if nTarget:GetHealth() <= nTarget:GetMaxHealth()*0.65 then
					-- return BOT_ACTION_DESIRE_MODERATE,nTarget;
				-- end
			-- end
			-- if TableEnemyHeroes[1] ~= nil then
				-- local nTarget = myutil:ChoseEnemyTarget();
				-- return BOT_ACTION_DESIRE_LOW,nTarget;
			-- end
		-- end 
	-- end
	-- return BOT_ACTION_DESIRE_NONE,0
-- end


-- function ConsiderAphoticShield()
	-- local npcBot = GetBot();
	-- local abilityAphoticShield = npcBot.ability["abilityAphoticShield"]; 
	
	-- local TableFriendlyHeroes = npcBot:GetNearbyHeroes(1300,false,BOT_MODE_NONE);
	
	-- if npcBot:GetActiveMode() == BOT_MODE_LANING then
		-- if npcBot:GetMana() >= npcBot:GetMaxMana()*0.6 then
			-- if TableFriendlyHeroes[1] ~= nil then
				-- for k,v in ipairs(TableFriendlyHeroes) do
					-- if v:HasModifier("modifier_abaddon_aphotic_shield") then
						-- return BOT_ACTION_DESIRE_NONE,0;
					-- end
					-- if v:WasRecentlyDamagedByTower(0.2) then
						-- return BOT_ACTION_DESIRE_MODERATE,v;
					-- end
					-- if v:WasRecentlyDamagedByAnyHero(0.2) then
						-- return BOT_ACTION_DESIRE_MODERATE,v;
					-- end
					-- if v:GetHealth() <= v:GetMaxHealth()*0.3 
					-- and v:GetNearbyHeroes(600,true,BOT_MODE_NONE)[1] ~= nil then
						-- return BOT_ACTION_DESIRE_MODERATE,v;
					-- end
				-- end
			-- end
		-- end
	-- end
	
	-- if	npcBot:GetActiveMode() ~= BOT_MODE_LANING then
		-- if TableFriendlyHeroes[1] ~= nil then
			-- for k,v in ipairs(TableFriendlyHeroes) do
				-- if v:HasModifier("modifier_abaddon_aphotic_shield") then
					-- return BOT_ACTION_DESIRE_NONE,0;
				-- end
				-- if v:WasRecentlyDamagedByTower(0.2) then
					-- return BOT_ACTION_DESIRE_MODERATE,v;
				-- end
				-- if v:WasRecentlyDamagedByAnyHero(0.2) then
					-- return BOT_ACTION_DESIRE_MODERATE,v;
				-- end
				-- if v:GetHealth() <= v:GetMaxHealth()*0.3 
				-- and v:npcBot:GetNearbyHeroes(600,true,BOT_MODE_NONE)[1] ~= nil then
					-- return BOT_ACTION_DESIRE_MODERATE,v;
				-- end
			-- end
		-- end
	-- end
	
	-- return BOT_ACTION_DESIRE_MODERATE,0
-- end

