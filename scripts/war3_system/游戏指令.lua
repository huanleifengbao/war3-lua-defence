local clear_timer
local gift = {
	['抽奖券'] = 1,
	['木材'] = 888,
}

--指令
ac.game:event('玩家-聊天', function (_, player, str)
	if str == '-自杀' then
		local hero = player:getHero()
		if hero:isAlive() then
			hero:kill(hero)
			sg.message(player:name() .. '寻死无方，选择了原地去世',5)
		end
		return
	end
	if string.find(str,'-G',1,2) then
		local flag
		if string.find(str,'Q',3) then
			flag = '金币'
		elseif string.find(str,'M',3) then
			flag = '木材'
		end		
		if flag then
			local id = string.sub(str,4,4)
			id = tonumber(id)
			if id and id <= sg.max_player and id >= 1 and string.sub(str,5,5) == ' ' then
				if id == player:id() then
					player:message('|cffff0000给予对象不能是自己！|r',5)
					return
				end
				local money = string.sub(str,6,string.len(str))
				money = tonumber(money)
				if money then
					if money > 0 then
						local target = ac.player(id)
						if target:gameState() == '在线' then
							if player:get(flag) >= money then
								local money = math.min(player:get(flag),money)											
								player:message('|cff00ff00您慷慨地给予了|r|cffff0000' .. target:name() .. ' |r|cffff6800' .. money .. '|r|cffffff00' .. flag .. '|r。',10)
								player:add(flag,-money)
								target:message('|cff00ff00您收到|r|cffff6800' .. money .. '|r|cffffff00' .. flag .. '|r|cff00ff00，从|r|cffff0000' .. player:name() .. '|r|cff00ff00那里。|r')
								target:add(flag,money)
							else
								player:message('|cffff0000您的的|r|cffffff00' .. flag .. '|r|cffff0000不够，给予失败！|r',5)
							end
						else
							player:message('|cffff0000该玩家|r|cffffff00不在线|r|cffff0000，给予失败！|r',5)
						end
					else
						player:message('|cffff0000给予的数量必须大于0|r',5)
						return
					end
				end
			end
		end
	end
	if str == '-清理' then
		local clear_time = 10
		if clear_timer then
			sg.message('|cffff9900清理物品的指令已被|r|cff99cc00取消|r',5)
			clear_timer:remove()
			clear_timer = nil
		else
			sg.message('|cffff0000所有地上物品将在|r|cffffff00' .. clear_time .. '|r|cffff0000秒后被清理！|r|cffff9900（再次输入“-清理”可取消本次指令）|r',10)
			clear_timer = ac.wait(clear_time,function()
				clear_timer = nil
				for _,item in ac.selector()
				    : mode '物品'
				    : inRange(ac.point(0,0),20000)
				    : ipairs()
				do
					item:remove()
				end
				sg.message('|cff99cc00所|r|cffa4d100有|r|cffafd700地|r|cffbbdd00上|r|cffc6e200物|r|cffd1e800品|r|cffddee00已|r|cffe8f300被|r|cfff3f900清|r|cffffff00理|r',5)
			end)
		end
		return
	end
	--福利
	if str == '920901612' then
		if not gift[player] then
			local lumber = gift['木材']
			local ticket = gift['抽奖券']
			player:message('|cffff6800你获得了|r|cff339966' .. lumber .. '木材|r|cffff6800和|r|cffffff00'.. ticket ..'张抽奖券|r|cffff6800作为福利！|r',10)
			gift[player] = true
			player:add('木材',lumber)
			player:add_shop_info('抽奖券',ticket)
		end
		return
	end
end)