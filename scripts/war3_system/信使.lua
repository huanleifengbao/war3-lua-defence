ac.game:event('地图-选择英雄', function(_, hero, player)
    local u =  player:createUnit('信使', hero:getPoint(), 0)
    u:addRestriction '幽灵'
	u:addSkill('@命令', '技能', 12)
    u:bagSize(6)
    table.insert(sg.family[player],u)
end)

local mt = ac.skill['物品传送']

function mt:onCastShot()
	local u = self:getOwner()
	local item = self:getTarget()
	local player = u:getOwner()
	local hero = player:getHero()
	if hero:isBagFull() then
		player:message('|cffff0000背包已满!|r', 2)
	else
		local tbl = sg.get_free_slot(hero)
		if #tbl > 0 then
			item:give(hero,tbl[1])
		end
	end
end

local mt = ac.skill['全图闪烁']

function mt:onCastShot()
    local hero = self:getOwner()
    local point = hero:getPoint()
    local target = self:getTarget()
    hero:blink(target)
    ac.effect {
		target = point,
		model = [[Abilities\Spells\NightElf\Blink\BlinkCaster.mdl]],
		time = 1,
	}
    ac.effect {
		target = target,
		model = [[Abilities\Spells\NightElf\Blink\BlinkTarget.mdl]],
		time = 1,
	}
end

local mt = ac.skill['快速拾取']

function mt:onCastShot()
	local hero = self:getOwner()
    local point = hero:getPoint()
    local tbl = sg.get_free_slot(hero)
    if #tbl > 0 then
		for _,item in ac.selector()
		    : mode '物品'
		    : inRange(point, self.area)
		    : ipairs()
		do
			local len = #tbl
			item:give(hero,tbl[len])
			table.remove(tbl,len)
			if #tbl == 0 then
				break
			end
		end
	end
end

local mt = ac.skill['切换背包']

local now_page = {}

function mt:onAdd()
	local page = self.page
	if page <= 1 then
		page = 2
	end
	local hero = self:getOwner()
	local bag = {}
	for i = 1,page do
		bag[i] = {}
	end
	self.max_page = page
	now_page[hero] = 1
	self.bag = bag
	hero:getOwner():getHero().getBagItem = function(self)
		local tbl = {}
		for item in hero:eachItem() do
			table.insert(tbl,item)
		end
		for _,box in pairs(bag) do
			for _,item in pairs(box) do
				table.insert(tbl,item)
			end
		end
		return tbl
	end
end

function mt:onCastShot()
	local hero = self:getOwner()
	local max_page = self.max_page
	local bag = self.bag
	local now_bag = now_page[hero]
	for item in hero:eachItem() do
		local slot = item:getSlot()
		bag[now_bag][slot] = item
		item:blink(ac.point(0,0))
		item:hide()
	end
	if now_bag < max_page then
		now_page[hero] = now_bag + 1
	else
		now_page[hero] = 1
	end
	now_bag = now_page[hero]
	for slot,item in pairs(bag[now_bag]) do
		if item then
			item:give(hero,slot)
			item:show()
			bag[now_bag][slot] = nil
		end
	end
	hero:getOwner():message('当前背包：' .. now_page[hero] .. '/' .. max_page,3)
end

--镜头
local height = {}

local function setCamera(player,flag)
	if not height[player] then
		height[player] = 0
	end
	if flag == '降低' then
		height[player] = math.max(height[player] - 300,0)
	else
		height[player] = math.min(height[player] + 300,600)
	end
	player:setCamera('距离',height[player] + 1650,0.2)
end


ac.game:event('玩家-聊天', function (_, player, str)
	if not height[player] then
		height[player] = 0
	end
	if str == '++' then
		setCamera(player)
	elseif str == '--' then
		setCamera(player,'降低')
	end
end)

local mt = ac.skill['拉伸镜头']

function mt:onCastShot()
	local hero = self:getOwner()
	local player = hero:getOwner()
	setCamera(player)
end

local mt = ac.skill['降低镜头']

function mt:onCastShot()
	local hero = self:getOwner()
	local player = hero:getOwner()
	setCamera(player,'降低')
end