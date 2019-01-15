local wave = 0	--当前波数
local player = ac.player(12)	--刷怪玩家
local start_point = {	--出怪点，有几个点就出几路怪
	{6050,3900},
	{6950,3900},
	{7800,3900},
}

--获取当前波数的单位ID
local function get_enemy_id(num)
	return 'enem' .. num
end

local data = {
	id = function(n)
		return get_enemy_id(n)
	end,
	start_time = 60,	--前置等待时间
	time_out = 40,	--每波间隔时间
	count = 30,	--每条路怪物数量
	interval = 0.5,	--每只怪物出生间隔
	max_wave = 40,	--最大波数
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

local function create_enemy(wave)
	for _,p in pairs(start_point) do
		ac.timer(data.interval * 1000,data.count,function()
			--print('刷怪' .. data.id(wave))
		end)
	end
end

local function create_wave()
	wave = wave + 1
	create_enemy(wave)
	print('第' .. wave .. '波开始')
	ac.wait(data.time_out * 1000,function()
		local max_wave = data.max_wave
		if wave < max_wave and max_wave ~= 0 then
			create_wave()
		end
	end)
end

local function game_start()
	ac.wait(data.start_time * 1000,function()
		create_wave()
		print('开始刷怪')
	end)
end

game_start()