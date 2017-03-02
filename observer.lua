local Observer = {};
--[==[
	提供了其他友方机器人对当前脚本机器人行为的相应。
	用new方法生成子类以后，请重写
	function Observer:setDelegate(MemberList)	返回Delegate的table
	function Observer:setNotifyMes()	用于设置通知信息储存在当前脚本运行者的handle内（GetBot.nMes）
	function Observer:condition()		设置通知条件，返回boolean
]==]--

function Observer:new(o)
	o = o or {};
	setmetatable(o,self);
	self._index = self;
	return o;
end


function Observer:main()
	local npcBot = GetBot();
	
	self:initialize();
	self:setNotifyMes();
	
	local MemberList = GetUnitList(UNIT_LIST_ALLIED_HEROES);
	for k,v in ipairs(MemberList) do 
		if v:GetUnitName() == npcBot:GetUnitName() or not v:IsBot() then
			table.remove(MemberList,k)
		end
	end
	npcBot.update = self:setDelegate(MemberList);
	
	if self:condition() then
		npcBot.notify();
	end
end

function Observer:initialize()
	local npcBot = GetBot();
	if npcBot.notify == nil then
		npcBot.notify = function()
			if npcBot.update ~= nil then				
				for k,v in pairs(npcBot.update) do 
					v();
				end
			end
		end
	end
end

function Observer:setDelegate(MemberList)
	--OverWrite
	return {};
end

function Observer:setNotifyMes()
	--OverWrite
	GetBot().nMes = "";
end

function Observer:condition()
	--OverWrite
	return false;
end

return Observer