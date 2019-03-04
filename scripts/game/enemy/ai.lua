local ai_groups  = {}
local actions = {}
local pulse = 0.5

local timer = ac.loop(pulse,function()
	for u,_ in pairs(ai_groups) do
		if not u:isAlive() then
			ai_groups[u].trg:remove()
			ai_groups[u] = nil
		else
			for _,action in ipairs(actions) do
				if action(u) ~= true then
					break
				end
			end
		end
	end
end)

--命令单位攻击移动到指定点
local function attack_move(u)
	local line = ai_groups[u].line
	local index = ai_groups[u].index
	if index <= #line then
		u:attack(line[index])
	end
end

local y1 = -7050
local x2 = 6950
local y2 = -9500

function sg.add_ai(u)
	--生成进攻路径点
	local start = u:getPoint()
	local x0,y0 = start:getXY()
	local x1
	if x0 - x2 > 500 then
		x1 = 7825
	elseif x0 - x2 < -500 then
		x1 = 6175
	else
		x1 = 7025
	end
	local p = {
		[1] = ac.point(x1,y1),
		[2] = ac.point(x2,y2),
	}
	--根据当前位置确定第一个进攻点
	local index = #p + 1
	for i = #p,1,-1 do
		local _,y = p[i]:getXY()
		if y0 > y then
			index = i
		else
			table.remove(p,p[i])
		end
	end
	ai_groups[u] = {
		line = p,
		index = index,
		last_point = start,
		idle = 0,
		is_attack = false,
	}
	local timer
	local trg = u:event('单位-攻击出手', function (_, _, target, damage, mover)
		if timer then
			timer:remove()
		end
		ai_groups[u].is_attack = true
		timer = ac.wait(3,function()
			if ai_groups[u] then
				ai_groups[u].is_attack = false
			end
		end)
	end)
	ai_groups[u].trg = trg
	ai_groups[u].timer = timer
	attack_move(u)
end

local function add_action(f)
	table.insert(actions,f)
end

--被控制时，暂时不执行逻辑，并在控制结束后继续移动
local function check_stun(u)
	if u:hasRestriction '硬直' then
		ai_groups[u].stun = true
		return false
	else
		if ai_groups[u].stun == true then
			ai_groups[u].stun = nil
			attack_move(u)
		end
		return true
	end
end

--确定当前的移动点
local function check_point(u)
	local line = ai_groups[u].line
	local index = ai_groups[u].index
	local target = line[index]
	if index <= #line then
		--和目标点距离小于一定值后，转向下个目标点
		if u:getPoint() * target <= 200 then
			ai_groups[u].index = index + 1
			attack_move(u)
		end
		return false
	end
	return true
end

--若长时间未产生位移且不在攻击状态，则使其继续向下个点移动
local idle_time = 5
local function check_move(u)
	local data = ai_groups[u]
	local point = data.last_point
	local now_point = u:getPoint()
	data.last_point = now_point
	--判断是否在位移状态
	local stop = point * now_point <= 1
	--判断是否是在进行攻击
	local attack = data.is_attack
	if stop and not attack then
		attack_move(u)
	end
end

add_action(check_stun)
add_action(check_point)
add_action(check_move)