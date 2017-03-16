local ability_factory = require(GetScriptDirectory().."/factory/ability_factory")
local item_factory = require(GetScriptDirectory().."/factory/item_factory")

X = {};

function X:New()
	o = {};
	setmetatable(o,{__index = self});
	return o;
end

function X:Main()
	if self.script == nil then
		self:GetPakage();
	end
	self:Unpack();
	return self:Assemble();
end


function X:GetPakage()
	if self.heroname == nil then
		self.heroname = {};
	end
	if self.script == nil then
		self.script = {};
	end
	self.generic_script =  require(GetScriptDirectory().."/consider/ability_item_consider_generic");
	for	k,v in ipairs(self.heroname) do 
		local scriptname = string.gsub(v,"npc_dota_hero_","ability_item_consider_");
		local filename = GetScriptDirectory().."/consider/"..scriptname;
		local script = require(filename);
		setmetatable(script,{__index = self.generic_script});
		self.script[v] = script;
	end
end

function X:Assemble()
	local abilitys = ability_factory:CreatTable();
	local items = item_factory:CreatTable();
	for ability_name,ability in pairs(abilitys) do 
		for k,v in pairs(self.ability) do 
			if ability:GetName() == "antimage_blink" then
				if string.find(k,"AM") ~= nil then
					ability.consider = self.ability;
				end
			else
				if string.find(k,string.gsub(ability_name,"ability","")) ~= nil then
					ability.consider = v;
				end
			end
		end
	end
	for item_name,item in pairs(items) do 
		for k,v in pairs(GetBot().items) do 
			if string.find(k,string.gsub(item_name,"item","")) ~= nil then
				item.consider = v;
			end
		end
	end
	return abilitys,items;
end

function X:Unpack()
	if self.ability == nil then
		self.ability = {};
	end
	if GetBot().items == nil then
		GetBot().items = {};
	end
	
	for k,v in pairs(self.script) do 
		for name,fuc in pairs(v) do 
			if string.find(name,"ability") ~= nil then
				self.ability[name] = fuc;
			end
			if string.find(name,"item") ~= nil then
				GetBot().items[name] = fuc;
			end
		end
	end
end

return X
