local wave = 0	--当前波数
local player = sg.enemy_player
local start_point = {	--出怪点，有几个点就出几路怪
	ac.point(6050,3900),
	ac.point(6950,3900),
	ac.point(7800,3900),
}

--获取当前波数的单位ID
function sg.get_enemy_id(num)
	num = math.ceil(num)
	if num > 40 then
		num = num%40
	end
	return '波数' .. num
end
function sg.get_boss_id(num)
	num = math.ceil(num)
	if num > 4 then
		num = num%4
	end
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
	1000,1200,1500,1800,2000,2200,2500,2800,3000,3500,
	4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,
	10000,11000,12000,13000,14000,15000,16000,17000,18000,19000,
}
--进攻怪物技能
local enemy_skill = {
	[11] = '耐久光环',
	[13] = '诱捕',
	[15] = '致命一击',
	[17] = '狂热',
	[19] = '狂战士',
	[21] = '坚韧光环',
	[23] = '减速',
	[25] = '神圣护甲',
	[27] = '闪避',
	[29] = '浸毒武器',
	[31] = '心灵之火',
	[33] = '重生',
	[35] = '残废',
	[37] = '重击',
	[39] = '精灵之火',
	[40] = '魔化',
}
--BOSS掉落木材表
local boss_lumber = {1000,5000,10000,20000}

local data = {
	id = function(n)
		return sg.get_enemy_id(n)
	end,
	start_time = 120,	--前置等待时间
	time_out = 80,	--每波间隔时间
	count = 15,	--每条路怪物数量
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
			return hp
		end,
		['攻击'] = function(n)
			local atk
			if n < 10 then
				atk = n * 100
			elseif n < 20 then
				atk = n * 5000
			elseif n < 30 then
				atk = n * 50000
			elseif n <= 40 then
				atk = n * 300000
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
		['魔抗'] = function(n)
			return math.max(0,n - 9)
		end,
		['命中'] = function(n)
			return 20
		end,
		['移动速度'] = function(n)
			return 400
		end,
	},
	['死亡金钱'] = function(n)
		return n * 500
	end,
	['死亡木材'] = function(n)
		return math.max(0,(n - 5) * 2)
	end,
	buff = function(n)
		return enemy_skill[n]
	end,
}

local boss_data = {
	id = function(n)
		return sg.get_boss_id(n)
	end,
	attribute = {	--进攻怪物属性公式
		['生命'] = function(n)
			return 10^n * 25000000
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
		['护甲'] = function(n)
			return 5000 * n
		end,
		['魔抗'] = function(n)
			return n * 10 + 50
		end,
		['命中'] = function(n)
			return 50
		end,
		['移动速度'] = function(n)
			return 400
		end,
		['死亡木材'] = function(n)
			return boss_lumber[n]
		end,
	},	
	level = function(n)
		return 2000 * n
	end,
	buff = function(n)
		return '纯化'
	end,
}

local ex_data = {
	boss = 0,
	max_wave = 0,
	attribute = {
		['生命上限'] = function(n)
			return (hp_tbl[#hp_tbl] * 1.2^n)
		end,
		['攻击'] = function(n)
			return (4000000 * 2^n)
		end,
		['护甲'] = function(n)
			return (def_tbl[#def_tbl] * 1.2^n)
		end,
		['魔抗'] = function(n)
			return 30
		end,
		['命中'] = function(n)
			return 100
		end,
		['移动速度'] = function(n)
			return 400
		end,
	},
	['死亡金钱'] = function(n)
		return 0
	end,
	['死亡木材'] = function(n)
		return 0
	end,
	buff = function(n)
		if n <= 20 then
			return '魔化'
		else
			return '纯化'
		end
	end,
}
sg.player_kill_count = {}
local function init_unit(u)
	sg.add_ai(u)
	table.insert(sg.all_enemy,u)
	u:set('生命',u:get'生命上限')
	u:addRestriction '幽灵'
	u:event('单位-死亡', function(_, _, killer)
		local player = killer:getOwner()
		if not sg.player_kill_count[player] then
			sg.player_kill_count[player] = 0
		end
		sg.player_kill_count[player] = sg.player_kill_count[player] + 1
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
				init_unit(u)
				local buff = data.buff(wave)
				if buff then
					u:addBuff(buff)
					{
						time = 0,
					}
				end
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
			u:event('单位-死亡',function()
				ac.game:eventNotify('地图-BOSS死亡',num)
			end)
			for key,val in pairs(boss_data.attribute) do
				u:set(key,val(num))
			end
			init_unit(u)
			sg.add_ai_skill(u)
			local buff = boss_data.buff(wave)
			if buff then
				u:addBuff(buff)
				{
					time = 0,
				}
			end
			u:level(boss_data.level(num),false)
			for i = 1,10 do
				sg.message('|cffff0000敌|r|cffff0800方|r|cffff1000将|r|cffff1800领|r|cffff2000出|r|cffff2800现|r|cffff3000！|r|cffff3800速|r|cffff4000速|r|cffff4800支|r|cffff5000援|r|cffff5800本|r|cffff6000阵|r|cffff6800！|r',10)
			end
			--已是最后一波boss，创建胜利条件
			if data.max_wave ~= 0 and wave == data.max_wave then
				local timer
				timer = ac.loop(1,function()
					if #sg.all_enemy == 0 then
						timer:remove()
						ac.game:eventNotify('地图-游戏通关')
						sg.last_music = [[resource\music\s1.mp3]]
						ac.game:music(sg.last_music)
						ac.wait(0,function()
							ac.game:musicTheme([[resource\music\victory.mp3]])											
						end)
					end
				end)
				sg.last_music = [[resource\music\bs4.mp3]]
			else
				sg.last_music = [[resource\music\bs1.mp3]]
				u:event('单位-死亡',function(_,_,killer)
					local player = killer:getOwner()
					sg.message('|cffff0000' .. player:name() .. '|r|cffffff00作|r|cffffff0c出|r|cffffff19了|r|cffffff26最|r|cffffff33后|r|cffffff3f一|r|cffffff4c击|r|cffffff59，|r|cffffff66成|r|cffffff72功|r|cffffff7f讨|r|cffffff8c伐|r|cffffff99敌|r|cffffffa5方|r|cffffffb2将|r|cffffffbf领|r|cffffffcc！|r',10)
					sg.last_music = [[resource\music\s1.mp3]]
					ac.game:music(sg.last_music)
				end)
			end
			ac.game:music(sg.last_music)			
		end)
		sg.timerdialog('boss',sg.boss_timer)
	end
end

local function get_dialog_str(n)
	local str = '第' .. n .. '波'
	if sg.ex_mode then
		str = '无尽' .. str
	end
	return str
end

local timerdialog = {}
local function create_wave()
	wave = wave + 1
	create_enemy(wave)
	local time_out = data.time_out
	local now_wave = wave + 1
	local str = get_dialog_str(now_wave)
	local max_wave = data.max_wave
	sg.message('|cffffffcc第|r|cffff9900' .. wave .. '|r|cffffffcc波进攻到来，请注意防守本阵！|r',10)
	--非无尽给工资
	if sg.ex_mode ~= true then		
		local gold = 5000 * wave
		sg.message('|cffff6600所有玩家获得了|r|cffffff00' .. gold .. '|r|cffff6600金币的补给|r',10)
		if enemy_skill[wave] then
			sg.message('|cffffff00本波进攻怪物带有|r|cffff0000' .. enemy_skill[wave] .. '|r|cffffff00技能，请小心。|r',10)
		end
		for i = 1,sg.max_player do
			ac.player(i):add('金币', gold)
		end
	end
	ac.game:eventNotify('地图-进攻开始',wave)
	if max_wave == 0 or wave < max_wave then
		sg.wave_timer = ac.wait(time_out,function()		
			create_wave()
		end)
	end
	if max_wave == 0 or wave < max_wave then
		timerdialog = sg.timerdialog(str,sg.wave_timer)
	end
end

local function game_start()
	local time = data.start_time
	sg.wave_timer = ac.wait(time,function()
		create_wave()
	end)
	local str = get_dialog_str(1)
	sg.timerdialog(str,sg.wave_timer)
end

ac.game:event('地图-选择波数',function(_,num)
	if num > data.max_wave then
		num = data.max_wave
	elseif num < 1 then
		num = 1
	end
	wave = num - 1
	local str = get_dialog_str(num)
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

ac.game:event('地图-游戏通关', function ()
	--难度大于2才进无尽
	if sg.difficult >= 2 then
	--将刷怪表替换为无尽表后重新开始刷怪逻辑
	for key,val in pairs(ex_data) do
		data[key] = val
	end
		sg.message('游戏将于' .. data.start_time .. '秒后将进入|cffffdd00无尽模式|r',5)
		sg.ex_mode = true
		--无尽难度系数默认为噩梦
		sg.difficult = 4
		wave = 0
		game_start()
	else
		sg.message('游戏将于5秒后|cffffdd00结束|r',5)
		ac.wait(5,function()
			for i = 1,sg.max_player do
	    		ac.player(i):remove('胜利','胜利！')
    		end
			ac.game:pause()
	    end)
	end
end)

--作弊
if sg.test then
	ac.game:event('玩家-聊天', function (_, _, str)
		if string.find(str,'-波数 ',1,5) then
			local gsu =  sg.split(str,'-波数 ')
			ac.game:eventNotify('地图-选择波数', tonumber(gsu[1]))
		end
	end)
end

function sg.get_wave()
	return wave
end