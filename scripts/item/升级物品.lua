
local tbl = {'武器升级','衣服升级','鞋子升级','饰品升级','专属升级'}

for _, tbl_name in pairs(tbl) do
	local mt = ac.item[tbl_name]

    function mt:onCanAdd(unit)
        for item in unit:eachItem() do
            if item.lvup_type and item.lvup_type == self:getName() and item.lvup_next then
                local item_name = item.lvup_next
                local item_slot = item:getSlot()
                item:remove()
                local item2 = unit:createItem(item_name, item_slot)
                unit:getOwner():message('|cffff7500'..self.lvup_type..'|cffffff00已升级|r', 10)

                --专属特殊处理
                if tbl_name == '专属升级' then
                    unit:userData('专属等级', unit:userData('专属等级') + 1)
                end
                return true
            end
        end
        unit:getOwner():message('|cffffff00你未拥有可升级的|cffff7500'..self.lvup_type..'|r', 10)
        return false
    end
end