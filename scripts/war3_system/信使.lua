ac.game:event('地图-选择英雄', function(_, hero, player)
    local u =  player:createUnit('信使', hero:getPoint(), 0)
    u:bagSize(6)
end)

local mt = ac.skill['物品传送']

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
		local u = hero:createUnit('切换背包',ac.point(0,0),0)
		u:bagSize(6)
		bag[i] = u
	end
	self.max_page = page
	now_page[hero] = 1
	self.bag = bag
end

function mt:onCastShot()
	local hero = self:getOwner()
	local max_page = self.max_page
	local bag = self.bag
	for item in hero:eachItem() do
		local slot = item:getSlot()
		item:give(bag[now_page[hero]],slot)
	end
	if now_page[hero] < max_page then
		now_page[hero] = now_page[hero] + 1
	else
		now_page[hero] = 1
	end
	for item in bag[now_page[hero]]:eachItem() do
		local slot = item:getSlot()
		item:give(hero,slot)
	end
end