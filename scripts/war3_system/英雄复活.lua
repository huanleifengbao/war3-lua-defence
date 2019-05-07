local reborn_timer = {}

function sg.reborn(player,reborn_time,reborn_p)
	local unit = player:getHero()
	if not unit then
		return
	end
	if reborn_timer[player] then
		reborn_timer[player]:remove()
	end
	if not reborn_time then
		reborn_time = 5 + sg.get_wave() * 0.5 - unit:get('复活减免')
	end
	local function reborn()
		if not reborn_p then
		    reborn_p = ac.point(7044, -10529)
	    end
	    unit:reborn(reborn_p, true)
	    unit:set('魔法', unit:get('魔法上限'))
	    player:moveCamera(reborn_p, 0.2)
	end
	if reborn_time == 0 then
		reborn()
	else
		reborn_timer[player] = ac.wait(reborn_time, reborn)
		local msg = '玩家'..player:id()..'复活时间'
		player:timerDialog(msg, reborn_timer[player])
	end	
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