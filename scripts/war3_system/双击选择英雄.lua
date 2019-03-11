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
    {'BOSS1', 2414, -8661, 230},
    {'BOSS3', 2214, -8661, 230},
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

for i = 1, 6 do
    ac.player(i):add('金币', 50000)
    ac.player(i):event('玩家-选中单位', function (trg, player, unit)
        if unit:getOwner():id() == 16 and not player:getHero() then
            if pick_mark[i] == unit then
                trg:remove()
                --unit:setOwner(player, true)
                local name = unit:getName()
                local hero = player:createUnit(name, ac.point(hero_tbl[i][2], hero_tbl[i][3]), hero_tbl[i][4])                             
                player:addHero(hero)
                local start_p = ac.point(7044, -8792)
                hero:blink(start_p)
                hero:bagSize(6)
                hero:addSkill('通用被动', '技能', 2)
                hero:addSkill('传送', '技能', 4)
                local skill = hero:addSkill('1级威望', '技能', 5)
                hero:userData('威望技能', skill)
                local skill = hero:addSkill('0阶觉醒', '技能', 6)
                hero:userData('觉醒技能', skill)
                --hero:addSkill('回城', '技能', 4)
                ac.player(16):createUnit(hero_tbl[i][1], ac.point(hero_tbl[i][2], hero_tbl[i][3]), hero_tbl[i][4])
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
                ac.game:eventNotify('地图-选择英雄', hero, player)
            else
                pick_mark[i] = unit
                ac.wait(0.3, function()
                    pick_mark[i] = false
                end)
            end
        end
    end)
end