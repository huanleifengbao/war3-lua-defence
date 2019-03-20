
--直接升级
--需要被升级的物品提供lvup_type,它将升级成new_item
local tbl = {'武器升级','衣服升级','鞋子升级','饰品升级','专属升级'}

for _, tbl_name in pairs(tbl) do
	local mt = ac.item[tbl_name]

    function mt:onCanAdd(unit)
        local player = unit:getOwner()
        local hero = player:getHero()

        for item in hero:eachItem() do
            if item.lvup_type and item.lvup_type == self:getName() and item.new_item then
                local item_name = item.new_item
                local item_slot = item:getSlot()
                item:remove()
                local item2 = hero:createItem(item_name, item_slot)
                player:message('|cffff7500'..self.lvup_type..'|cffffff00已升级|r', 10)

                --专属特殊处理
                if tbl_name == '专属升级' then
                    hero:userData('专属等级', hero:userData('专属等级') + 1)
                    hero:userData('专属', item2)
                end
                return true
            end
        end
        return false,'|cffffff00你未拥有可升级的|cffff7500'..self.lvup_type..'|r'
    end
end

--有主装备,并且需要合成材料,还可能失败
local tbl = {'装备进阶-1','装备进阶-2','装备进阶-3','装备进阶-4','装备进阶-5','装备进阶-6','装备进阶-7','装备进阶-8','装备进阶-9','装备进阶-10','终极合成'}

for _, tbl_name in pairs(tbl) do
	local mt = ac.item[tbl_name]

    function mt:onCanAdd(unit)
        local player = unit:getOwner()
        local hero = player:getHero()

        for item in hero:eachItem() do
            if item.lvup_type and item.lvup_type == self:getName() and item.new_item then
                local data = item.stuff
                if data then
                    local cost_item = {}
                    local cost_count = {}
                    local error_mark = true
                    local error_tips = ''
                    for i = 1, #data do
                        if data[i] then
                            local stuff_name = data[i][1]
                            local stuff_count = 1
                            if data[i][2] then
                                stuff_count = data[i][2]
                            end
                            local count = hero:findAllItem(stuff_name)
                            cost_item[i] = stuff_name
                            cost_count[i] = stuff_count
                            if count > 0 then
                                if count < stuff_count then
                                    if error_mark == true then
                                        error_mark = false
                                    else
                                        error_tips = error_tips..'\n'
                                    end
                                    local int = stuff_count - count
                                    error_tips = error_tips..'|cffff7500'..stuff_name..'|cffffff00数量不足'..'|cffff7500'..stuff_count..'|cffffff00个(还差|cffff7500'..int..'|cffffff00个)|r'
                                end
                            else
                                if error_mark == true then
                                    error_mark = false
                                else
                                    error_tips = error_tips..'\n'
                                end
                                if stuff_count > 1 then
                                    error_tips = error_tips..'|cffff7500'..stuff_name..'|cffffff00数量不足'..'|cffff7500'..stuff_count..'|cffffff00个(还差|cffff7500'..stuff_count..'|cffffff00个)|r'
                                else
                                    error_tips = error_tips..'|cffffff00你未拥有需要的|cffff7500'..stuff_name..'|r'
                                end
                            end
                        end
                    end
                    if error_mark == false then
                        return false, error_tips
                    end
                    for i = 1, #cost_item do
                        hero:removeItem(cost_item[i], cost_count[i])
                    end
                end
                local item_name = item.new_item
                local item_slot = item:getSlot()
                --装备甚至会boom
                local lvup_rate = self.lvup_rate
                if not lvup_rate then
                    lvup_rate = 100
                end
                local ex_buff = hero:findBuff('锻造成功率上升')
                if ex_buff then
                    lvup_rate = lvup_rate + ex_buff.odds
                end
                local ex_item = hero:findItem('作弊锻造失败券')
                if ex_item then
                    lvup_rate = lvup_rate - 1000
                end
                local ex_item = hero:findItem('作弊锻造强运券')
                if ex_item then
                    lvup_rate = lvup_rate + 1000
                end
                if sg.get_random(lvup_rate) then
                    item:remove()
                    hero:createItem(item_name, item_slot)
                    player:message('|cffff7500'..self.lvup_type..'|cffffff00进阶|cff00ff00成功|r', 10)
                else
                    --哦吼完蛋!
                    item_name = item.boom_item
                    if item_name then
                        local ex_item = hero:findItem('锻造保护券')
                        if ex_item then
                            if ex_item:stack() > 1 then
                                ex_item:stack(ex_item:stack() - 1)
                            else
                                ex_item:remove()
                            end
                            player:message('|cffff7500'..self.lvup_type..'|cffffff00进阶|cffff0000失败|cffffff00,但是|cffffbbdd锻造保护券|cffffff00防止了装备降级|r', 10)
                        else
                            item:remove()
                            hero:createItem(item_name, item_slot)
                            player:message('|cffff7500'..self.lvup_type..'|cffffff00进阶|cffff0000失败|cffffff00,装备|cffff0000降级|cffffff00了|r', 10)
                        end
                    else
                        player:message('|cffff7500'..self.lvup_type..'|cffffff00进阶|cffff0000失败|r', 10)
                    end
                end
                return true
            end
        end
        return false,'|cffffff00你未拥有可升级的|cffff7500'..self.lvup_type..'|r'
    end
end

--合成
local tbl = {'兑换玄铁-1','兑换玄铁-2','兑换玄铁-3','兑换玄铁-4'}

for _, tbl_name in pairs(tbl) do
	local mt = ac.item[tbl_name]

    function mt:onCanAdd(unit)
        local item = self
        local player = unit:getOwner()
        local hero = player:getHero()

        local data = self.stuff
        local cost_item = {}
        local cost_count = {}
        local error_mark = true
        local error_tips = ''
        for i = 1, #data do
            if data[i] then
                local stuff_name = data[i][1]
                local stuff_count = 1
                if data[i][2] then
                    stuff_count = data[i][2]
                end
                local count = hero:findAllItem(stuff_name)
                cost_item[i] = stuff_name
                cost_count[i] = stuff_count
                if count > 0 then
                    if count < stuff_count then
                        if error_mark == true then
                            error_mark = false
                        else
                            error_tips = error_tips..'\n'
                        end
                        local int = stuff_count - count
                        error_tips = error_tips..'|cffff7500'..stuff_name..'|cffffff00数量不足'..'|cffff7500'..stuff_count..'|cffffff00个(还差|cffff7500'..int..'|cffffff00个)|r'
                    end
                else
                    if error_mark == true then
                        error_mark = false
                    else
                        error_tips = error_tips..'\n'
                    end
                    if stuff_count > 1 then
                        error_tips = error_tips..'|cffff7500'..stuff_name..'|cffffff00数量不足'..'|cffff7500'..stuff_count..'|cffffff00个(还差|cffff7500'..stuff_count..'|cffffff00个)|r'
                    else
                        error_tips = error_tips..'|cffffff00你未拥有需要的|cffff7500'..stuff_name..'|r'
                    end
                end
            end
        end
        if error_mark == false then
            return false, error_tips
        end
        local item_name = item.new_item
        for i = 1, #cost_item do
            hero:removeItem(cost_item[i], cost_count[i])
        end
        sg.createItem(hero,item_name)
        player:message('|cffffff00已获得|cffff7500'..item_name..'|r', 10)
        return true
    end
end