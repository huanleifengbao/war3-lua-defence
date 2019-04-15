
--需要杀怪数量,需要的专属挑战等级
local Aghanim_lv = {
    {500, nil},
    {1000, 3},
    {2000, 4},
    {3000, 5},
    {4000, 6}
}

ac.game:event('地图-英雄杀敌', function (_, unit, player, dead)
    local item = unit:userData('专属')
    if item and unit:userData('专属等级') <= #Aghanim_lv then
        local stack = math.min(item:stack() + 1, Aghanim_lv[unit:userData('专属等级')][1])
        item:stack(stack)
    end
    if item and unit:userData('专属等级') <= #Aghanim_lv and item:stack() >= Aghanim_lv[unit:userData('专属等级')][1] and (Aghanim_lv[unit:userData('专属等级')][2] == nil or unit:userData('专属挑战等级') >= Aghanim_lv[unit:userData('专属等级')][2]) then
        unit:createItem('专属升级')
    end
end)