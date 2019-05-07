local gay_damage = 0

local function add_damage(count)
	gay_damage = gay_damage + count
	for i = 1,sg.max_player do
		local player = ac.player(i)
		local hero = player:getHero()
		if hero then
			hero:add('战力',count)
		else
			local trg
			trg = ac.game:event('地图-选择英雄', function(_,h,p)
				if p == player then
					h:add('战力',gay_damage)
					trg:remove()
				end
			end)
		end
	end
end

--羁绊组合
local gay_group = {
	['夫妻同心'] = {group = {'刘备','孙尚香'},damage = 30},
	['桃园结义'] = {group = {'刘备','关羽','张飞'},damage = 50},
	['父女情深'] = {group = {'张飞','星彩'},damage = 20},
	['辕门射戟'] = {group = {'吕布','貂蝉'},damage = 60},
	['五虎上将'] = {group = {'关羽','张飞','赵云','黄忠','马超'},damage = 100},
	['乱世奇才'] = {group = {'诸葛亮','司马懿','周瑜'},damage = 50},
}

ac.game:event('地图-选择英雄', function(_,hero, player)
	local name = hero:getName()
	for title,data in pairs(gay_group) do
	    local group = data.group
	    local damage = data.damage
	    for i = #group,1,-1 do
	        if name == group[i] then			                        
	            table.remove(group,i)
	            if #group == 0 then
	                sg.message('|cffff0000羁|r|cffff5500绊|r|cffffaa00组|r|cffffff00合|r|cffff6800' .. title .. '|r|cffffff00已|r|cffffc000经|r|cffff8000解|r|cffff4000锁|r|cffff0000！|r（全体玩家战力提升|cffff9900' .. damage .. '|r%）',10)
	                add_damage(damage)
	            else
		            local str = ''
		            for _,hero_name in ipairs(group) do
		            	str = str .. ' ' .. hero_name .. ' '
	            	end
	                sg.message('|cffffff00玩家|cffff0000'..player:name()..'|r|cffffff00选择了|r|cffff9900'..name..'|r|cffffff00，还需选择|r|cffff9900'..str..'|r|cffffff00即可解锁羁绊组合|r|cffff9900'..title..'|r（全体战力增加|cffff9900' .. damage .. '%|r）',10)
	            end
	            break
	        end
	    end
	end
end)