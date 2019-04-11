function sg.load_bar(data)
	local info = {
	    model = [[effect\Progressbar.mdx]],
	    size = 2,
	    height = 500,
	    time = 1,
	}
	for k,v in pairs(data) do
		info[k] = v
	end
	if not info.target then
		error('没有传入必要参数')
		return
	end
	local load = ac.effect {
	    target = info.target,
	    model = info.model,
	    speed = 1/info.time,
	    size = info.size,
	    height = info.height,
	    time = info.time,
	    skipDeath = true,
	}
	return load
end
require 'skill.敌人技能.华雄'
require 'skill.敌人技能.徐荣'
require 'skill.敌人技能.高顺'
require 'skill.敌人技能.远吕智'
require 'skill.敌人技能.张宝'
require 'skill.敌人技能.张梁'
require 'skill.敌人技能.张角'
require 'skill.敌人技能.鬼神吕奉先'
require 'skill.敌人技能.锻造大师'
require 'skill.敌人技能.恐怖利刃'
require 'skill.敌人技能.孔秀'
require 'skill.敌人技能.韩富'
require 'skill.敌人技能.孟坦'
require 'skill.敌人技能.卞喜'
require 'skill.敌人技能.王植'
require 'skill.敌人技能.秦琪'

local mt = ac.skill['BOSS-穿甲攻击']

function mt:onAdd()
	local hero = self:getOwner()
	self.trg = hero:event('单位-即将造成伤害',function(_,_,damage)
		if damage:isCommonAttack() == true then
			local target = damage.target
			local dam = target:get '生命上限' * self.damage/100
			hero:damage
			{
			    target = target,
			    damage = dam,
			    damage_type = self.damage_type,
			    skill = self,
			}
		end
	end)
end

function mt:onRemove()
	self.trg:remove()
end