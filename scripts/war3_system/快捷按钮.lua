local function chose_hero(player)
	local hero = player:getHero()
	if hero:isAlive() then
		player:selectUnit(hero)
		hero:stop()
	else
		local p = player._handle
		if jass.GetLocalPlayer() == p then
			jass.ClearSelection()
		end
	end
end

local home = ac.point(7044, -8792)

ac.game:event('地图-选择英雄', function(_, hero, player)
	local u = player:createUnit('快捷回城', ac.point(11000,-11000), 0)
	table.insert(sg.family[player],u)
    u = player:createUnit('快捷练功', ac.point(11000,-11000), 0) 
    table.insert(sg.family[player],u)
    player:event('玩家-选中单位', function (trg, player, unit)
        local name = unit:getName()
		if name == '快捷回城' then
			chose_hero(player)
			hero:tp(home)
        elseif name == '快捷练功' then
			chose_hero(player)
			if hero:isAlive() then
				hero:createItem('练功房')
			end
        end
    end)
end)

--镜头
local height = {}
ac.game:event('玩家-聊天', function (_, player, str)
	if not height[player] then
		height[player] = 0
	end
	local target = player:getHero():getPoint()
	if str == '++' then
		height[player] = math.min(height[player] + 300,900)
		player:moveCamera(target,0.2,height[player])
	elseif str == '--' then
		height[player] = math.max(height[player] - 300,0)
		player:moveCamera(target,0.2,height[player])
	end
end)