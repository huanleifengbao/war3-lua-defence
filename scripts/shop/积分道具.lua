local function skill_on(hero,name)
	local skill = hero:findSkill(name)
	if skill and not skill:isEnable() then
		skill:enable()
	end
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
}

local has = {}
for name,_ in pairs(list) do
	has[name] = {}
	local mt = ac.item[name]

	function mt:onCanAdd(u)
		local player = u:getOwner()
		local hero = player:getHero()
		local index = player:get_shop_info(name)
		if has[name][player] == true then
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