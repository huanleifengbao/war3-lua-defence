local wave = 0	--当前波数
sg.ally_player = ac.player(10)	--基地玩家
sg.creeps_player = ac.player(11)	--野怪玩家
sg.enemy_player = ac.player(12)	--刷怪玩家
local player = sg.enemy_player
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
--击杀给多少金钱
local gold_tbl = {
	100,150,200,250,300,350,400,450,500,550,
	600,650,700,750,800,850,900,950,1000,1050,
	1100,1150,1200,1250,1300,1350,1400,1450,1500,1550,
	1600,1650,1700,1750,1800,1850,1900,1950,2000,2500,
}
--击杀给多少木材
local lumber_tbl = {
	10,11,12,13,14,15,16,17,18,19,
	20,21,22,23,24,25,26,27,28,29,
	30,31,32,33,34,35,36,37,38,39,
	40,41,42,43,44,45,46,47,48,49,
}
--击杀给多少经验
local exp_tbl = {
	10,15,20,25,30,35,40,45,50,55,
	60,65,70,75,80,85,90,95,100,105,
	110,115,120,125,130,135,140,145,150,155,
	160,165,170,175,180,185,190,195,200,250,
}

local data = {
	id = function(n)
		return sg.get_enemy_id(n)
	end,
	start_time = 10,	--前置等待时间
	time_out = 80,	--每波间隔时间
	count = 15,	--每条路怪物数量
	boss = 10,	--每多少波出一次boss
	boss_time = 8,	--开始几秒后BOSS出现
	interval = 0.5,	--每只怪物出生间隔
	max_wave = 40,	--最大波数
	attribute = {	--进攻怪物属性公式
		['生命上限'] = function(n)
			local hp = hp_tbl[n]
			if not hp then
				hp = hp_tbl[#hp_tbl]
			end
			return hp
		end,
		['攻击'] = function(n)
			local atk
			if n <= 3 then
				atk = n * 50
			else
				atk = n * 100
			end
			return atk
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
	['死亡金钱'] = function(n)
		return gold_tbl[n] or gold_tbl[#gold_tbl]
	end,
	['死亡木材'] = function(n)
		return lumber_tbl[n] or lumber_tbl[#lumber_tbl]
	end,
	['死亡经验'] = function(n)
		return exp_tbl[n] or exp_tbl[#exp_tbl]
	end,
}

local boss_data = {
	id = function(n)
		return sg.get_boss_id(n)
	end,
	attribute = {	--进攻怪物属性公式
		['生命'] = function(n)
			return 10^n * 500000
		end,
		['力量'] = function(n)
			return 10^n * 10000
		end,
		['敏捷'] = function(n)
			return 10^n * 10000
		end,
		['智力'] = function(n)
			return 10^n * 10000
		end,
		['魔抗'] = function(n)
			return 15 + n * 20
		end,
		['移动速度'] = function(n)
			return 500
		end,
	},
	level = function(n)
		return 2000 * n
	end,
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
			return (1000 + n * 100)
		end,
		['攻击'] = function(n)
			return (200 + n * 20)
		end,
		['护甲'] = function(n)
			return 20 + n * 10
		end,
		['移动速度'] = function(n)
			return 300
		end,
	},
}

local function init_unit(u)
	sg.add_ai(u)
	table.insert(sg.all_enemy,u)
	u:set('生命',u:get'生命上限')
	u:event('单位-死亡', function(_, _, _)
		for i = 1,#sg.all_enemy do
			if sg.all_enemy[i] == u then
				table.remove(sg.all_enemy,i)
				break
			end
		end
	end)
end

sg.all_enemy = {}

local function create_enemy(wave)
	if data.count > 0 then
		sg.enemy_timer = ac.timer(data.interval,data.count,function()
			for i = 1,#start_point do
				local p = start_point[i]
				local u = player:createUnit(data.id(wave),p,270)
				for key,val in pairs(data.attribute) do
					u:set(key,val(wave))
				end
				u:set('死亡金钱', data['死亡金钱'](wave))
				u:set('死亡木材', data['死亡木材'](wave))
				u:set('死亡经验', data['死亡经验'](wave))
				init_unit(u)
			end
		end)
	end
	--boss
	local boss_wave = data.boss
	if boss_wave ~= 0 and wave%boss_wave == 0 then
		local boss_time = data.boss_time		
		sg.boss_timer = ac.wait(boss_time,function()
			local num = wave/boss_wave
			local u = player:createUnit(boss_data.id(num),start_point[2],270)
			for key,val in pairs(boss_data.attribute) do
				u:set(key,val(num))
			end
			init_unit(u)
			sg.add_ai_skill(u)
			u:addBuff '纯化'
			{
				time = 0,
			}
			u:level(boss_data.level(num),false)
		end)
		sg.timerdialog('boss',sg.boss_timer)
	end
end

local timerdialog = {}
local function create_wave()
	wave = wave + 1
	create_enemy(wave)
	local time_out = data.time_out
	local str = '第' .. wave + 1 .. '波'
	local max_wave = data.max_wave
	sg.wave_timer = ac.wait(data.time_out,function()		
		if max_wave == 0 or wave < max_wave then
			create_wave()
		end
	end)
	if wave < max_wave then
		timerdialog = sg.timerdialog(str,sg.wave_timer)
	end
end

local function game_start()
	local time = data.start_time
	sg.wave_timer = ac.wait(time,function()
		create_wave()
		print('开始刷怪')
	end)
	sg.timerdialog('第1波',sg.wave_timer)
end

ac.game:event('地图-选择波数',function(_,num)
	if num > data.max_wave then
		num = data.max_wave
	elseif num < 1 then
		num = 1
	end
	wave = num - 1
	local str = '第' .. num .. '波'
	for _,t in pairs(timerdialog) do
		if t then
			t:setTitle(str)
		end
	end
	sg.message('当前波数已修改为' .. str)
end)

ac.game:event('地图-选择难度', function (_, num)
	sg.difficult = num
	game_start()
end)

ac.game:event('地图-进入无尽模式', function (_, data)
	print('进入无尽模式')
	--将刷怪表替换为无尽表后重新开始刷怪逻辑
	for key,val in pairs(ex_data) do
		data[key] = val
	end
	wave = 0
	game_start()
end)

--作弊
ac.game:event('玩家-聊天', function (_, _, str)
	if string.find(str,'-波数 ',1,5) then
		local gsu =  sg.split(str,'-波数 ')
		ac.game:eventNotify('地图-选择波数', tonumber(gsu[1]))
	end
end)

function sg.get_wave()
	return wave
end