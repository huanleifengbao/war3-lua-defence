local function skill_on(hero,name)
	local skill = hero:findSkill(name)
	if skill and not skill:isEnable() then
		skill:enable()
	end
end

local function get_name(player)
	return sg.player_colour[player:id()] .. player:originName() .. '|r'
end

--逻辑都写这
local list = {
	['飞雷'] = function(item,player)
		local hero = player:getHero()
		local name = item:getName()
		skill_on(hero,name)
	end,
	['的卢'] = function(item,player)
		local hero = player:getHero()
		local name = item:getName()
		skill_on(hero,name)
	end,
	['赤兔'] = function(item,player)
		local hero = player:getHero()
		local name = item:getName()
		skill_on(hero,name)
	end,
	['道具-横扫千军'] = function(item,player)
		local hero = player:getHero()
		local name = item.sow
		sg.get_sow(hero,name)
	end,
	['道具-铜墙铁壁'] = function(item,player)
		local hero = player:getHero()
		local name = item.sow
		sg.get_sow(hero,name)
	end,
	['道具-妙手回春'] = function(item,player)
		local hero = player:getHero()
		local name = item.sow
		sg.get_sow(hero,name)
	end,
	['神行'] = function(item,player)
		local hero = player:getHero()
		player:name('|cffff00ff[|r|cffff00aa神|r|cffff0055行|r|cffff0000]|r'.. get_name(player))
		hero:addBuff '神行' {
			move_speed = item.move_speed,
		}
	end,
	['不屈'] = function(item,player)
		local hero = player:getHero()
		player:name('|cff00ccff[|r|cff11aaff不|r|cff2288ff屈|r|cff3366ff]|r'.. get_name(player))
		hero:addBuff '不屈' {
			reborn_time = item.reborn_time,
		}
	end,
	['屯田'] = function(item,player)
		local hero = player:getHero()
		player:name('|cff00ff00[|r|cff00d500屯|r|cff00ab00田|r|cff008000]|r'.. get_name(player))
		hero:addBuff '屯田' {
			lumber = item.lumber,
		}
	end,
	['天命'] = function(item,player)
		local hero = player:getHero()
		player:name('|cffffffcc[|r|cffffcd88天|r|cffff9b44命|r|cffff6800]|r'.. get_name(player))
		hero:addBuff '天命' {
			odds = item.odds,
		}
	end,
}

local has = {}
for name,_ in pairs(list) do
	has[name] = {}
	local mt = ac.item[name]

	function mt:onCanAdd(u)
		local player = u:getOwner()
		local hero = player:getHero()
		local index = player:get_shop_info(name)
		if not self.repick and has[name][player] == true then
			return false,'|cffffff00您已经领取过|cffffaa00'.. name ..',|cffffff00无法再次领取|r'
		elseif tonumber(player:get_score(self.scoreKey)) >= self.score then
			has[name][player] = true
			player:message('|cffffff00成功领取|cffffaa00'..name..'|r', 5)
			list[name](self,player)
		else
			return false,'|cffffff00您的积分不足，无法领取|cffffaa00'..name..'|r'
		end
	end
end

local mt = ac.buff['神行']

mt.coverGlobal = 1
mt.keep = 1

function mt:onAdd()
	local hero = self:getOwner()
	hero:add('移动速度',self.move_speed)
end

function mt:onCover()
	return false
end

function mt:onRemove()
	local hero = self:getOwner()
	hero:add('移动速度',-self.move_speed)
end

local mt = ac.buff['不屈']

mt.coverGlobal = 1
mt.keep = 1

function mt:onAdd()
	local hero = self:getOwner()
	hero:add('复活减免',self.reborn_time)
end

function mt:onCover()
	return false
end

function mt:onRemove()
	local hero = self:getOwner()
	hero:add('复活减免',-self.reborn_time)
end

local mt = ac.buff['屯田']

mt.coverGlobal = 1
mt.keep = 1
mt.pulse = 1

function mt:onAdd()
	local hero = self:getOwner()
	hero:add('击杀木材',self.lumber)
end

function mt:onCover()
	return false
end

function mt:onRemove()
	local hero = self:getOwner()
	hero:add('击杀木材',-self.lumber)
end

--function mt:onPulse()
--	local hero = self:getOwner()
--	local player = hero:getOwner()
--	player:add('木材',self.lumber)
--end

local mt = ac.buff['天命']

mt.coverGlobal = 1
mt.keep = 1

function mt:onAdd()
	local hero = self:getOwner()
	hero:add('被动触发率',self.odds)
end

function mt:onCover()
	return false
end

function mt:onRemove()
	local hero = self:getOwner()
	hero:add('被动触发率',-self.odds)
end