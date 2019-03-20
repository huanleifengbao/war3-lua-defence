local mt = ac.skill['恐怖利刃-魔化']

function mt:onAdd()
	local hero = self:getOwner()
	self.trg = hero:event('单位-受到伤害',function(_,_,damage)
		local cool = false
		if cool == false and hero:get('生命') <= hero:get('生命上限') * self.casthp/100 then
			hero:cast(self:getName(),hero:getPoint())
			cool = true
			ac.wait(1,function()
				cool = false
			end)
		end
	end)
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'spell slam')
end

function mt:onCastShot()
	local hero = self:getOwner()
	sg.animation(hero,'morph')
end

function mt:onCastFinish()
	local hero = self:getOwner()
	hero:addBuff '恐怖利刃-魔化'
	{
		time = 0,
	}
	self.trg:remove()
end

local mt = ac.buff['恐怖利刃-魔化']

function mt:onAdd()
	local hero = self:getOwner()
	jass.AddUnitAnimationProperties(hero._handle, 'alternate', true)
	self.buff = hero:addBuff '魔化'
	{
		time = 0,
	}
end

function mt:onRemove()
	local hero = self:getOwner()
	jass.AddUnitAnimationProperties(hero._handle, 'alternate', false)
	self.buff:remove()
end

local mt = ac.skill['恐怖利刃-魂断']

function mt:onAdd()
	local hero = self:getOwner()
	self.trg = hero:event('单位-受到伤害',function(_,_,damage)
		if self:getCd() == 0 and hero:get('生命') <= hero:get('生命上限') * self.casthp/100 then
			local target = damage.source
			if target:get('生命')/target:get('生命上限') > hero:get('生命')/hero:get('生命上限') then
				hero:cast(self:getName(),target)
			end
		end
	end)
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'spell alternate channel',true)
end

function mt:onCastShot()
	local hero = self:getOwner()
	local target = self:getTarget()
	local hp = math.max(hero:get('生命')/hero:get('生命上限'),self.minhp/100)
	hero:set('生命',hero:get('生命上限') * math.max(target:get('生命')/target:get('生命上限'),self.minhp/100))
	target:set('生命',target:get('生命上限') * hp)
	local lighting = ac.lightning {
	    source = hero,
	    target = target,
	    model = 'SPLK',
	    sourceHeight = 200,
	    sourceHeight = 100,
	}
	hero:particle([[effect\tx003.mdx]],'origin')()
	target:particle([[effect\tx003.mdx]],'origin')()
	ac.wait(0.5,function()
		lighting:remove()
	end)
end