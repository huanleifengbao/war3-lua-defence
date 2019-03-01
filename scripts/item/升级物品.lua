
--直接升级
--需要被升级的物品提供lvup_type,它将升级成lvup_next
local tbl = {'武器升级','衣服升级','鞋子升级','饰品升级','专属升级'}

for _, tbl_name in pairs(tbl) do
	local mt = ac.item[tbl_name]

    function mt:onCanAdd(unit)
        local player = unit:getOwner()
        for item in unit:eachItem() do
            if item.lvup_type and item.lvup_type == self:getName() and item.lvup_next then
                local item_name = item.lvup_next
                local item_slot = item:getSlot()
                item:remove()
                local item2 = unit:createItem(item_name, item_slot)
                player:message('|cffff7500'..self.lvup_type..'|cffffff00已升级|r', 10)

                --专属特殊处理
                if tbl_name == '专属升级' then
                    unit:userData('专属等级', unit:userData('专属等级') + 1)
                end
                return true
            end
        end
        player:message('|cffffff00你未拥有可升级的|cffff7500'..self.lvup_type..'|r', 10)
        return false
    end
end

--带合成条件的
local tbl = {'装备进阶-1'}

for _, tbl_name in pairs(tbl) do
	local mt = ac.item[tbl_name]

    function mt:onCanAdd(unit)
        local player = unit:getOwner()
        for item in unit:eachItem() do
            if item.lvup_type and item.lvup_type == self:getName() and item.lvup_next then
                local item_ex = {}
                if item.lvup_ex1 then
                    item_ex[1] = unit:findItem(item.lvup_ex1)
                    print('正在找:',item.lvup_ex1,'单位:',unit,'结果:',item_ex[1])
                    if not item_ex[1] then
                        player:message('|cffffff00你未拥有需要的材料|cffff7500'..item.lvup_ex1..'|r', 10)
                        return false
                    end
                end
                local item_name = item.lvup_next
                local item_slot = item:getSlot()
                for i = 1, 6 do
                    if item_ex[i] then
                        item_ex[i]:remove()
                    end
                end
                item:remove()
                local item2 = unit:createItem(item_name, item_slot)
                player:message('|cffff7500'..self.lvup_type..'|cffffff00已升级|r', 10)
                return true
            end
        end
        player:message('|cffffff00你未拥有可升级的|cffff7500'..self.lvup_type..'|r', 10)
        return false
    end
end