--威望
local title_skill = {
    '1级威望',
    '2级威望',
    '3级威望',
    '4级威望',
    '5级威望',
    '6级威望',
    '7级威望',
}
local title = {
    [1] = '|cffcccccc初入江湖|r',
    [2] = '|cffaa9933武林菜鸟',
    [3] = '|cffeecc00声名鹊起',
    [4] = '|cffffcc00武林高手',
    [5] = '|cffffcccc一代宗师',
    [6] = '|cffff5050武林至尊',
    [7] = '|cffff0000独孤求败',
    [100] = '|cffffffff最多七个汉字哦',
}
local title_icon = {
    [1] = [[passive\prestige1.blp]],
    [2] = [[passive\prestige2.blp]],
    [3] = [[passive\prestige3.blp]],
    [4] = [[passive\prestige4.blp]],
    [5] = [[passive\prestige5.blp]],
    [6] = [[passive\prestige6.blp]],
    [7] = [[passive\prestige7.blp]],
}
local title_level = {
    [1] = 0,
    [2] = 2000,
    [3] = 4000,
    [4] = 6000,
    [5] = 8000,
    [6] = 10000,
    [7] = 12000,
}

--觉醒
local awake_skill = {
    '0阶觉醒',
    '1阶觉醒',
    '2阶觉醒',
    '3阶觉醒',
    '4阶觉醒',
    '5阶觉醒',
    '6阶觉醒',
    '7阶觉醒',
    '8阶觉醒',
    '9阶觉醒',
    '10阶觉醒',
}
local title2 = {
    [1] = '|cffcccccc未觉醒|r',
    [2] = '|cffccffcc【一阶】|r',
    [3] = '|cffffff00【二阶】',
    [4] = '|cffffaa00【三阶】',
    [5] = '|cffff8800【四阶】',
    [6] = '|cffff4400【五阶】',
    [7] = '|cffff0000【六阶】',
    [8] = '|cffff0044【七阶】',
    [9] = '|cffff0088【八阶】',
    [10] = '|cffff00aa【九阶】',
    [11] = '|cffff00ff【十阶】',
    [100] = '|cffffffff最多七个汉字哦',
}
local title2_icon = {
    [1] = [[passive\awake0.blp]],
    [2] = [[passive\awake1.blp]],
    [3] = [[passive\awake2.blp]],
    [4] = [[passive\awake3.blp]],
    [5] = [[passive\awake4.blp]],
    [6] = [[passive\awake5.blp]],
    [7] = [[passive\awake6.blp]],
    [8] = [[passive\awake7.blp]],
    [9] = [[passive\awake8.blp]],
    [10] = [[passive\awake9.blp]],
    [11] = [[passive\awake10.blp]],
}

local player_id = {}
ac.wait(0, function()
	--根据当前在线玩家调整计分板
	local online_player = {}
	local max_player = 0
	for i = 1,sg.max_player do
		local player = ac.player(i)
		if player:controller() == '用户' and player:gameState() == '在线' then
			max_player = max_player + 1
			player_id[player] = max_player
			table.insert(online_player,player)
		end
	end
    local board = ac.game:board(max_player + 1, 9, '初始化中')
    ac.wait(1, function()
        board:show()
        board:style(true, false)
        board[1][1]:text('基地')
        board[1][2]:text('战力')
        board[1][3]:text('抗性')
        board[1][4]:text('闪避')
        board[1][5]:text('威望')
        board[1][6]:text('觉醒')
        board[1][7]:text('战魂')
        board[1][8]:text('坐骑')
        board[1][9]:text('杀敌')
        for i = 1,max_player + 1 do
	        board[i][1]:width(0.07)
            board[i][2]:width(0.03)
            board[i][3]:width(0.02)
            board[i][4]:width(0.02)
            board[i][5]:width(0.06)
            board[i][6]:width(0.05)
            board[i][7]:width(0.02)
            board[i][8]:width(0.02)
            board[i][9]:width(0.04)
            if i ~= 1 then
	            local player = online_player[i - 1]
	            board[i][1]:text(sg.player_colour[player:id()]..player:name()..'|r')
            end
        end
        --for i = 1,sg.max_player do
        --    board[i][1]:width(0.07)
        --    board[i][2]:width(0.03)
        --    board[i][3]:width(0.02)
        --    board[i][4]:width(0.02)
        --    board[i][5]:width(0.06)
        --    board[i][6]:width(0.05)
        --    board[i][7]:width(0.02)
        --    board[i][8]:width(0.02)
        --    board[i][9]:width(0.04)
        --    if i ~= 1 then
        --        local player = ac.player(i-1)
        --        if player and player:controller() == '用户' and player:gameState() == '在线' then
        --            board[i][1]:text(sg.player_colour[i-1]..player:name()..'|r')
        --        end
        --    end
        --end
    end)

    ac.game:event('地图-选择英雄', function (_, unit, player)
        local id = player_id[player]
        if unit then
            --初始化积分相关属性
            unit:set('威望等级', 1)
            unit:set('觉醒等级', 0)
            unit:set('战魂数量', 0)
            unit:set('坐骑数量', 0)
            --设置多面板
            board[id+1][1]:style(true, true)
            board[id+1][1]:icon(unit:slk('art'))
            board[id+1][2]:text(math.floor(unit:get('战力'))..'%')
            board[id+1][3]:text(math.floor(unit:get('抗性'))..'%')
            board[id+1][4]:text(math.floor(unit:get('闪避'))..'%')
            --威望
            board[id+1][5]:style(true, true)
            board[id+1][5]:icon(title_icon[unit:get('威望等级')])
            board[id+1][5]:text(title[unit:get('威望等级')])
            --觉醒
            board[id+1][6]:style(true, true)
            board[id+1][6]:icon(title2_icon[unit:get('觉醒等级') + 1])
            board[id+1][6]:text(title2[unit:get('觉醒等级') + 1])
            --战魂数量
            board[id+1][7]:text(math.floor(unit:get('战魂数量')))
            --坐骑数量
            board[id+1][8]:text(math.floor(unit:get('坐骑数量')))
            --杀敌
            board[id+1][9]:text('0')
        end
    end)
    ac.game:event('地图-觉醒等级变化', function (_, unit)
        local player = unit:getOwner()
        local id = player_id[player]
        board[id+1][6]:icon(title2_icon[unit:get('觉醒等级') + 1])
        board[id+1][6]:text(title2[unit:get('觉醒等级') + 1])
        for i = 1,sg.max_player do
            ac.player(i):message('|cffffff00'..unit:getName()..'觉醒了!已达到'..title2[unit:get('觉醒等级') + 1]..'|r', 10)
        end

        local skill1 = unit:userData('觉醒技能')
        if skill1 then
            skill1:remove()
            local name = awake_skill[unit:get('觉醒等级') + 1]
            local skill2 = unit:addSkill(name, '技能', 6)
            unit:userData('觉醒技能', skill2)
        end
    end)

    --战魂数量变化
    ac.game:event('地图-获得战魂', function (_, unit)
        local player = unit:getOwner()
        local id = player_id[player]
        unit:add('战魂数量', 1)
        board[id+1][7]:text(math.floor(unit:get('战魂数量')))
    end)
    ac.game:event('地图-失去战魂', function (_, unit)
        local player = unit:getOwner()
        local id = player_id[player]
        unit:add('战魂数量', -1)
        board[id+1][7]:text(math.floor(unit:get('战魂数量')))
    end)

    --坐骑数量变化
    ac.game:event('地图-获得坐骑', function (_, unit)
        local player = unit:getOwner()
        local id = player_id[player]
        unit:add('坐骑数量', 1)
        board[id+1][8]:text(math.floor(unit:get('坐骑数量')))
    end)
    ac.game:event('地图-失去坐骑', function (_, unit)
        local player = unit:getOwner()
        local id = player_id[player]
        unit:add('坐骑数量', -1)
        board[id+1][8]:text(math.floor(unit:get('坐骑数量')))
    end)

    --等级
    --[[ac.game:event('地图-选择英雄', function (_, unit, player)
        unit:event('单位-升级', function (trg, unit)
            local id = player_id[player]
            board[id+1][3]:text(unit:level())
        end)
        unit:event('单位-降级', function (trg, unit)
            local id = player_id[player]
            board[id+1][3]:text(unit:level())
        end)
    end)]]

    --死亡
    --[[local hero_dead = {}
	for i = 1,sg.max_player do
        hero_dead[i] = 0
    end
    ac.game:event('地图-英雄死亡', function (_, unit, player, reborn_time)
        local id = player_id[player]
        if unit then
            hero_dead[id] = hero_dead[id] + 1
            board[id+1][5]:text(hero_dead[id])
        end
    end)]]

    --击杀
    ac.game:event('地图-英雄杀敌', function (_, unit, player, dead)
        local id = player_id[player]
        board[id+1][9]:text(unit:userData('杀敌数'))
        --称号
        if unit:get('威望等级') < #title_level and unit:userData('杀敌数') >= title_level[unit:get('威望等级') + 1] then
            unit:add('威望等级', 1)
            board[id+1][5]:icon(title_icon[unit:get('威望等级')])
            board[id+1][5]:text(title[unit:get('威望等级')])
            for i = 1,sg.max_player do
                ac.player(i):message('|cffffff00'..unit:getName()..'威望提升,称号变成了'..title[unit:get('威望等级')]..'|r', 10)
            end

            local skill1 = unit:userData('威望技能')
            if skill1 then
                skill1:remove()
                local name = title_skill[unit:get('威望等级')]
                local skill2 = unit:addSkill(name, '技能', 5)
                unit:userData('威望技能', skill2)
            end
        end
    end)

    --显示游戏时间
    local game_time_str = ''
    local game_time = {}
    game_time[1] = 0
    game_time[2] = 0
    game_time[3] = 0

    --显示游戏难度
    local game_mod_str = '难度选择中...'
    ac.game:event('地图-选择难度', function (_, num, i_player)
        local id = i_player:id()
        if num == 1 then
            game_mod_str = '|cff00ff00简单|r'
        elseif num == 2 then
            game_mod_str = '|cffffff00普通|r'
        elseif num == 3 then
            game_mod_str = '|cffff0000困难|r'
        elseif num == 4 then
            game_mod_str = '|cffff00ff噩梦|r'
        end
        for i = 1,sg.max_player do
            local player = ac.player(i)
            player:message(sg.player_colour[id]..i_player:name()..'|r难度选择为:'..game_mod_str, 10)
            player:message('|cffffcc00双击|r一名英雄来扮演Ta')
        end
        game_mod_str = '|cffffcc00当前难度: |r'..game_mod_str
    end)

    ac.loop(1, function()
        --修改玩家属性
	    for i = 1,sg.max_player do
            local player = ac.player(i)
            if player and player:controller() == '用户' then
                local unit = player:getHero()
                if unit then
                    board[i+1][2]:text(math.floor(unit:get('战力'))..'%')
                    board[i+1][3]:text(math.floor(unit:get('抗性'))..'%')
                    board[i+1][4]:text(math.floor(unit:get('闪避'))..'%')
                end
            end
        end

        --修改标题
        game_time_str = ''
        if game_time[1] >= 59 then
            game_time[1] = 0
            if game_time[2] >= 59 then
                game_time[2] = 0
                game_time[3] = game_time[3] + 1
            else
                game_time[2] = game_time[2] + 1
            end
        else
            game_time[1] = game_time[1] + 1
        end
        if game_time[3] < 10 then
            game_time_str = game_time_str..'0'
        end
        game_time_str = game_time_str..game_time[3]..'时'
        if game_time[2] < 10 then
            game_time_str = game_time_str..'0'
        end
        game_time_str = game_time_str..game_time[2]..'分'
        if game_time[1] < 10 then
            game_time_str = game_time_str..'0'
        end
        game_time_str = game_time_str..game_time[1]..'秒'
        board:title('|cffffff00〓传奇三国〓             玩家英雄属性             |r'..game_mod_str..'            '..'游戏时间:'..game_time_str)

        --显示基地血量
        local base_str = '基地[|cffffcc00'
        for i = 1, 20 do
            if sg.base and sg.base:get('生命') / sg.base:get('生命上限') > 0.05 * (i-0.5) then
                base_str = base_str..'I'
            else
                base_str = base_str..' '
            end
        end
        base_str = base_str..'|r]'
        board[1][1]:text(base_str)
    end)
end)