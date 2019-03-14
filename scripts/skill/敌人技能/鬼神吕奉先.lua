local mt = ac.skill['吕布-鬼神降临']

local start = ac.point(-9400,320)
local direct = 180

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
			size = size + 0.12
			sg.scale(u,size)
		end)
	end)
	local wait = self.birthtime + 2
	--三英助战
	local npc = {}
	local npc_point = start - {direct + 12,1000}
	ac.wait(wait,function()
		local name = {'张飞','刘备','关羽'}
		for i = 1,3 do
			local angle = direct - 150 + 75 * i
			local p = npc_point - {angle,100}
			npc[i] = sg.ally_player:createUnit(name[i],p,angle + 180)
			ac.effect {
			    target = p,
			    model = [[Abilities\Spells\Human\MassTeleport\MassTeleportTarget.mdl]],
			    time = 2,
			}
			npc[i]:set('生命恢复',0)
			sg.message('|cffffff00'.. name[i] .. '前来助战！|r',3)
			npc[i]:event('单位-死亡',function()
				npc[i]:speed(1)
			end)
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
				    model = [[Abilities\Spells\Items\AIlb\AIlbSpecialArt.mdl]],
				    time = 1,
				}
			end)
			--攻击结束
			timer[3] = ac.wait(self.time,function()
				u:speed(1)
				if timer[1] then
					timer[1]:remove()
				end
				if timer[2] then
					timer[2]:remove()
				end
				local time = self.rest
				self.load = sg.load_bar({target = start,time = time})
				timer[4] = ac.wait(time,function()
					sg.animation(u,'attack slam','stand ready')	
				end)
			end)
		end)
	end)
end