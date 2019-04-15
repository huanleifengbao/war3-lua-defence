function sg.reborn(player,reborn_time,reborn_p)
	local unit = player:getHero()
	if not unit then
		return
	end
	if not reborn_time then
		reborn_time = 5
	end
	local timer = ac.wait(reborn_time, function()
	    if not reborn_p then
		    reborn_p = ac.point(7044, -10529)
	    end
	    unit:reborn(reborn_p, true)
	    unit:set('魔法', unit:get('魔法上限'))
	    player:moveCamera(reborn_p, 0.2)
	end)
	local msg = '玩家'..player:id()..'复活时间'
	player:timerDialog(msg, timer)
end

ac.game:event('地图-选择英雄', function (_, unit, player)
	local unit = player:getHero()
    unit:event('单位-死亡', function (_, dead, killer)
    	ac.game:eventNotify('地图-英雄死亡', unit, player, reborn_time)
    	if sg.game_mod ~= '副本' then
	    	sg.reborn(player)
        end
    end)
end)