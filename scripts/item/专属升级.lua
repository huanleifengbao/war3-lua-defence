
--local Aghanim_lv = {500, 1000, 3000, 5000, 8000}
local Aghanim_lv = {
    {5, nil, 100},
    {10, '电', 80},
    {30, '雷', 70},
    {50, '晓', 60},
    {80, '响', 50}
}

ac.game:event('地图-英雄杀敌', function (_, unit, player, dead)
    if unit:userData('专属等级') <= #Aghanim_lv and unit:userData('杀敌数') >= Aghanim_lv[unit:userData('专属等级')][1] and (Aghanim_lv[unit:userData('专属等级')][2] == nil or Aghanim_lv[unit:userData('专属等级')][2] == dead:getName()) then
        if sg.get_random(Aghanim_lv[unit:userData('专属等级')][3]) then
            unit:createItem('专属升级')
        else
            unit:getOwner():message('|cffff0000哦豁,专属升级失败了|r', 10)
        end
    end
end)