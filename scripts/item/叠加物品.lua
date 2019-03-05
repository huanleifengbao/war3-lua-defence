
local tbl = {'治疗药水-小','治疗药水-大','一级锻造石','二级锻造石','三级锻造石','四级锻造石','五级锻造石','六级锻造石','七级锻造石','八级锻造石','九级锻造石','十级锻造石','终极锻造石'
}

for _, tbl_name in pairs(tbl) do
	local mt = ac.item[tbl_name]

    --即使是满格也能购买可叠加的物品
    function mt:onCanBuy(unit)
        local name = self:getName()
        local item2 = unit:findItem(name)
        if item2 then
            return true
        end
    end
    --即使是满格也能拾取
    function mt:onCanLoot(unit)
        local item = self
        local item2 = unit:findItem(item:getName())
        item.can_add = false
        if item2 and item ~= item2 then
            item.can_add = true
            return true
        end
    end
    --安检
    function mt:onCanAdd(unit)
        local item = self
        local item2 = unit:findItem(item:getName())
        if item2 and item ~= item2 then
            return true
        end
    end

    --爽 上飞机了
    function mt:onAdd()
        local item = self
        local unit = item:getOwner()
        if item:stack() == 0 then
            if item.item_stack then
                item:stack(item.item_stack)
            else
                item:stack(1)
            end
        end
        for item2 in unit:eachItem() do
            if item:getName() == item2:getName() and item ~= item2 then
                item2:stack(item:stack() + item2:stack())
                item:remove()
            end
        end
    end
end