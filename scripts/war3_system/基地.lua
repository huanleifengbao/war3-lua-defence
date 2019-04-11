local base = sg.ally_player:createUnit('基地',ac.point(7040,-9344),270)
--基地每秒回血
ac.loop(0.5, function()
	base:add('生命',base:get('生命上限') * 0.0025)
end)
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
    --for _, u in ac.selector()
    --    : inRange(base, 800)
    --    : ipairs()
    --do
    --    base:kill(u)
    --end
	for i = 1,sg.max_player do
		local player = ac.player(i)
        player:moveCamera(p1, 0)
        if not sg.ex_mode then
	        player:message('本阵沦陷，5秒后结束游戏......',5)
	        ac.wait(5,function()
				player:remove('失败','失败！')
				ac.game:pause()
		    end)
	      --  player:message('|cffffff00家都|cffff0000boom|cffffff00了你不会自己退?|r', 30)
	      --  ac.wait(3.5, function()       	
		     --   player:message('|cffff0000哼!|r', 30)
		     --   ac.wait(2, function()
		     --       player:message('|cffffff00免为其难让你|cff00ff00继续玩|cffffff00一会吧|r', 30)
		     --       ac.wait(2.5, function()
		     --           player:message('|cffffff00下次给我好好地守住啊!|cffff0000baka!|r', 30)
		     --           ac.wait(3.5, function()
							--player:remove('失败','失败！')
							--ac.game:pause()
		     --           end)
		     --       end)
		     --   end)	            
	      --  end)
        else
	        player:message('您坚守到了无尽第' .. sg.get_wave() .. '波',5)
	        ac.wait(5,function()
	        	player:remove('胜利','胜利！')
				ac.game:pause()
	        end)
        end
    end
end)

--受伤警报
base:event('单位-受到伤害', function()
	local rate = base:get '生命'/base:get '生命上限'
	if rate > 0 and rate <= 0.5 then
		sg.message('本阵有难，请速速前往支援！剩余生命值' .. math.ceil(rate * 100) .. '%',5)
	end
end)
--无敌一次
base:event('单位-即将死亡', function(trg,_)
	sg.message('本阵即将沦陷，自动进入无敌状态（一局一次）',5)
	base:addBuff '无敌'
	{
		time = 30,
	}
	base:set('生命',base:get'生命上限')
	trg:remove()
	return false
end)

local tbl = {'交换金币','交换木材'}
for _,name in ipairs(tbl) do
	local mt = ac.item[name]

	function mt:onCanAdd(hero)
		sg.add_gold(hero,self.get,self.count)
    end
end

local mt = ac.item['基地无敌']

function mt:onAdd()
    local unit = self:getOwner()
    local i_player = unit:getOwner()
	local id = i_player:id()
	local hero = i_player:getHero()

	local time = self.time
	local msg = '基地无敌'

	base:addBuff '无敌'
    {
		time = self.time,
    }
    local timer = ac.wait(time,function()
    	for i = 1,sg.max_player do
	    	ac.player(i):message('|cffffff00本阵无敌|r已结束', 5)
		end
    end)
	for i = 1,sg.max_player do
		local player = ac.player(i)
		player:timerDialog(msg, timer)
		player:message(sg.player_colour[id]..hero:getName()..'|r使用了|cffffff00本阵无敌|r,持续|cffff7500' .. time .. '|r秒', 5)
	end
end

local mt = ac.item['暂停刷怪']

function mt:onAdd()
    local unit = self:getOwner()
    local i_player = unit:getOwner()
	local id = i_player:id()
	local hero = i_player:getHero()

	local time = self.time
	local msg = '暂停刷怪'

	sg.stop_enemy()
    local timer = ac.wait(time,function()
		sg.start_enemy()
    	for i = 1,sg.max_player do
	    	ac.player(i):message('|cffffff00暂停刷怪|r已结束', 5)
		end
    end)
	for i = 1,sg.max_player do
		local player = ac.player(i)
		player:timerDialog(msg, timer)
		player:message(sg.player_colour[id]..hero:getName()..'|r使用了|cffffff00暂停刷怪|r,持续|cffff7500' .. time .. '|r秒', 10)
	end
end

local mt = ac.item['基地升级']
local level = 0

function mt:onCanBuy(hero)
	if level >= self.max_level then
		hero:getOwner():message('|cffffff00已升至最高等级，无法继续提升|r', 3)
		return false
	else
		return true
	end
end

function mt:onAdd()
    local unit = self:getOwner()
    local i_player = unit:getOwner()
	local id = i_player:id()
	local hero = i_player:getHero()

    hero:add('力量', self.attribute['力量'])
    hero:add('敏捷', self.attribute['敏捷'])
    hero:add('智力', self.attribute['智力'])
	
	level = level + 1
	base:add('生命上限',self.hp)
	base:add('护甲',self.amr)
	base:add('减伤',self.def)
	for i = 1,sg.max_player do
    	ac.player(i):message(sg.player_colour[id]..hero:getName()..'|r强化了本阵的耐久度|cffffff00(' .. level .. '/' .. self.max_level .. ')|r', 3)
	end
end