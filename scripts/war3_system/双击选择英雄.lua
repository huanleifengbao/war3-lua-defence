local pick_mark = {}

--英雄,x,y,面向角度
local hero_tbl = {
    {'刘备', 773, -8622, 229},
    {'关羽', 1217, -8671, 44},
    {'张飞', 1682, -8615, 152},
    {'黄忠', 2140, -8665, 288},
    {'诸葛亮', 831, -8891, 109},
    {'吕布', 1131, -8928, 5},
    {'赵云', 1388, -8933, 91},
    {'司马懿', 1659, -8952, 213},
    {'星彩', 1928, -8955, 50},
    {'貂蝉', 2180, -8944, 88},
    {'孙尚香', 1914, -8661, 230},
    {'副本-孔秀', 1914, -8361, 230},
    {'副本-韩福', 1914, -8061, 230},
    {'副本-孟坦', 1914, -7761, 230},
    {'副本-卞喜', 1914, -7461, 230},
    {'副本-王植', 1914, -7161, 230},
    {'副本-秦琪', 1914, -6861, 230},
}

local Aghanim = {
    ['刘备'] = '真黄龙剑',
    ['关羽'] = '青龙偃月刀',
    ['张飞'] = '破军蛇矛',
    ['黄忠'] = '破邪旋风斩',
    ['诸葛亮'] = '朱雀羽扇',
    ['吕布'] = '无双方天戟',
    ['赵云'] = '豪龙胆',
    ['司马懿'] = '穷奇羽扇',
    ['星彩'] = '煌天',
    ['貂蝉'] = '金丽玉霞',
    ['孙尚香'] = '日月乾坤剑',
}

for i = 1, #hero_tbl do
    ac.player(16):createUnit(hero_tbl[i][1], ac.point(hero_tbl[i][2], hero_tbl[i][3]), hero_tbl[i][4])
end

sg.family = {}
ac.game:event('地图-选择难度', function ()
    for i = 1,sg.max_player do
        ac.player(i):add('金币', 50000)
        ac.player(i):event('玩家-选中单位', function (trg, player, unit)
            if unit:getOwner():id() == 16 and not player:getHero() then
                if pick_mark[i] == unit then
                    trg:remove()
                    --unit:setOwner(player, true)
                    local name = unit:getName()
                    for _ = 1, 1 do
                        sg.player_count = sg.player_count + 1
                        local start_p = ac.point(7044, -8792)
                        local hero = player:createUnit(name, start_p, hero_tbl[i][4])
                        player:addHero(hero)
                        hero:bagSize(6)
                        hero:addSkill('@命令', '技能', 12)
                        hero:addSkill('传送', '技能', 4)
                        local skill = hero:addSkill('1级威望', '技能', 5)
                        hero:userData('威望技能', skill)
                        local skill = hero:addSkill('0阶觉醒', '技能', 6)
                        hero:userData('觉醒技能', skill)
                        hero:userData('战魂技能', {})
                        hero:userData('坐骑技能', {})
                        hero:addSkill('战魂魔法书', '技能', 7)
                        hero:addSkill('坐骑魔法书', '技能', 8)
                        local item_name = Aghanim[name]
                        if item_name then
                            local item = hero:createItem(item_name..'-1')
                            hero:userData('专属', item)
                            hero:userData('专属名字', item:getName())
                            hero:userData('专属等级', 1)
                            hero:userData('专属挑战等级', 1)
                        end
                        player:moveCamera(start_p, 0.2)
                        hero:userData('杀敌数', 0)
                        sg.family[player] = {}
                        ac.game:eventNotify('地图-选择英雄', hero, player)
                    end
                else
                    pick_mark[i] = unit
                    ac.wait(0.3, function()
                        pick_mark[i] = false
                    end)
                end
            end
        end)
    end
end)

local point = ac.point(1300, -9100)
local textTag_msg = '|cffff9900双击|cffffff00选择英雄|r'
ac.textTag()
: text(textTag_msg, 0.05)
: at(point, 10)