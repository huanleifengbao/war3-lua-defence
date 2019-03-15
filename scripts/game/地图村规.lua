--增加三维并增加对应属性
ac.game:event('单位-属性变化', function (_, hero, name, count)
	if hero:isHero() then
		if name == '力量' then
			hero:add('生命上限',25 * count)
			hero:add('生命恢复',0.05 * count)
		elseif name == '敏捷' then
			hero:add('攻击速度',0.02 * count)
			hero:add('护甲',0.001 * count)
		elseif name == '智力' then
			hero:add('魔法上限',15 * count)
			hero:add('魔法恢复',0.05 * count)
			hero:add('攻击',1 * count)
		end
	end
end)

--升级三维
ac.game:event('地图-选择英雄', function (_, hero)
	hero:event('单位-升级', function ()
		hero:add('力量', (hero:level() * 0.1) + 5)
		hero:add('敏捷', (hero:level() * 0.1) + 5)
		hero:add('智力', (hero:level() * 0.1) + 5)
	end)
	hero:event('单位-降级', function ()
		hero:add('力量', - (hero:level() * 0.1) + 5)
		hero:add('敏捷', - (hero:level() * 0.1) + 5)
		hero:add('智力', - (hero:level() * 0.1) + 5)
	end)
end)

--难度系数
sg.difficult = 0
local dif_tbl = {
	[0] = 1,
	[1] = 1,
	[2] = 2,
	[3] = 4,
	[4] = 8,
}
ac.game:event('单位-创建', function (_, unit)
	local player = unit:getOwner()
	if player == sg.creeps_player or player == sg.enemy_player then
		ac.wait(0,function()
			local num = dif_tbl[sg.difficult]
			unit:set('生命上限',unit:get('生命上限') * num)
			unit:set('攻击',unit:get('攻击') * num)
			unit:set('力量',unit:get('力量') * num)
			unit:set('敏捷',unit:get('敏捷') * num)
			unit:set('智力',unit:get('智力') * num)
		end)
	end
end)