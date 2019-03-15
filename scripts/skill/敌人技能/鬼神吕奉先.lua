local mt = ac.skill['吕布-鬼神降临']

local start = ac.point(-9400,320)
local direct = 180

function mt:onAdd()
	local hero = self:getOwner()
	self.trg = hero:event('单位-即将受到伤害',function(_,_,damage)
		if self:getCd() == 0 and damage:get_currentdamage() > hero:get('生命') - hero:get('生命上限') * self.casthp/100 then
			hero:cast(self:getName(),damage.target:getPoint())
			hero:set('生命',hero:get('生命上限') * self.casthp/100)
			return false
		end
	end)
end

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'stand ready',true)
	self.buff = hero:addBuff '无敌'
	{
		time = 0,
	}
	local point = hero:getPoint()
	local time = self.castStartTime
	self.load = sg.load_bar({target = point,time = time})
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'spell slam')
	local point = hero:getPoint()
	ac.effect {
	    target = point,
	    size = 2,
	    model = [[Abilities\Spells\NightElf\Taunt\TauntCaster.mdl]],
	    time = 1,
	}
	local color = 1
	ac.timer(0.05,20,function()
		color = color - 0.05
		sg.set_color(hero,{a = color})
	end)
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local skill = self
	hero:blink(start)
	local u = hero:createUnit('吕布-代打',start,direct)
	sg.animation(u,'stand ready',true)
	u:addHeight(120)
	ac.effect {
	    target = start,
	    model = [[Objects\Spawnmodels\Naga\NagaDeath\NagaDeath.mdl]],
	    time = 1,
	}
	ac.wait(self.birthtime,function()
		ac.effect {
		    target = start,
		    size = 2,
		    model = [[Objects\Spawnmodels\Naga\NagaDeath\NagaDeath.mdl]],
		    time = 1,
		}
		local size = 0
		ac.timer(0.02,50,function()
			if not self.is_stop then
				size = size + 0.12
				sg.scale(u,size)
			end
		end)
	end)
	local wait = self.birthtime + 2
	--三英助战
	local npc = {}
	local npc_point = start - {direct + 12,1000}
	ac.wait(wait,function()
		if not self.is_stop then
			local name = {'张飞','刘备','关羽'}
			for i = 1,3 do
				local angle = direct - 150 + 75 * i
				local p = npc_point - {angle,150}
				npc[i] = sg.ally_player:createUnit('吕布-' .. name[i],p,angle + 180)
				ac.effect {
				    target = p,
				    model = [[Abilities\Spells\Human\MassTeleport\MassTeleportTarget.mdl]],
				    time = 2,
				}
				sg.message('|cffffff00'.. name[i] .. '前来助战！|r',3)
			end
		end
	end)
	wait = wait + 2
	--方天画戟伤害
	local function npc_damage()
		ac.effect {
		    target = npc_point,
		    model = [[effect\psiwave.mdx]],
		    time = 1,
		}
		for i = 1,3 do
			hero:damage
			{
			    target = npc[i],
			    damage = npc[i]:get('生命上限') * self.npc_damage/100,
			    damage_type = '真实',
			    skill = self,
			}
		end
	end
	--代打攻击
	local timer = {}
	ac.wait(wait,function()
		if not self.is_stop then
			sg.animation(u,1,'stand ready')	
			sg.animation(npc[1],8)
			sg.animation(npc[2],'spell')
			sg.animation(npc[3],0)
			ac.wait(0.5,function()
				sg.message('迅速击破方天画戟，保护三英！',5)
				for i = 1,3 do
					npc[i]:speed(0)
				end
				npc_damage()
				timer[1] = ac.loop(self.pulse,npc_damage)
				--反复招架
				local index = 1
				timer[2] = ac.loop(0.1,function()
					index = -index
					u:speed(index)
					ac.effect {
					    target = npc_point,
					    size = 3,
					    model = [[Abilities\Weapons\FarseerMissile\FarseerMissile.mdl]],
					    time = 0,
					}
				end)
				--方天画戟出现
				local weapon = hero:createUnit('吕布-方天画戟',npc_point,0)
				--攻击结束，击破方天画戟或时间过长触发
				local is_finish = false
				local function finish()
					if is_finish == false then
						is_finish = true
						u:speed(1)
						if timer[1] then
							timer[1]:remove()
						end
						if timer[2] then
							timer[2]:remove()
						end
						if weapon:isAlive() then
							weapon:remove()
						end
						--如果三英存活，则去旁边给玩家开罩子
						for i = 1,3 do
							npc[i]:speed(1)
						end
						if npc[1]:isAlive() then
							sg.message('成功招架住吕布的攻击！',5)
							local effect = {
								[[Abilities\Spells\Human\HolyBolt\HolyBoltSpecialArt.mdl]],
								[[effect\TheHolyBomb.mdx]],
								[[Abilities\Spells\Human\HolyBolt\HolyBoltSpecialArt.mdl]],
							}
							for i = 1,3 do
								local unit = npc[i]
								local mover = hero:moverLine
								{
									mover = unit,
									angle = unit:getFacing() - 180,
									distance = 500,
									speed = 1000,
								}
								ac.wait(1.5,function()
									if not self.is_stop then
										sg.animation(unit,'attack')
										local mover = hero:moverLine
										{
											model = [[Abilities\Spells\Human\HolyBolt\HolyBoltSpecialArt.mdl]],
											start = unit:getPoint(),
											target = npc_point,
											speed = 1000,
										}
										function mover:onRemove()
											if not self.is_stop then
												ac.effect {
												    target = npc_point,
												    size = 5,
												    model = effect[i],
												    time = 1,
												}
												if i == 1 then
													--赋予周围玩家无敌
													for _,u in ac.selector()
													    : inRange(npc_point,skill.area)
													    : isAlly(unit)
													    : ofNot '建筑'
													    : ipairs()
													do	
														u:addBuff '无敌' 
														{
															time = skill.ready,
														}
													end
												end
											end
										end
									end
								end)
							end
						else
							sg.message('|cffffff00刘备：吾之大义...尚未...|r',5)
							sg.message('|cffffff00关羽：到此为止了吗...|r',5)
							sg.message('|cffffff00张飞：居然要在这里倒下...|r',5)
						end
						timer[4] = ac.wait(self.ready,function()
							sg.animation(u,'attack slam','stand ready')
							--秒杀大招
							ac.wait(0.5,function()
								if not self.is_stop then
									local distance = 0
									timer[5] = ac.timer(0.1,10,function()
										distance = distance + 1
										local a = math.random(360)
										for i = 1,distance + 2 do
											local p = npc_point - {i * 360/(distance + 2) + a,distance * 200}
											ac.effect {
											    target = p,
											    model = [[effect\psiwave.mdx]],
											    time = 1,
											}
											ac.effect {
											    target = p,
											    model = [[effect\Lightning Boom.mdx]],
											    zScale = 0.5,
											    speed = 2,
											    time = 1,
											}
										end
									end)
									for _,u in ac.selector()
									    : inRange(npc_point,skill.area)
									    : isEnemy(hero)
									    : ofNot '建筑'
									    : ipairs()
									do	
										hero:kill(u)
									end
								end
							end)
							timer[5] = ac.wait(self.rest,function()
								if not self.is_stop then
									if npc[1]:isAlive() then
										for i = 1,3 do
											ac.effect {
											    target = npc[i]:getPoint(),
											    model = [[Abilities\Spells\Human\MassTeleport\MassTeleportCaster.mdl]],
											    time = 2,
											}
											npc[i]:remove()
										end
										sg.message('三英元气大伤，先行撤退！',5)
									end
									--代打溜了
									local size = 6.0
									sg.animation(u,'stand')
									timer[6] = ac.timer(0.02,50,function()
										size = size - 0.12
										sg.scale(u,size)
										if size < 0.12 then
											ac.effect {
											    target = start,
											    size = 2,
											    model = [[Objects\Spawnmodels\Naga\NagaDeath\NagaDeath.mdl]],
											    time = 1,
											}
											u:remove()
											--本体回来挨打										
											ac.wait(skill.birthtime,function()
												hero:blink(npc_point)
												local color = 0
												if not self.is_stop then
													timer[7] = ac.timer(0.05,20,function()
														color = color + 0.05
														sg.set_color(hero,{a = color})
														if color > 0.95 then
															skill:stop()
														end
													end)
												end
											end)
										end
									end)
								end
							end)
						end)
					end
				end
				weapon:event('单位-死亡',function()
					finish()
				end)
				self.weapon = weapon
				timer[3] = ac.wait(self.time,function()
					finish()
				end)
			end)
		end
	end)
	self.dummy = u
	self.npc = npc
	self.timer = timer
end

function mt:onCastStop()
	local hero = self:getOwner()
	self.is_stop = true
	if self.buff then
		self.buff:remove()
	end
	sg.set_color(hero,{a = 1})
	if self.dummy then
		self.dummy:remove()
	end
	for i = 1,3 do
		if self.npc[i] then
			self.npc[i]:remove()
		end
	end
	for _,timer in pairs(self.timer) do
		if timer then
			timer:remove()
		end
	end
	if self.weapon then
		self.weapon:remove()
	end
end

function mt:onRemove()
	if self.trg then
		self.trg:remove()
	end
end

local mt = ac.skill['吕布-雷鸣咆哮']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'stand ready',true)
	local point = hero:getPoint()
	local time = self.castStartTime
	self.load = sg.load_bar({target = point,time = time})
	ac.effect {
	    target = point,
	    model = [[Abilities\Spells\Human\FlameStrike\FlameStrikeTarget.mdl]],
	    time = 3,
	}
end

function mt:onCastChannel()
	local gap = self.gap
	local list = {
		[1] = {p = ac.point(-11000,1700),a = 0},
		[2] = {p = ac.point(-8550,1700),a = 270},
	}
	local index = math.random(#list)
	local direct = list[index].a
	local p = list[index].p
	local p2 = p - {direct - 90,gap}
	local hero = self:getOwner()
	sg.animation(hero,'spell')
	ac.effect {
	    target = hero:getPoint(),
	    size = 2,
	    model = [[Abilities\Spells\Other\HowlOfTerror\HowlCaster.mdl]],
	    time = 1,
	}
	local count = math.ceil(self.count/2)
	local area = self.area
	local wait = self.wait
	local function create_fire(start)
		local pulse = self.pulse
		for i = 1,count do
			local target = start - {direct - 90,gap * 2 * (i - 1)}
			ac.effect {
			    target = target,
			    size = area/350,
			    speed = 1.8/(wait),
			    model = [[effect\calldown_4.mdx]],
			    height = 20,
			    time = wait,
			    skipDeath = true,
			}
		end
		local distance = 0
		ac.wait(wait - pulse,function()
			local step = self.step
			ac.timer(pulse,self.step_count,function()
				for i = 1,count do
					local target = start - {direct - 90,gap * 2 * (i - 1)}
					target = target - {direct,distance}
					ac.effect {
					    target = target,
					    size = area/400,
					    model = [[effect\psiwave.mdx]],
					    time = 1,
					}
					ac.effect {
					    target = target,
					    model = [[effect\Lightning Boom.mdx]],
					    xScale = area/200,
					    yScale = area/200,
					    zScale = area/400,
					    speed = 2,
					    time = 1,
					}
					for _, u in ac.selector()
					    : inRange(target,area)
					    : isEnemy(hero)
					    : ofNot '建筑'
					    : ipairs()
					do
						local damage = self.damage * sg.get_allatr(hero)
						hero:damage
						{
						    target = u,
						    damage = damage,
						    damage_type = self.damage_type,
						    skill = self,
						}
						u:addBuff '麻痹'
						{
							self.stun,
						}
					end
				end
				distance = distance + step
			end)
		end)
	end
	create_fire(p)
	ac.wait(wait/2,function()
		create_fire(p2)
	end)
end

function mt:onCastStop()
	if self.load then
		self.load:remove()
	end
end