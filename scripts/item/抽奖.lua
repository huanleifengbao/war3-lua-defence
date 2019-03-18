--创建权重表
local prize = {}
local has_skill = {}
for name,skill in pairs(ac.skill) do
	if skill.lottery then
		has_skill[name] = {}
		for i = 1,math.ceil(skill.lottery[1] * 10) do
			table.insert(prize,name)
		end
	end
end

--获取战魂
local function get_skill(hero,name)
	local index = has_skill[name]
	if sg.isintable(index,hero) then
		hero:getOwner():message('你已经拥有' .. name .. '了，无法再次拥有', 5)
		return false
	else
		hero:addSkill(name,'技能',3)
		table.insert(index,hero)
		return true
	end
end

--抽中战魂
function sg.get_sow(hero,name)
	if get_skill(hero,name) == false then
		local slot = sg.get_free_slot(hero)
		if #slot > 0 then
			hero:createItem(name,slot[1])
		else
			hero:getPoint():createItem(name)
		end
	end	
end

--抽奖
local function draw(hero)
	local player = hero:getOwner()
	if sg.get_random(#prize/10) then
		local name = prize[math.random(#prize)]	
		player:message('你抽到了' .. name, 5)
		sg.get_sow(hero,name)
	else
		player:message('你抽到了空气', 5)
	end
end

local tbl = {'抽奖','十连抽奖'}
for _,name in pairs(tbl) do
	local mt = ac.item[name]

	function mt:onCanAdd(hero)
		for i = 1,self.count do
	    	draw(hero)
    	end
	end
end

--抽奖券
local mt = ac.item['使用抽奖券']

function mt:onCanAdd(hero)
	local player = hero:getOwner()
	if player:get_shop_info '抽奖券' > 0 then
		player:add_shop_info('抽奖券',-1)
		for i = 1,self.count do
	    	draw(hero)
    	end
	else
		player:message('抽奖券不足', 5)
		return false
	end
end

--使用战魂
for name,_ in pairs(has_skill) do
	local mt = ac.skill['获得-' .. name]

	function mt:onCastShot()
		local name = self.SpiritOfWar
		local hero = self:getOwner()
		if get_skill(hero,name) == true then
			for item in hero:eachItem() do
				if name == item:getName() then
					item:remove()
					break
				end
			end
		end
	end
end