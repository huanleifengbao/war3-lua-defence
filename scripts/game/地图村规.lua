--增加三维并增加对应属性
ac.game:event('单位-属性变化', function (_, hero, name, count)
	if name == '力量' then
		hero:add('生命上限',25 * count)
		hero:add('生命恢复',0.05 * count)
	elseif name == '敏捷' then
		hero:add('攻击速度',0.02 * count)
		hero:add('护甲',0.15 * count)
	elseif name == '智力' then
		hero:add('魔法上限',15 * count)
		hero:add('魔法恢复',0.05 * count)
		hero:add('攻击',1 * count)
	end
end)