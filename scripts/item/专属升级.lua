
--local Aghanim_lv = {500, 1000, 3000, 5000, 8000}
--需要杀怪数量,需要的专属挑战等级
local Aghanim_lv = {
    {500, nil},
    {1000, 3},
    {3000, 4},
    {5000, 5},
    {8000, 6}
}

ac.game:event('地图-英雄杀敌', function (_, unit, player, dead)
    if unit:userData('专属等级') <= #Aghanim_lv and unit:userData('杀敌数') >= Aghanim_lv[unit:userData('专属等级')][1] and (Aghanim_lv[unit:userData('专属等级')][2] == nil or unit:userData('专属挑战等级') >= Aghanim_lv[unit:userData('专属等级')][2]) then
        unit:createItem('专属升级')
    end
end)