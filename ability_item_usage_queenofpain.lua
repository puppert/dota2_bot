require( GetScriptDirectory().."/ability_item_usage_generic" )
----------------------------------------------------------------------------------------------------


function BuybackUsageThink()
	GetBot().tablefunction = getfenv();
end

----------------------------------------------------------------------------------
-- function CanCastStrikeOnTarget( npcTarget )
	-- return npcTarget:CanBeSeen()  and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
-- end


-- function CanCastSonicOnTarget( npcTarget )
	-- return npcTarget:CanBeSeen() and npcTarget:IsHero() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
-- end
-- ----------------------------------------------------------------------------------------------------
-- function ConsiderShadowStrike()
	-- -- for k,v in pairs(GetBot().ability) do
		-- -- print(k);
	-- -- end
	-- local npcBot = GetBot();
	
	-- local abilityShadowStrike = npcBot.ability["abilityShadowStrike"]
	
	-- local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(800,true,BOT_MODE_NONE);
	-- local npcTarget = tableNearbyEnemyHeroes[1];
	
	-- local nCastRange = abilityShadowStrike:GetCastRange();
	-- if(npcBot:GetActiveMode()== BOT_MODE_LANING)
	-- then
		-- if(npcTarget~=nil) then
			-- if(CanCastStrikeOnTarget(npcTarget) 
			-- and	npcBot:GetHealth() >= (npcBot:GetMaxHealth()*0.6)
			-- and npcBot:GetMana() >= (npcBot:GetMaxMana()*0.8))
			-- then 	
				-- return 0.6, npcTarget;
			-- end
			
			-- if(CanCastStrikeOnTarget(npcTarget)
			-- and npcTarget:GetHealth() <= 170
			-- and npcBot:GetMana() >= 210
			-- )
			-- then
				-- return 0.7, npcTarget;
			-- end
		-- end
	-- end
	
	-- if(npcBot:GetActiveMode() ~= BOT_MODE_FARM
	-- and npcBot:GetActiveMode() ~=BOT_MODE_LANING)
	-- then 
		-- if(npcTarget ~= nil) then
			-- if(CanCastStrikeOnTarget(npcTarget)
			-- and (GetUnitToUnitDistance(npcBot,npcTarget) <= 600))
			-- then
				-- return 0.4,npcTarget;
			-- end
			
		-- end
	-- end
	
	-- return BOT_ACTION_DESIRE_NONE,0;
-- end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ---------------------------------------------
-- function ConsiderScreamOfPain()
	-- local npcBot = GetBot();
	
	-- local abilityScreamOfPain = npcBot.ability["abilityScreamOfPain"]
	-- --print("abilityScream".. abilityScream:GetBehavior());
	-- -- print("ScreamOfPain")
	
	-- local nRadius = abilityScreamOfPain:GetSpecialValueInt("area_of_effect");
	-- local nDamage = abilityScreamOfPain:GetAbilityDamage();
	-- local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1000, true, BOT_MODE_NONE);
	-- local npcTarget = tableNearbyEnemyHeroes[1];
	
	-- if(npcBot:GetActiveMode() ==  BOT_MODE_LANING) then
		-- if(npcTarget ~= nil and GetUnitToUnitDistance( npcBot, npcTarget ) < nRadius-20) then
			-- local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), 0, nRadius-20, 0.0, nDamage );
			-- if ( locationAoE.count >= 1 and npcBot:GetMana() >= (npcBot:GetMaxMana()*0.5)) then
				-- --print("kill creep and hit hero");
				-- return BOT_ACTION_DESIRE_HIGH;
			-- end
		-- end
		-- if(npcBot:GetMana() >= (npcBot:GetMaxMana()*0.6)) then
			-- local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), 0, nRadius-20, 0.0, nDamage );
				-- if(locationAoE.count >= 2) then
					-- --print("kill creeps");
					-- return BOT_ACTION_DESIRE_HIGH;
				-- end
		-- end
	-- end
	
	-- if(npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP
	-- or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID
	-- or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT
	-- or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP
	-- or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID
	-- or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT) then
		-- if(npcBot:GetMana()>=(npcBot:GetMaxMana()*0.4)) then
			-- local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), 0, nRadius, 0.0, 10000 );
			-- if ( locationAoE.count >= 3)then
				-- local tableNearbyEnemy = npcBot:GetNearbyCreeps(600,true);
				-- if(tableNearbyEnemy[1] ~= nil) then
					-- --print("push");
					-- return BOT_ACTION_DESIRE_MODERATE;
				-- end
			-- end
		-- end
	-- end
	
	-- if(npcBot:GetActiveMode() ~= BOT_MODE_FARM
	-- and npcBot:GetActiveMode() ~= BOT_MODE_LANING) then
		-- local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), 0, nRadius, 0.0, 10000 );
		-- if(npcTarget ~= nil and GetUnitToUnitDistance( npcBot, npcTarget ) < nRadius) then
		-- if ( locationAoE.count >= 2) then
			-- --print("hit hero");
			-- return BOT_ACTION_DESIRE_VERYHIGH;
		-- end
		
		-- -- if(npcTarget ~= nil) then
			-- -- for k,v in ipairs(tableNearbyEnemyHeroes) do
				-- -- if(v:GetHealth() < nDamage)
				-- -- then
					-- -- return BOT_ACTION_DESIRE_HIGH;
				-- -- end
			-- -- end
		-- -- end
		
		-- if(npcBot:GetActiveMode() == BOT_MODE_ATTACK
		-- and GetUnitToUnitDistance(npcBot,npcTarget) < nRadius) 
		-- then 
			-- --print("1234");
			-- return BOT_ACTION_DESIRE_VERYHIGH ;
		-- end
		-- end
	-- end
	
	-- return 	BOT_ACTION_DESIRE_NONE;
-- end	
-- ----------------------------------------------------------------------------------------------------
-- function ConsiderBlink()
	-- local npcBot = GetBot();
	
	-- local abilityBlink = npcBot.ability["abilityBlink"]
	-- local abilityScreamOfPain = npcBot.ability["abilityScreamOfPain"]
	
	-- local nRange = abilityBlink:GetSpecialValueFloat("blink_range");
	-- local screamDamage = abilityScreamOfPain:GetAbilityDamage();
	-- local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1300, true, BOT_MODE_NONE);
	-- local tableNearbyFriendlyHeroes = npcBot:GetNearbyHeroes(1300, false, BOT_MODE_NONE);
	-- local npcTarget = tableNearbyEnemyHeroes[1];
	
	-- if(npcBot:GetActiveMode() ==  BOT_MODE_LANING 
	-- or npcBot:GetActiveMode() == BOT_MODE_ATTACK) then
		-- if(npcTarget ~= nil and npcTarget:CanBeSeen()) then
			-- if(npcTarget:GetHealth() <= 200 
			-- and #tableNearbyEnemyHeroes <= 2
			-- and npcBot:GetMana() >= 200
			-- and npcBot:GetHealth() >= 300)
			-- then
				-- --print("blink1");
				-- return 0.7, npcTarget:GetLocation();
			-- end
			
			-- if(npcTarget:GetHealth() <= (npcTarget:GetActualIncomingDamage(npcBot:GetAttackDamage(),DAMAGE_TYPE_PHYSICAL)*2)
			-- and #tableNearbyEnemyHeroes <= 2
			-- and npcBot:GetHealth() >= 300)
			-- then
			-- --	print("blink2");
				-- return 0.7, npcTarget:GetLocation();
			-- end
			
		-- end
	-- end
	
	-- if(npcBot:GetActiveMode() == BOT_MODE_ATTACK) then
		-- if(#tableNearbyEnemyHeroes == 1
		-- and #tableNearbyFriendlyHeroes >= 3) then
			-- --print("blink3");
			-- return 0.7, npcTarget:GetLocation();
		-- end
	-- end
	
	-- if(npcBot:GetActiveMode() ~=BOT_MODE_RETREAT 
	-- and npcBot:GetActiveMode() ~= BOT_MODE_LANING
	-- and npcTarget ~= nil) then
		-- if(abilityBlink:IsFullyCastable() 
		-- and abilityScreamOfPain:IsFullyCastable()
		-- and npcBot:GetMana() >= (abilityScreamOfPain:GetManaCost()+170))
		-- then
			-- local target = nil;
			-- for k,v in ipairs(tableNearbyEnemyHeroes) do
				-- if(v:GetHealth() < (screamDamage+npcBot:GetAttackDamage()))
				-- then
					-- target = v;
					-- break;
				-- end
			-- end
			-- if(target ~= nil) then
				-- local point = target:GetLocation();	
				-- --print("blink4");
				-- return BOT_ACTION_DESIRE_HIGH, point;
			-- end
		-- end
	-- end
	
	-- if(npcBot:GetActiveMode() == BOT_MODE_RETREAT
	-- or npcBot:GetActiveMode() == BOT_MODE_EVASIVE_MANEUVERS)
	-- then
		
		-- if( tableNearbyEnemyHeroes[1] ~= nil)
		-- then
			-- --print("blink5");
			-- return BOT_ACTION_DESIRE_MODERATE, myutil.farthestPoint(tableNearbyEnemyHeroes[1]:GetLocation()
					-- ,npcBot:GetLocation(),1300,GetUnitToUnitDistance(npcBot,npcTarget));
		-- end
	-- end
	
	-- if(myutil.checkifblocked()) then
		-- --print("blink6");
		-- return BOT_ACTION_DESIRE_MODERATE,utils.GetXUnitsInFront(npcBot,1000);
	-- end	
	
	-- return BOT_ACTION_DESIRE_NONE;
-- end

-- --------------------------------------------------------------------------------------------------------
-- function ConsiderSonicWave()
	-- local npcBot = GetBot();
	-- local abilitySonicWave = npcBot.ability["abilitySonicWave"]
	
	
	-- local nDamage = abilitySonicWave:GetAbilityDamage();
	-- local nCastRange = abilitySonicWave:GetCastRange();
	
	-- local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(1200, true, BOT_ACTION_DESIRE_NONE);
	-- local npcTarget = tableNearbyEnemyHeroes[1];
	
	-- if(npcTarget ~= nil and GetUnitToUnitDistance(npcBot,npcTarget) <= (nCastRange+50)) then
		-- local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), nCastRange, 250, 0, 0);
		-- if(locationAoE.count >= 2)
		-- then 
			-- return BOT_ACTION_DESIRE_HIGH,locationAoE.targetloc;
		-- end
		-- if npcTarget:CanBeSeen() then
			-- if(npcTarget:GetHealth() < nDamage)
			-- then
				-- return BOT_ACTION_DESIRE_ABSOLUTE ,npcTarget:GetLocation();
			-- end
		-- end
	-- end
	-- return BOT_ACTION_DESIRE_NONE;
-- end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ---
