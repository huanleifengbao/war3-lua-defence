--创建权重表
local prize = {}
local sow = {}
for name,skill in pairs(ac.skill) do
	if skill.lottery then
		local lottery = skill.lottery[1]
		sow[name] = lottery
		for i = 1,math.ceil(lottery * 10) do
			table.insert(prize,name)
		end
	end
end

--安慰奖列表
local low_prize = {}
local crycryo = 
{
	[1] = {atr = 50888888,lot = 0.1},
	[2] = {atr = 2888888,lot = 0.2},
	[3] = {atr = 588888,lot = 0.4},
	[4] = {atr = 288888,lot = 0.8},
	[5] = {atr = 108888,lot = 2},
	[6] = {atr = 58888,lot = 4},
	[7] = {atr = 28888,lot = 6},
	[8] = {atr = 5888,lot = 8},
	[9] = {atr = 888,lot = 10},
}
for i = 1,#crycryo do
	local data = crycryo[i]
	for _ = 1,math.ceil(data.lot * 10) do
		table.insert(low_prize,i)
	end
end

--获取战魂
local function get_skill(hero,name)
	local skill = hero:findSkill(name)
	if skill then
		if skill:isEnable() then						
			return false
		else
			hero:particle([[Abilities\Spells\Items\AIlm\AIlmTarget.mdl]],'origin')()	
			skill:enable()
			return true
		end
	else
		print(name,'有个战魂初始没加到魔法书里')
		return false
	end

	--[[local index = has_skill[name]
	if sg.isintable(index,hero) then
		return false,'你已经拥有' .. name .. '了，无法再次拥有'
	else
		local icon_int = ac.table.skill[name].icon_int
		if not icon_int then
			icon_int = 12
			print(name,'这个战魂没填格子位置')
		end
		local tbl = hero:userData('战魂技能')
		local skill = hero:addSkill(name,'技能', icon_int)
		skill:hide()
		tbl[skill] = skill
		table.insert(index,hero)
		return true
	end]]
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



local function draw(hero,boolean)
	local player = hero:getOwner()
	if boolean == true or sg.get_random(#prize/10) then
		local name = prize[math.random(#prize)]
		if boolean ~= true then
			sg.message('|cffffff00时|r|cfffbff17来|r|cfff6ff2e运|r|cfff2ff45转|r|cffedff5c！|r|cffe8ff73恭|r|cffe4ff8b喜|r|cffdfffa2玩|r|cffdaffb9家|cffff6800' .. player:name() .. '|r|r|cffd6ffd0抽|r|cffd1ffe7到|r|cffccffff了|r|cffff6800' .. name .. '|r|cffccffff！|r', 5)
		else
			player:message('|cffffff00合|r|cffffe000成|r|cffffc000成|r|cffffa000功|r|cffff8000！|r|cffff6000你|r|cffff4000获|r|cffff2000得|r|cffff0000了|r|cffffff00' .. name .. '|r',5)
		end
		sg.get_sow(hero,name)
		if sow[name] <= 0.1 then
			hero:particle([[Abilities\Spells\Human\Resurrect\ResurrectCaster.mdl]],'origin')()	
		end
		if sow[name] <= 0.2 then
			hero:particle([[effect\TheHolyBomb.mdx]],'origin')()
		end
		if sow[name] <= 0.3 then
			hero:particle([[Abilities\Spells\Human\HolyBolt\HolyBoltSpecialArt.mdl]],'origin')()
		end
		hero:particle([[Abilities\Spells\Demon\DarkPortal\DarkPortalTarget.mdl]],'origin')()
	else
		--战魂莫得了，试试安慰奖
		hero = player:getHero()
		if sg.get_random(#low_prize/10) then
			local index = low_prize[math.random(#low_prize)]
			local atr = crycryo[index].atr
			sg.add_allatr(hero,atr)
			local text = '|cffccffff谢|r|cffcffcf9谢|r|cffd2f9f3惠|r|cffd5f6ec顾|r|cffd8f3e6！|r|cffdbf0e0你|r|cffdfecd9获|r|cffe2e9d3得|r|cffe5e6cc了|r|cffffff00' .. atr .. '|r|cfff2d9b3点|r|cfff5d6ad全|r|cfff8d3a6属|r|cfffbd0a0性|r|cffffcc99！|r'
			if index <= 2 then
				text = '|cffffcc99中|r|cffffbb8d大|r|cffffaa80奖|r|cffff9973了|r|cffff8866！|r|cffff775a你|r|cffff664d获|r|cffff5540得|r|cffff4433了|r|cffffff00' .. atr .. '|r|cffff3327全|r|cffff221a属|r|cffff110d性|r|cffff0000！|r'
			elseif index <= 5 then
				text = '|cffffff00恭|r|cfffff000喜|r|cffffe100！|r|cffffd200你|r|cffffc200获|r|cffffb300得|r|cffffa400了|cffffffcc' .. atr .. '|r|r|cffff9400全|r|cffff8500属|r|cffff7600性|r|cffff6600！|r'
			end
			player:message(text, 5)
		else
			sg.add_allatr(hero,88)
			player:message('|cffccffff谢|r|cffcffcf9谢|r|cffd2f9f3惠|r|cffd5f6ec顾|r|cffd8f3e6！|r|cffdbf0e0你|r|cffdfecd9获|r|cffe2e9d3得|r|cffe5e6cc了|r|cffffff0088|r|cfff2d9b3点|r|cfff5d6ad全|r|cfff8d3a6属|r|cfffbd0a0性|r|cffffcc99！|r', 5)
		end
	end
end

local tbl = {'抽奖','十连抽奖'}
for _,name in ipairs(tbl) do
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
		return false,'|cffff0000抽奖券不足|r'
	end
end

--使用战魂
for name,_ in pairs(sow) do
	local mt = ac.skill['获得-' .. name]

	function mt:onCastShot()
		local name = self.SpiritOfWar
		local unit = self:getOwner()
		local player = unit:getOwner()
		local hero = player:getHero()
		if get_skill(hero,name) == true then
			for item in unit:eachItem() do
				if name == item:getName() then
					item:remove()
					break
				end
			end
		else
			player:message('你已经拥有' .. name .. '了，无法使用',5)
		end
	end
end

--合成战魂
local mt = ac.skill['翻倍机会！']

function mt:onCastShot()
	local hero = self:getOwner()
	local player = hero:getOwner()
	local tbl = {}
	local count = self.count
	for item in hero:eachItem() do
		if sow[item:getName()] then
			table.insert(tbl,item)
			if #tbl >= count then
				break
			end
		end
	end
	if #tbl >= count then
		for _,item in ipairs(tbl) do
			item:remove()
		end
		draw(hero,true)
	else
		player:message('|cffff0000背包中的|r|cffffff00战魂|r|cffff0000不足|r|cffffff00' .. count .. '|r|cffff0000个，不能合成|r')
	end
end