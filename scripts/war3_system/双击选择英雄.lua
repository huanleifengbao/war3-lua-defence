local pick_mark = {}

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

for i = 1, 6 do
    ac.player(i):event('玩家-选中单位', function (trg, player, unit)
        if unit:getOwner():id() == 16 and not player:getHero() then
            if pick_mark[i] == unit then
                trg:remove()
                unit:setOwner(player, true)
                player:addHero(unit)
                local start_p = ac.point(7044, -8792)
                unit:blink(start_p)
                unit:bagSize(6)
                unit:addSkill('通用被动', '技能', 2)
                unit:addSkill('回城', '技能', 4)
                local item_name = Aghanim[unit:getName()]
                if item_name then
                    local item = unit:createItem(item_name..'-1')
                    unit:userData('专属', item)
                end
                player:moveCamera(start_p, 0.2)
                ac.game:eventNotify('地图-选择英雄', unit, player)
            else
                pick_mark[i] = unit
                ac.wait(0.3, function()
                    pick_mark[i] = false
                end)
            end
        end
    end)
end