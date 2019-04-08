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

local home = {}
for i = 1,sg.max_player do
	home[i] = ac.point(7044, -8792) - {i * 360/sg.max_player,100}
end

ac.game:event('地图-选择英雄', function(_, hero, player)
	local id = player:id()
	local home = home[id]
	local u = player:createUnit('快捷回城', home, 0)
	table.insert(sg.family[player],u)
    u = player:createUnit('快捷练功', home, 0) 
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