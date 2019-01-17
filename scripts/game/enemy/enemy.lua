local wave = 0	--当前波数
local player = ac.player(11)	--刷怪玩家
local start_point = {	--出怪点，有几个点就出几路怪
	ac.point(6050,3900),
	ac.point(6950,3900),
	ac.point(7800,3900),
}

--获取当前波数的单位ID
function sg.get_enemy_id(num)
	return '波数' .. num
end

local data = {
	id = function(n)
		return sg.get_enemy_id(n)
	end,
	start_time = 5,	--前置等待时间
	time_out = 40,	--每波间隔时间
	count = 30,	--每条路怪物数量
	boss = 10,	--每多少波出一次boss
	boss_time = 1,	--开始几秒后BOSS出现
	interval = 0.5,	--每只怪物出生间隔
	max_wave = 10,	--最大波数
	attribute = {	--进攻怪物属性公式
		['生命上限'] = function(n)
			return 100 + n * 10
		end,
		['攻击'] = function(n)
			return 20 + n * 2
		end,
		['护甲'] = function(n)
			return 2 + n * 1
		end,
		['移动速度'] = function(n)
			return 300 + n * 10
		end,
	},
}

local boss_data = {

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
			return 1000 + n * 100
		end,
		['攻击'] = function(n)
			return 200 + n * 20
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
		--boss
		local boss_wave = data.boss
		if boss_wave ~= 0 and wave%boss_wave == 0 then
			ac.wait(data.boss_time,function()
				print('boss出现！')
			end)
		end
	end
end

local timer = jass.CreateTimer()

local function create_wave()
	wave = wave + 1
	create_enemy(wave)
	local str = '第' .. wave .. '波'
	jass.TimerDialogSetTitle(timer, str)
	ac.wait(data.time_out,function()
		local max_wave = data.max_wave
		if max_wave == 0 or wave < max_wave then
			create_wave()
		else
			jass.TimerDialogDisplay(timer, false)
		end
	end)
end

ac.game:event('进入无尽模式', function (_, data)
	print('进入无尽模式')
	--将刷怪表替换为无尽表后重新开始刷怪逻辑
	for key,val in pairs(ex_data) do
		data[key] = val
	end
	wave = 0
	game_start()
end)

local function game_start()
	ac.wait(data.start_time,function()
		jass.TimerDialogDisplay(timer, true)
		create_wave()
		print('开始刷怪')
	end)
end

game_start()