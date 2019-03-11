local attack_range = 300

local mt = ac.skill['远吕智-灾厄的三重奏']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'stand ready',true)
	local time = self.castStartTime
	local point = hero:getPoint()
	self.load = ac.effect {
	    target = point,
	    model = [[effect\Progressbar.mdx]],
	    speed = 1/time,
	    size = 2,
	    height = 500,
	    time = time,
	    skipDeath = true,
	}
	local area = self.area
	ac.effect {
	    target = point,
	    size = area/55,
	    zScale = 0.1,
	    height = 20,
	    model = [[effect\Blind Aura.mdx]],
	    time = time,
	}
	ac.wait(self.pulse,function()
		ac.effect {
		    target = point,
		    size = area/70,
		    zScale = 0.1,
		    height = 20,
		    model = [[effect\Cosmic Slam.mdx]],
		    time = time,
		}
		ac.effect {
		    target = point,
		    size = 10,
		    height = 300,
		    model = [[Abilities\Spells\Human\MagicSentry\MagicSentryCaster.mdl]],
		    time = time + self.castChannelTime,
		}		
	end)
end

function mt:onCastChannel()
	local hero = self:getOwner()
	local point = hero:getPoint()
	hero:speed(1.5/self.castChannelTime)
	sg.animation(hero,'spell slam')
	local area = self.area
	ac.effect {
	    target = point,
	    size = area/250,
	    height = 20,
	    model = [[effect\BloodSlam.mdx]],
	    time = 1,
	}
	ac.wait(self.pulse,function()
		ac.effect {
		    target = point,
		    size = area/40,
		    zScale = 0.1,
		    height = 20,
		    model = [[effect\Blood Explosion.mdx]],
		    time = 1,
		}
	end)
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	sg.animation(hero,'spell')
	hero:speed(1)
	local area = self.area
end

function mt:onCastStop()
	if self.load then
		self.load:remove()
	end
	local hero = self:getOwner()
	hero:speed(1)
end