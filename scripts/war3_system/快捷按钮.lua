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

for i = 1, 6 do
    ac.player(i):event('玩家-选中单位', function (trg, player, unit)
        local name = unit:getName()
        local hero = player:getHero()
        if name == '快捷回城' then
	        chose_hero(player)
	        print(hero:hasRestriction '硬直')
    		if hero:isAlive() and not hero:hasRestriction '硬直' then
		        hero:blink(home)
    			player:moveCamera(home, 0.2)
	        end
        elseif name == '快捷练功' then
	        chose_hero(player)	        
	        if hero:isAlive() then
		        hero:createItem('练功房')
	        end
        end
    end)
end