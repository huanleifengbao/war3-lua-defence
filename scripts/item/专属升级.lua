
--local Aghanim_lv = {500, 1000, 3000, 5000, 8000}
local Aghanim_lv = {5, 10, 30, 50, 80}

ac.game:event('地图-英雄杀敌', function (_, unit, player, dead)
    if unit:userData('专属等级') <= #Aghanim_lv and unit:userData('杀敌数') >= Aghanim_lv[unit:userData('专属等级')] then
        unit:createItem('专属升级')
    end
end)