--判断是否在表里
function sg.isintable(tbl,val)
	for k,v in pairs(tbl) do
		if k == val or v == val then
			return true
		end
	end
	return false
end

--全体玩家计时器窗口
function sg.timerdialog(title,timer,player)
	if not player then
		for i = 1,sg.max_player do
			ac.player(i):timerDialog(title,timer)
		end
	else
		player:timerDialog(title,timer)
	end
end

--增加全属性
function sg.add_allatr(hero,count)
	hero:add('力量', count)
	hero:add('敏捷', count)
	hero:add('智力', count)
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

local function create_effect(handle)
	local eff = {}
	eff._handle = handle
	function eff:remove()
		jass.DestroyEffect(handle)
	end
	function eff:duration(time)
		if time then
			if eff.timer then
				eff.timer:remove()
			end
			eff.timer = ac.wait(time,function()
				eff:remove()
			end)
		end
	end
	return eff
end

--创建特效绑定单位
function sg.effectU(unit,socket,flie,time)
	local handle = unit._handle
	local effect = jass.AddSpecialEffectTarget(flie,handle,socket)
	local eff = create_effect(effect)
	eff:duration(time)
	return eff
end

--改变单位颜色
function sg.set_color(unit,tbl)
	local handle = unit._handle
	local nt = {r = 255,g = 255,b = 255,a = 255}
	if not tbl then
		tbl = {}
	end
	for k,v in pairs(tbl) do
		nt[k] = nt[k] * v
	end
	jass.SetUnitVertexColor(handle,nt.r,nt.g,nt.b,nt.a)
end

--取两点之间接触到碰撞的点
function sg.on_block(p1,p2)
	local angle = p1/p2
	local distance = p1*p2
	local j = distance/10
	local target = p1
	for i = 1,j do
		if target:isBlock() then
			break
		else
			target = target - {angle,10}
		end
	end
	return target
end

--取两点之间越过碰撞能移动的最远的点
function sg.leap_block(p1,p2)
	local angle = p2/p1
	local distance = p1*p2
	local j = distance/10
	local target = p2
	for i = 1,j do
		if target:isBlock() then
			target = target - {angle,10}
		else
			break
		end
	end
	return target
end

--跳字
function sg.text_tag(data)
	if not data.text or not data.point then
		error('没有输入必要信息')
	end
	local deafault = {
		text = nil,
		point = nil,
		height = 100,
		size = 25,
		speed = 25,
		angle = 90,
		time = 1.5,
		fade = 0.8,
		player = nil,
	}
	for k,v in pairs(data) do
		deafault[k] = v
	end
	ac.textTag()
        : text(deafault.text, deafault.size/1000)
        : at(deafault.point, deafault.height)
        : speed(deafault.speed/1000, deafault.angle)
        : life(deafault.time, deafault.fade)
        : show(function (p)
        	if not deafault.player then
	        	return true
        	else
	        	return p == deafault.player
        	end
        end)
end

--加钱跳字
function sg.add_gold(unit,type,count)
	if count <= 0 then
		return
	end
	local player = unit:getOwner()
	player:add(type, count)
    local msg = math.floor(count)
    if type == '金币' then
    	msg = '|cffffdd00+'..msg..'|n'
	elseif type == '木材' then
		msg = '|cff25cc75+'..msg..'|n'
	else
		msg = '+' ..math.floor(count)
	end
	sg.text_tag({
		text = msg,
		point = unit:getPoint(),
		height = 140,
		player = player,
	})
	--sg.text_tag(msg,unit:getPoint(),140,player)
    --ac.textTag()
    --    : text(msg, 0.025)
    --    : at(unit:getPoint(), 140)
    --    : speed(0.025, 90)
    --    : life(1.5, 0.8)
    --    : show(function (p)
    --        return player == p
    --    end)
end

--获取空的背包格子
function sg.get_free_slot(hero)
	local tbl = {1,2,3,4,5,6}
	for item in hero:eachItem() do
		local slot = item:getSlot()
		for i = #tbl,1,-1 do
			if tbl[i] == slot then
				table.remove(tbl,i)
			end
		end
	end
	return tbl
end

--暂停刷怪
local stop = 0
function sg.stop_enemy()
	stop = stop + 1
	if sg.wave_timer then
		sg.wave_timer:pause()
	end
	if sg.enemy_timer then
		sg.enemy_timer:pause()
	end
	if sg.boss_timer then
		sg.boss_timer:pause()
	end
end

--继续刷怪
function sg.start_enemy()
	stop = stop - 1
	if stop <= 0 then
		if sg.wave_timer then
			sg.wave_timer:resume()
		end
		if sg.enemy_timer then
			sg.enemy_timer:resume()
		end
		if sg.boss_timer then
			sg.boss_timer:resume()
		end
	end
end