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
require 'skill.敌人技能.张角'
require 'skill.敌人技能.鬼神吕奉先'