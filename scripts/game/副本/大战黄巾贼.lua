
local mt = ac.item['副本-大战黄巾贼']

--飞机位置
local start_point = ac.point(6050, -9300)
--副本位置
local target_point = ac.point(-4100, 8150)
local stage_start = false
--回城
local home = ac.point(7044, -8792)
--副本初始怪物
local instance_data = {
    {name = '副本-张宝', point = ac.point(-2000, 8150), facing = 270},
    {name = '副本-张梁', point = ac.point(-4100, 10280), facing = 270},
    {name = '副本-张角', point = ac.point(-2000, 10280), facing = 270},
}
--购买次数限制
local limit = 3

function mt:onCanAdd(unit)
    local player = unit:getOwner()
    if sg.game_mod == '副本' or sg.game_mod == '副本准备' then
        player:message('|cffffff00目前某种副本正在激活|r', 5)
        return false
    end
end

function mt:onAdd()
    sg.game_mod = '副本准备'
    local mark = {}
    local hero_mark = {}
    local trg_mark = {}
    local hero_count = 0
    local boss_mark = {}
    local boss_count = 0

    local time = 20
    local msg = '副本-大战黄巾贼'
    local time2 = 300
    local msg2 = '时间限制'
    --飞机特效
    local eff1 = ac.effect {
        target = start_point - {135,300},
        model = [[effect\flag.mdx]],
        height = 0,
        angle = 315,
        size = 2.5,
        speed = 1,
    }
    local eff2 = ac.effect {
        target = start_point,
        model = [[buildings\other\CircleOfPower\CircleOfPower.mdl]],
        size = 3.5,
        speed = 1,
    }
    local textTag_msg = '|cffffcc00'..msg..'|n|cffffff00参与人数:'..'0'..'/'..sg.player_count..'|r'
    local textTag = ac.textTag()
        : text(textTag_msg, 0.04)
        : at(start_point, 50)
    local timer

    local rect = ac.rect(start_point, 500, 500)
    local exit_trg
    local function instance()
    	if exit_trg then
	    	exit_trg:remove()
    	end
        if timer then
            timer:remove()
        end
        --结束副本一定会跑的函数
        local function instance_end()
        	ac.game:music(sg.last_music)
        	stage_start = false
            sg.start_enemy()
            for _, u in pairs(sg.all_enemy) do
                local buff = u:findBuff('冻结')
                if buff then
                    buff:remove()
                end
            end
            if exit_trg then
		    	exit_trg:remove()
	    	end
            --清空事件
            for _,trg in ipairs(trg_mark) do
	            if trg then
		            trg:remove()
	            end
            end
            hero_mark = {}
            boss_mark = {}
            sg.game_mod = '通常'
            for i = 1,sg.max_player do
                local player = ac.player(i)
                player:message('副本已结束,敌人重新开始|cffff7500进攻|r', 5)
                sg.reborn(player,0)
            end
        end
        --如果根本没人上飞机就直接end
        if #mark == 0 then
            instance_end()
        else
	        --音乐
	        ac.game:music([[resource\music\bs1.mp3]])
	        stage_start = true
	        --视野
			sg.off_fog(ac.rect(-5000,7300,-1150,11150))
            --时限
            local timer2 = ac.wait(time2, function()
                for _, hero in ipairs(hero_mark) do
                    local player = hero:getOwner()
                    player:message('哎鸭|cffff7500超时|r了', 8)
                    hero:kill(hero)
                    ac.effect {
                        target = hero:getPoint(),
                        model = [[Objects\Spawnmodels\NightElf\NEDeathSmall\NEDeathSmall.mdl]],
                        speed = 1,
                        time = 0,
                    }
                end
            end)
            local function ace()
                if stage_start == true and hero_count == 0 then
                    timer2:remove()
                    stage_start = false
                    for _, hero in ipairs(hero_mark) do
                        local player = hero:getOwner()
                        hero:kill(hero)
                        player:message('啊欧|cffff7500团灭|r了,副本失败', 8)
                    end
                    local end_time = 4
                    ac.wait(end_time, function()
                        for _, boss in ipairs(boss_mark) do
                            ac.effect {
                                target = boss:getPoint(),
                                model = [[Abilities\Spells\Orc\FeralSpirit\feralspirittarget.mdl]],
                                speed = 1,
                                size = 3,
                                time = 1,
                            }
                            boss:kill(boss)
                            boss:remove()
                        end
                        instance_end()
                    end)
                end
            end
            --遍历进入副本的英雄
            for k, u in ipairs(mark) do
                local player = u:getOwner()
                local id = player:id()
                player:timerDialog(msg2, timer2)
                player:message('已进入副本,时间限制|cffff7500'..time2..'|r秒请注意', 8)
                player:message('|cff00ff00击杀所有boss|r就会胜利,|cffff0000团灭或超时|r副本挑战就失败了', 8)
                player:message('另外副本中可是|cffff7500禁止传送|r并且|cffff7500无法复活|r的哟', 8)
                hero_mark[k] = u
                hero_count = hero_count + 1
                --local trg1, trg2
                trg_mark[k] = u:event('单位-死亡', function ()
                    trg_mark[k]:remove()
                   -- trg2:remove()
                    hero_count = hero_count - 1
                    if hero_count <= 0 then
                        ace()
                    else
                        --没团灭的死者会假死
                       -- u:addBuff '假死'{}
                        --for i = 1,sg.max_player do
                        sg.message(sg.player_colour[id]..u:getName()..'|r被杀了!剩余英雄:|cffff7500'..hero_count..'|r', 5)
                        --end
                       -- return false
                    end
                end)
                --trg2 = u:event('单位-死亡', function ()
                --    trg1:remove()
                --    trg2:remove()
                --    hero_count = hero_count - 1
                --    if hero_count <= 0 then
                --        ace()
                --    end
                --end)
                local p2 = target_point - {360 / #mark * k, 120}
				u:tp(p2, true)
                u:set('生命', u:get('生命上限'))
                u:set('魔法', u:get('魔法上限'))
                u:addRestriction '硬直'
                local int = 5
                ac.timer(1, 6, function()
                    if int == 5 then
                        player:message('目标:讨伐(击杀)|cffff0000张梁|r,|cff0070ff张宝|r,|cff00aa00张角|r', 8)
                    end
                    if int <= 3 and int >= 1 then
                        player:message('开始倒计时:|cffff7500'..int..'|r', 1)
                    end
                    if int == 0 then
                        player:message('|cffff7500葱鸭!|r', 2)
                        u:removeRestriction '硬直'
                    end
                    int = int - 1
                end)
            end
            --创建boss
            for i = 1, #instance_data do
                boss_count = boss_count + 1
                local boss = sg.creeps_player:createUnit(instance_data[i].name, instance_data[i].point, instance_data[i].facing)
                sg.add_ai_skill(boss)
                table.insert(boss_mark, boss)
                boss:event('单位-死亡', function (trg, _, killer)
                    trg:remove()
                    if killer ~= boss then
                        boss_count = boss_count - 1
                        if boss_count == 0 then
	                        ac.wait(0,function()
		                        if stage_start == true then
			                        local item = sg.fb_shop:getItem(msg)
		                        	if item then
			                        	item:remove()
		                        	end
			                        stage_start = false
		                            timer2:remove()
		                            local back_time = 10
		                            local back_msg = '即将返回'
		                            local back_timer = ac.wait(back_time, function()
		                                for k, hero in ipairs(hero_mark) do
		                                    local p2 = home - {360 / #hero_mark * k, 120}
		                                    hero:tp(p2, true)
		                                    --local buff = hero:findBuff('假死')
		                                    --if buff then
		                                    --    buff:remove()
		                                    --end
		                                    hero:set('生命', hero:get('生命上限'))
		                                    hero:set('魔法', hero:get('魔法上限'))
		                                    hero:removeRestriction '无敌'
		                                end
		                                instance_end()
		                            end)
		                            for _, hero in ipairs(hero_mark) do
		                                hero:addRestriction '无敌'
		                                local player = hero:getOwner()
		                                player:message('|cff00ff00boss团灭|r了xs,你们胜利了,|cffff7500'..back_time..'|r秒后返回', 8)
		                                player:message('所有参与者获得|cffffdd00400000|r金钱和|cff25cc75400000|r木材,爽死了', 8)
		                                player:timerDialog(back_msg, back_timer)
		                                hero:createItem('副本奖励2')
		                            end
		                            ac.game:musicTheme([[resource\music\victory.mp3]])
		                            --打赢了当然要放点烟花(TNT)庆祝下
		                            --放个p
		                            --[==[local p1 = boss:getPoint()
		                            ac.timer(0.05, 100, function()
		                                local p2 = p1 - {math.random(360), math.random(100, 800)}
		                                local mover = boss:moverLine
		                                {
		                                    model = [[Abilities\Weapons\DemolisherFireMissile\DemolisherFireMissile.mdl]],
		                                    start = p2,
		                                    angle = 0,
		                                    speed = 600,
		                                    distance = 1200,
		                                    startHeight = 1500,
		                                    middleHeight = 1500,
		                                    finishHeight = 0,
		                                }
		                                --[=[ac.effect {
		                                    target = p2,
		                                    model = [[Abilities\Weapons\DemolisherFireMissile\DemolisherFireMissile.mdl]],
		                                    speed = 1,
		                                    size = math.random(10, 30) / 10,
		                                    time = 0,
		                                }]=]
		                            end)]==]--
	                            end
                            end)
                        end
                    end
                end)
            end
            sg.game_mod = '副本'
        end
        eff1:remove()
        eff2:remove()
        textTag:remove()
        rect:remove()
    end

    --进入/离开副本区域
    function rect:onEnter(u)
        local player = u:getOwner()
        local id = player:id()
        if u:isHero() and (id >= 1 and id <= sg.max_player) then
            table.insert(mark, u)
            textTag_msg = '|cffffcc00'..msg..'|n|cffffff00参与人数:'..#mark..'/'..sg.player_count..'|r'
            textTag:text(textTag_msg, 0.04)
            if #mark >= sg.player_count then
                instance()
            end
        end
    end
    function rect:onLeave(u)
        for k, unit in ipairs(mark) do
            if u == unit then
                table.remove(mark, k)
                textTag_msg = '|cffffcc00'..msg..'|n|cffffff00参与人数:'..#mark..'/'..sg.player_count..'|r'
                textTag:text(textTag_msg, 0.04)
                break
            end
        end
    end
    exit_trg = ac.game:event('地图-删除英雄', function (_, u)
        for k, unit in ipairs(mark) do
            if u == unit then
                table.remove(mark, k)
                break
            end
        end
        textTag_msg = '|cffffcc00'..msg..'|n|cffffff00参与人数:'..#mark..'/'..sg.player_count..'|r'
        textTag:text(textTag_msg, 0.04)
        if #mark >= sg.player_count then
            instance()
        end
    end)

    --进入副本的时限
    timer = ac.wait(time, function()
        for i = 1,sg.max_player do
            local player = ac.player(i)
            player:message('集结时间已到，|cffff0000强制|r进入副本', 10)
            local hero = player:getHero()
            if hero and not ac.isInTable(mark,hero) then
	            sg.reborn(player,0)
	            table.insert(mark,hero)
            end
        end
        instance()
    end)
    --冻结所有怪物
    sg.stop_enemy()
    for _, u in pairs(sg.all_enemy) do
        u:addBuff '冻结'{}
    end
	for i = 1,sg.max_player do
        local player = ac.player(i)
        player:timerDialog(msg, timer)
        player:message('进攻的敌人已被|cff00ffff冻结|r', 20)
        player:message('|cffff7500大战黄巾贼|r副本已激活,想去就所有人在|cffff7500'..time..'|r秒内去|cffff7500能量圈|r集合', 20)
    end
    --次数限制
    limit = limit - 1
    if limit <= 0 then
	    local item = sg.fb_shop:getItem(msg)
		if item then
			item:remove()
		end
    end
    sg.message('剩余挑战次数：' .. '|cffff7500'..limit..'|r',5)
end