
--   [单位名字]      = {{道具A,概率},{道具B,概率}},
--概率(%)可超过100来代表数量
local data = {
    ['锻造石boss-1'] = {{'一级锻造石', 100}},
    ['锻造石boss-2'] = {{'二级锻造石', 100}},
    ['锻造石boss-3'] = {{'三级锻造石', 100}},
    ['锻造石boss-4'] = {{'四级锻造石', 100}},
    ['锻造石boss-5'] = {{'五级锻造石', 100}},
    ['锻造石boss-6'] = {{'六级锻造石', 100}},
    ['锻造石boss-7'] = {{'七级锻造石', 100},{'玄铁', 10}},
    ['锻造石boss-8'] = {{'八级锻造石', 100},{'百年玄铁', 10}},
    ['锻造石boss-9'] = {{'九级锻造石', 100},{'千年玄铁', 10}},
    ['锻造石boss-10'] = {{'十级锻造石', 100},{'九幽玄铁', 10}},
    ['锻造石boss-11'] = {{'终极锻造石', 100}},
}

ac.game:event('单位-创建', function (_, unit)
    local name = unit:getName()
    if data[name] and #data[name] > 0 then
        unit:event('单位-死亡', function (_, _, killer)
            --自杀是不掉东西的
            if killer ~= unit then
                local p = unit:getPoint()
                for item_table = 1, #data[name] do
                    local item_name = data[name][item_table][1]
                    local count_rd = data[name][item_table][2]

                    local function createItem()
                        local item = p:createItem(item_name)
                        ac.effect {
                            target = item:getPoint(),
                            model = [[Abilities\Spells\Other\Transmute\PileofGold.mdl]],
                            speed = 1,
                            time = 1.5,
                        }
                    end
                    for _ = 1, 100 do
                        if count_rd >= 100 then
                            createItem()
                            count_rd = count_rd - 100
                        else
                            break
                        end
                    end
                    if sg.get_random(count_rd) then
                        createItem()
                    end
                end
            end
        end)
    end
end)