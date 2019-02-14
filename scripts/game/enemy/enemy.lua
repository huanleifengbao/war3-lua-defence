local wave = 0	--当前波数
local player = ac.player(11)	--刷怪玩家
local start_point = {	--出怪点，有几个点就出几路怪
	ac.point(6050,3900),
	ac.point(6950,3900),
	ac.point(7800,3900),
}

--获取当前波数的单位ID
function sg.get_enemy_id(num)
	num = math.ceil(num)
	return '波数' .. num
end
function sg.get_boss_id(num)
	num = math.ceil(num)
	return 'BOSS' .. num
end

--难度系数
sg.difficult = 0
local dif_tbl = {
	[1] = 0.5,
	[2] = 1,
	[3] = 2,
	[4] = 4,
}

--生命值表
local hp_tbl = {
	10000,20000,30000,36000,45000,70000,110100,110100,160100,240100,
	360100,540100,790100,1000100,1500100,2000100,2600100,3600100,4800100,6400100,
	8400100,10000100,13000100,18000100,29000100,38000100,45000100,55000100,75000096,85000096,
	95000096,105000096,135000096,165000096,205000096,255000096,255000096,275000096,305000096,355000096,
}
--护甲表
local def_tbl = {
	40,100,200,200,300,450,625,625,925,925,
	1000,1800,2700,4000,5000,6000,8000,8000,9000,10000,
	15000,20000,25000,30000,35000,40000,50000,55000,55000,55000,
	60000,65000,70000,80000,90000,100000,110000,130000,1630000,2630000,
}

local data = {
	id = function(n)
		return sg.get_enemy_id(n)
	end,
	start_time = 10,	--前置等待时间
	time_out = 80,	--每波间隔时间
	count = 20,	--每条路怪物数量
	boss = 10,	--每多少波出一次boss
	boss_time = 10,	--开始几秒后BOSS出现
	interval = 0.5,	--每只怪物出生间隔
	max_wave = 40,	--最大波数
	attribute = {	--进攻怪物属性公式
		['生命上限'] = function(n)
			local hp = hp_tbl[n]
			if not hp then
				hp = hp_tbl[#hp_tbl]
			end
			return hp * dif_tbl[sg.difficult]
		end,
		['攻击'] = function(n)
			local atk
			if n <= 3 then
				atk = n * 50
			else
				atk = n * 100
			end
			return atk * dif_tbl[sg.difficult]
		end,
		['护甲'] = function(n)
			local def = def_tbl[n]
			if not def then
				def = def_tbl[#def_tbl]
			end
			return def
		end,
		['移动速度'] = function(n)
			return 400
		end,
	},
}

local boss_data = {
	id = function(n)
		return sg.get_boss_id(n)
	end,
	attribute = {	--进攻怪物属性公式
		['生命上限'] = function(n)
			return (10000 + n * 100) * dif_tbl[sg.difficult]
		end,
		['攻击'] = function(n)
			return (2000 + n * 200) * dif_tbl[sg.difficult]
		end,
		['护甲'] = function(n)
			return 20 + n * 10
		end,
		['移动速度'] = function(n)
			return 300 + n * 10
		end,
	},
}

local ex_data = {
	id = '波数1',
	start_time = 30,
	time_out = 15,
	count = 15,
	boss = 0,
	interval = 1,
	max_wave = 0,
		attribute = {
		['生命上限'] = function(n)
			return (1000 + n * 100) * dif_tbl[sg.difficult]
		end,
		['攻击'] = function(n)
			return (200 + n * 20) * dif_tbl[sg.difficult]
		end,
		['护甲'] = function(n)
			return 20 + n * 10
		end,
		['移动速度'] = function(n)
			return 300
		end,
	},
}

local function create_enemy(wave)
	for i = 1,#start_point do
		local p = start_point[i]
		ac.timer(data.interval,data.count,function()
			local u = player:createUnit(data.id(wave),p,270)
			for key,val in pairs(data.attribute) do
				u:set(key,val(wave))
			end
			u:set('生命',u:get'生命上限')
			sg.add_ai(u)
		end)
	end
	--boss
	local boss_wave = data.boss
	if boss_wave ~= 0 and wave%boss_wave == 0 then
		local boss_time = data.boss_time
		sg.create_timer('boss','boss',boss_time)
		ac.wait(boss_time,function()
			local num = wave/boss_wave
			local u = player:createUnit(boss_data.id(num),start_point[2],270)
			for key,val in pairs(boss_data.attribute) do
				u:set(key,val(num))
			end
			u:set('生命',u:get'生命上限')
			sg.add_ai(u)
			print('boss出现！')
		end)
	end
end

local function create_wave()
	wave = wave + 1
	create_enemy(wave)
	local time_out = data.time_out
	local str = '第' .. wave + 1 .. '波'
	sg.set_timer_title('波数',str)
	sg.set_timer_time('波数',time_out)
	ac.wait(data.time_out,function()
		local max_wave = data.max_wave
		if max_wave == 0 or wave < max_wave then
			create_wave()
		else
			sg.remove_timer('波数')
		end
	end)
end

ac.game:event('地图-进入无尽模式', function (_, data)
	print('进入无尽模式')
	--将刷怪表替换为无尽表后重新开始刷怪逻辑
	for key,val in pairs(ex_data) do
		data[key] = val
	end
	wave = 0
	game_start()
end)

local function game_start()
	local time = data.start_time
	sg.create_timer('波数','第1波',time)
	ac.wait(time,function()
		create_wave()
		print('开始刷怪')
	end)
end

ac.game:event('地图-选择难度', function (_, num)
	sg.difficult = num
	game_start()
end)