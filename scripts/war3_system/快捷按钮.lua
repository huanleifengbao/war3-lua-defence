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
	player:createUnit('快捷回城', ac.point(11000,-11000), 0)
    player:createUnit('快捷练功', ac.point(11000,-11000), 0) 
    player:event('玩家-选中单位', function (trg, player, unit)
        local name = unit:getName()
		if name == '快捷回城' then
			chose_hero(player)
			if sg.game_mod ~= '副本' then
				if hero:isAlive() and not hero:hasRestriction '硬直' then
					hero:blink(home)
					hero:stop()
					player:moveCamera(home, 0.2)
				end
			else
				player:message('|cffffff00副本中不可传送|r', 10)
			end
        elseif name == '快捷练功' then
			chose_hero(player)
			if sg.game_mod ~= '副本' then
				if hero:isAlive() then
					hero:createItem('练功房')
				end
			else
				player:message('|cffffff00副本中不可传送|r', 10)
			end
        end
    end)
end)