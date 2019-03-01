local base = ac.player(10):createUnit('基地',ac.point(7040,-9344),270)
sg.base = base
base:event('单位-死亡', function (trg, unit)
    trg:remove()
    local p1 = base:getPoint()
    for x = 1, 15 do
        for y = 1, 4 + x do
            local p2 = p1 - {(360 / (4 + x) * y), 50 * x}
            ac.effect {
                target = p2,
                model = [[Objects\Spawnmodels\Other\NeutralBuildingExplosion\NeutralBuildingExplosion.mdl]],
                time = 2,
            }
        end
    end
    for _, u in ac.selector()
        : inRange(base, 800)
        : ipairs()
    do
        base:kill(u)
    end
    for i = 1, 6 do
        ac.player(i):moveCamera(p1, 0)
        ac.player(i):message('|cffffff00家都|cffff0000boom|cffffff00了你不会自己退?|r', 30)
        ac.wait(3.5, function()
            ac.player(i):message('|cffff0000哼!|r', 30)
            ac.wait(2, function()
                ac.player(i):message('|cffffff00免为其难让你|cff00ff00继续玩|cffffff00一会吧|r', 30)
                ac.wait(2.5, function()
                    ac.player(i):message('|cffffff00下次给我好好地守住啊!|cffff0000baka!|r', 30)
                end)
            end)
        end)
    end
end)

local tbl = {'交换金币','交换木材'}
for _,name in pairs(tbl) do
	local mt = ac.item[name]

	function mt:onCanAdd(hero)
		sg.add_gold(hero,self.get,self.count)
    end
end

local mt = ac.item['基地无敌']

function mt:onAdd()
	local time = self.time
	for i = 1,sg.max_player do
    	ac.player(i):message('|cffffff00本阵进入无敌状态，持续' .. time .. '秒|r', 10)
	end
	base:addBuff '无敌'
    {
		time = self.time,
    }
    ac.wait(time,function()
    	for i = 1,sg.max_player do
	    	ac.player(i):message('|cffffff00本阵无敌结束|r', 5)
		end
    end)
end

local mt = ac.item['暂停刷怪']

function mt:onAdd()
	local time = self.time
	if sg.wave_timer then
		sg.wave_timer:pause()
	end
	if sg.enemy_timer then
		sg.enemy_timer:pause()
	end
	if sg.boss_timer then
		sg.boss_timer:pause()
	end
	for i = 1,sg.max_player do
    	ac.player(i):message('|cffffff00暂时停止刷怪，持续' .. time .. '秒|r', 10)
	end
    ac.wait(time,function()
		if sg.wave_timer then
			sg.wave_timer:resume()
		end
		if sg.enemy_timer then
			sg.enemy_timer:resume()
		end
		if sg.boss_timer then
			sg.boss_timer:resume()
		end
    	for i = 1,sg.max_player do
	    	ac.player(i):message('|cffffff00暂停刷怪时间结束|r', 5)
		end
    end)
end