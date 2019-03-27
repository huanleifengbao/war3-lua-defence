local ai_groups  = {}
local unit_groups = {}
local actions = {}
local pulse = 1

local timer = ac.loop(pulse,function()
	for i = #unit_groups,1,-1 do
		local u = unit_groups[i]
		if not u:isAlive() then
			table.remove(unit_groups,i)
		else
			for _,action in ipairs(actions) do
				if action(u) ~= true then
					break
				end
			end
		end
	end
end)

function sg.add_ai_skill(u)
	ai_groups[u] = {}
	for i = 1,4 do
		local skill = u:findSkill(i,'技能')
		if skill and skill.passive ~= 1 then
			table.insert(ai_groups[u],skill)
		end
	end
	table.insert(unit_groups,u)
end

local function add_action(f)
	table.insert(actions,f)
end

--被控制时，暂时不执行逻辑
local function check_stun(u)
	if u:hasRestriction '晕眩' or u:hasRestriction '硬直' then
		return false
	else
		return true
	end
end

--寻找周围敌人放技能
local function check_skill(u)
	for _,skill in pairs(ai_groups[u]) do
		local casthp = skill.casthp
		if not casthp then
			casthp = 1
		else
			casthp = casthp/100
		end
		if skill:getCd() == 0 and u:get '生命'/u:get '生命上限' <= casthp then
			local target
			for _,t in ac.selector()
			    : inRange(u:getPoint(),skill.range)
			    : isEnemy(u)
			    : ofNot '建筑'
			    : isVisible(u)
			    : ipairs()
			do
				target = t				
				break
			end
			if target then
				if skill.targetType == '点' then
					target = target:getPoint()
				end
				u:cast(skill:getName(),target)
				break
			end
		end
	end
end

add_action(check_stun)
add_action(check_skill)