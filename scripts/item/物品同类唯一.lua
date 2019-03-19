
ac.game:event('物品-即将获得', function (_, item, unit)
    for item2 in unit:eachItem() do
        if item.is_weapon == 1 and item2.is_weapon == 1 then
            return false,'|cffffff00你已经拥有|cffff7500武器|cffffff00了|r'
        end
        if item.is_armor == 1 and item2.is_armor == 1 then
            return false,'|cffffff00你已经拥有|cffff7500衣服|cffffff00了|r'
        end
        if item.is_shoes == 1 and item2.is_shoes == 1 then
            return false,'|cffffff00你已经拥有|cffff7500鞋子|cffffff00了|r'
        end
        if item.is_ring == 1 and item2.is_ring == 1 then
            return false,'|cffffff00你已经拥有|cffff7500饰品|cffffff00了|r'
        end
    end
end)