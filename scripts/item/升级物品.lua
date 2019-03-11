
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
                    unit:userData('专属', item2)
                end
                return true
            end
        end
        player:message('|cffffff00你未拥有可升级的|cffff7500'..self.lvup_type..'|r', 10)
        return false
    end
end

--带合成条件的
local tbl = {'装备进阶-1','装备进阶-2','装备进阶-3','装备进阶-4','装备进阶-5','装备进阶-6','装备进阶-7','装备进阶-8','装备进阶-9','装备进阶-10','终极合成'}

for _, tbl_name in pairs(tbl) do
	local mt = ac.item[tbl_name]

    function mt:onCanAdd(unit)
        local player = unit:getOwner()
        for item in unit:eachItem() do
            if item.lvup_type and item.lvup_type == self:getName() and item.lvup_next then
                local item_ex = {}
                local mark = true
                if item.lvup_ex1 then
                    item_ex[1] = unit:findItem(item.lvup_ex1)
                    if not item_ex[1] then
                        player:message('|cffffff00你未拥有需要的材料|cffff7500'..item.lvup_ex1..'|r', 10)
                        mark = false
                    end
                end
                if item.lvup_ex2 then
                    item_ex[2] = unit:findItem(item.lvup_ex2)
                    if not item_ex[2] then
                        player:message('|cffffff00你未拥有需要的材料|cffff7500'..item.lvup_ex2..'|r', 10)
                        mark = false
                    end
                end
                if item.lvup_ex3 then
                    item_ex[3] = unit:findItem(item.lvup_ex3)
                    if not item_ex[3] then
                        player:message('|cffffff00你未拥有需要的材料|cffff7500'..item.lvup_ex3..'|r', 10)
                        mark = false
                    end
                end
                if item.lvup_ex4 then
                    item_ex[4] = unit:findItem(item.lvup_ex4)
                    if not item_ex[4] then
                        player:message('|cffffff00你未拥有需要的材料|cffff7500'..item.lvup_ex4..'|r', 10)
                        mark = false
                    end
                end
                if mark == false then
                    return false
                end
                local item_name = item.lvup_next
                local item_slot = item:getSlot()
                for i = 1, 6 do
                    if item_ex[i] then
                        if item_ex[i]:stack() > 0 then
                            item_ex[i]:stack(item_ex[i]:stack() - 1)
                        else
                            item_ex[i]:remove()
                        end
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

--不需要主体装备,将材料直接合成的
local tbl = {'兑换玄铁-1'}

for _, tbl_name in pairs(tbl) do
	local mt = ac.item[tbl_name]

    function mt:onCanAdd(unit)
        local item = self
        local player = unit:getOwner()
        local data = self.stuff
        local cost_item = {}
        local cost_count = {}
        local mark = true
        for i = 1, #data do
            if data[i] then
                local stuff_name = data[i][1]
                local stuff_count = 1
                if data[i][2] then
                    stuff_count = data[i][2]
                end
                cost_item[i] = unit:findItem(stuff_name)
                cost_count[i] = stuff_count
                if cost_item[i] then
                    if cost_item[i]:stack() < stuff_count then
                        player:message('|cffff7500'..stuff_name..'|cffffff00数量不足'..'|cffff7500'..stuff_count..'|cffffff00个|r', 10)
                        mark = false
                    end
                else
                    player:message('|cffffff00你未拥有需要的|cffff7500'..stuff_name..'|r', 10)
                    mark = false
                end
            end
        end
        if mark == false then
            return false
        end
        local item_name = item.new_item
        for i = 1, #cost_item do
            if cost_item[i] then
                if cost_item[i]:stack() > cost_count[i] then
                    cost_item[i]:stack(cost_item[i]:stack() - cost_count[i])
                else
                    cost_item[i]:remove()
                end
            end
        end
        if #sg.get_free_slot(unit) > 0 then
            unit:createItem(item_name)
        else
            unit:getPoint():createItem(item_name)
        end
        unit:createItem(item_name)
        player:message('|cffffff00已获得|cffff7500'..item_name..'|r', 10)
        return true
    end
end