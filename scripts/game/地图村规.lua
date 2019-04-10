sg.ally_player = ac.player(10)	--基地玩家
sg.creeps_player = ac.player(11)	--野怪玩家
sg.enemy_player = ac.player(12)	--刷怪玩家
sg.max_player = 6
for i = 1, sg.max_player do
    ac.player(10):alliance(ac.player(i), '结盟', true)
    ac.player(i):alliance(ac.player(10), '结盟', true)
end
sg.enemy_player:alliance(sg.creeps_player, '结盟', true)
sg.creeps_player:alliance(sg.enemy_player, '结盟', true)

--增加三维并增加对应属性
local function add_atr(hero,name,count)
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
ac.game:event('单位-属性变化', function (_, hero, name, count)
	if hero:isHero() then
		add_atr(hero,name,count)
	end
end)

--升级三维
ac.game:event('地图-选择英雄', function (_, hero)
	hero:event('单位-升级', function ()
		hero:add('力量', (hero:level() * 0.1) + 20)
		hero:add('敏捷', (hero:level() * 0.1) + 20)
		hero:add('智力', (hero:level() * 0.1) + 20)
	end)
	hero:event('单位-降级', function ()
		hero:add('力量', - (hero:level() * 0.1) + 20)
		hero:add('敏捷', - (hero:level() * 0.1) + 20)
		hero:add('智力', - (hero:level() * 0.1) + 20)
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
local atr = {'力量','敏捷','智力'}
ac.game:event('单位-创建', function (_, unit)
	local player = unit:getOwner()
	if player == sg.creeps_player or player == sg.enemy_player then
		local num = dif_tbl[sg.difficult]
		for _,name in ipairs(atr) do
			add_atr(unit,name,unit:get(name))
		end
		ac.wait(0,function()			
			unit:set('生命上限',unit:get('生命上限') * num)
			unit:set('攻击',unit:get('攻击') * num)
			for _,name in ipairs(atr) do
				unit:set(name,unit:get(name) * num)
			end
		end)
	end
end)

--禁止攻击友军
ac.game:event('单位-发布命令',function(_, unit, ID, target)
	if ID == '攻击' and target.type == 'unit' and not unit:isEnemy(target) then
		unit:walk(target)
	end
end)

--可见度
ac.game:fog(false)
ac.game:mask(true)

function sg.off_fog(rect)
	for i = 1,sg.max_player do
		ac.player(i):setFog('可见',rect)
	end
end

local enemy = sg.enemy_player
local creeps = sg.creeps_player
--选人区
local rect = ac.rect(-800,-11200,3400,-5500)
sg.off_fog(rect)
--刷怪区
rect = ac.rect(5000,-6000,9000,4200)
sg.off_fog(rect)
enemy:setFog('可见',rect)
--基地
rect = ac.rect(3700,-11200,10500,-6000)
sg.off_fog(rect)
enemy:setFog('可见',rect)
--练功房
rect = ac.rect(4300,4700,11000,11700)
sg.off_fog(rect)
creeps:setFog('可见',rect)
--专属升级区
rect = ac.rect(9700,-4625,11100,4400)
sg.off_fog(rect)
creeps:setFog('可见',rect)
--觉醒挑战
rect = ac.rect(-7600,-5150,5000,-1900)
sg.off_fog(rect)
creeps:setFog('可见',rect)
--锻造石
rect = ac.rect(-350,-1900,3000,11500)
sg.off_fog(rect)
creeps:setFog('可见',rect)
--锻造大师
rect = ac.rect(-11600,10100,-9100,11800)
sg.off_fog(rect)
creeps:setFog('可见',rect)

--tips
local tips = {
	'前期优先练功房升级，专属武器经验刷满，前往野外挑战升级专属武器',
	'争取在第一波怪来临之前，升满新手装备',
	'基地很脆弱，一不小心就炸了',
	'进攻boss拥有各种蓄力范围技能，记得躲避',
	'抽奖一时爽，一直抽一直爽，多出的战魂可以给队友哦',
}

ac.game:event('地图-选择难度', function()
	local now_tips = sg.copytable(tips)
	ac.timer(30,40,function()
		local index = math.random(#now_tips)
		sg.message(now_tips[index],10)
		table.remove(now_tips,index)
		if #now_tips == 0 then
			now_tips = sg.copytable(tips)
		end
	end)
end)

--音乐
sg.last_music = [[resource\music\s1.mp3]]
ac.wait(0,function()
	ac.game:music(sg.last_music)
end)