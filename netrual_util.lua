local W = {};
--local flag = false;
-- [VScript] basic_0
-- [VScript] Vector 0000000000272288 [-371.000000 -3374.000000 265.000000]
-- [VScript] basic_1
-- [VScript] Vector 0000000000227518 [-1806.244507 -4485.535156 256.000000]
-- [VScript] basic_2
-- [VScript] Vector 0000000000232B38 [384.000000 -4672.000000 519.999939]
-- [VScript] basic_3
-- [VScript] Vector 0000000000254E50 [3904.000000 -576.000000 295.644104]
-- [VScript] basic_4
-- [VScript] Vector 00000000002A7878 [-4873.000000 -512.500000 263.999756]
-- [VScript] basic_5
-- [VScript] Vector 000000000024C588 [4804.000000 -4472.000000 264.000000]
-- [VScript] basic_6
-- [VScript] Vector 00000000002AA1D0 [2849.953857 -4557.562012 263.999878]
-- [VScript] ancient_0
-- [VScript] Vector 00000000002823B8 [-948.000000 2268.500000 391.999756]
-- [VScript] ancient_1
-- [VScript] Vector 000000000029CE40 [2500.799561 92.937256 391.999878]
-- [VScript] basic_enemy_0
-- [VScript] Vector 00000000002575F8 [-108.500000 3339.500000 393.000000]
-- [VScript] basic_enemy_1
-- [VScript] Vector 000000000022CF68 [-2816.000000 4736.000000 393.000000]
-- [VScript] basic_enemy_2
-- [VScript] Vector 000000000023FDF8 [-1952.000000 4128.000000 280.000000]
-- [VScript] basic_enemy_3
-- [VScript] Vector 0000000000243B30 [-4448.000000 3456.000000 470.714874]
-- [VScript] basic_enemy_4
-- [VScript] Vector 00000000002776C0 [4452.000000 840.000000 391.999878]
-- [VScript] basic_enemy_5
-- [VScript] Vector 00000000002A4F30 [1346.833252 3289.285156 391.999878]
-- [VScript] basic_enemy_6
-- [VScript] Vector 0000000000276B50 [-3685.870605 871.857666 263.999939]
-- [VScript] ancient_enemy_0
-- [VScript] Vector 0000000000230B98 [-3077.500000 -199.000000 393.000000]
-- [VScript] ancient_enemy_1
-- [VScript] Vector 00000000002A0808 [69.066162 -1851.600098 392.000000]
-- Radian 
-- [VScript] Vector 0000000000286668 [3413.184082 -4670.160156 256.000000]

function W:initialize()
	print("initialize");
		--table.sort(TableNetralSpawners,CompareDis);
		--print(#TableNetralSpawners);
		if self.TableNetral == nil then
			self.TableNetral = GetNeutralSpawners();
		end
		
		for k,v in ipairs(self.TableNetral) do
			self.TableNetral[k].status = false
		end
end
	
function W:GetNeutral()
	if self.TableNetral == nil or self.TableNetral[1] == nil then
		self:initialize();
	end
	return self.TableNetral;
end	

function W:RefreshNeutralStatus()
	local min = math.floor(DotaTime() / 60)
	local sec = DotaTime() % 60
	local npcBot = GetBot();
	if self.TableNetral == nil then
		return
	end
	
	table.sort(self.TableNetral,function(a,b)
								return GetUnitToLocationDistance(npcBot,a.location) < GetUnitToLocationDistance(npcBot,b.location)
								end)
	
	if GetUnitToLocationDistance(npcBot, self.TableNetral[1].location) <= 650 and IsLocationVisible( self.TableNetral[1].location) then
		if npcBot:GetNearbyNeutralCreeps(900)[1] == nil then
			self.TableNetral[1].status = false;
		end
	end
	
	if (min == 0 and sec >= 30 and sec <= 31) or (min%2 == 1 and sec >= 0 and sec <= 2) then
		for k,v in ipairs(self.TableNetral) do
			self.TableNetral[k].status = true;
		end
	end
end

return W;