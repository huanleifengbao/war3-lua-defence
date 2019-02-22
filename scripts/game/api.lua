--全体玩家计时器窗口
local timerdialog = {}
function sg.set_timer_title(key,name)
	local timer = timerdialog[key]
	if timer then
		for i = 1,#timer do
			timer[i]:setTitle(name)
		end
	end
end
function sg.set_timer_time(key,time)
	local timer = timerdialog[key]
	if timer then
		for i = 1,#timer do
			timer[i]:setTimer(time)
		end
	end
end
function sg.remove_timer(key)
	local timer = timerdialog[key]
	if timer then
		for i = #timer,1,-1 do
			timer[i]:remove()
		end
	end
	timerdialog[key] = nil
end
local function create_timer(name,time)
	local tbl = {}
	for i = 1,sg.max_player do
	    local player = ac.player(i)
	    local dialog = player:timerDialog(name,time)
	    table.insert(tbl,dialog)
	end
	return tbl
end
function sg.create_timer(key,name,time)
	if timerdialog[key] then
		local timer = timerdialog[key][1]
		if timer and timer._removed ~= true then		
			sg.set_timer_title(key,name)
			sg.set_timer_time(key,time)
		else
			timerdialog[key] = create_timer(name,time)
		end
	else
		timerdialog[key] = create_timer(name,time)
	end
end

--增加三维并增加对应属性
function sg.add_atr(hero,name,count)
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
	else
		error('不合法的属性名')
		return
	end
	hero:add(name,count)
end

--增加全属性
function sg.add_allatr(hero,count)
	sg.add_atr(hero,'力量',count)
	sg.add_atr(hero,'敏捷',count)
	sg.add_atr(hero,'智力',count)
end

--获取全属性
function sg.get_allatr(hero)
	return hero:get('力量') + hero:get('敏捷') + hero:get('智力')
end

--恢复最大百分比生命
function sg.recovery(hero,rate)
	hero:add('生命',hero:get('生命上限') * rate/100)
end

--判断概率
function sg.get_random(odds)
	return odds >= math.random(100)
end

--播放单位动画
function sg.animation(unit,name,loop)
	local handle = unit._handle
	jass.SetUnitAnimation(handle,name)
	if not loop then
		jass.QueueUnitAnimation(handle, "stand")
	end
end

--播放单位动画(序号)
function sg.animationI(unit,num,loop)
	local handle = unit._handle
	jass.SetUnitAnimationByIndex(handle,num)
	if not loop then
		jass.QueueUnitAnimation(handle, "stand")
	end
end

--改编单位动画速度
function sg.animationSpeed(unit,num)
	jass.SetUnitTimeScale(unit._handle,num)
end

--指定点创建特效
function sg.effect(point,flie,time)
	local x,y = point:getXY()
	local effect = jass.AddSpecialEffect(flie,x,y)
	if time then
		ac.wait(1,function()
			jass.DestroyEffect(effect)
		end)
	else
		jass.DestroyEffect(effect)
	end
end

--创建特效绑定单位
function sg.effectU(unit,socket,flie,time)
	local handle = unit._handle
	local effect = jass.AddSpecialEffectTarget(flie,handle,socket)
	if time then
		ac.wait(1,function()
			jass.DestroyEffect(effect)
		end)
	end
end