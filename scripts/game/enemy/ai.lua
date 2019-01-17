local ai_groups  = {}
local actions = {}

local timer = ac.loop(1,function()
	for u,_ in pairs(ai_groups) do
		if u._removed == true then
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

function sg.add_ai(u)
	--生成进攻路径点
	local start = u:getPoint()
	local x0,y0 = start:getXY()
	local p = {
		[1] = ac.point(x0,-4300),
		[2] = ac.point(6950,-5700),
		[3] = ac.point(6950,-9500),
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
	}
end

local function add_action(f)
	table.insert(actions,f)
end

--判断单位是否产生了位移，有的话则暂时不执行移动逻辑
local function check_move(u)
	local point = ai_groups[u].point
	local now_point = u:getPoint()
	ai_groups[u].point = now_point
	if not point or point * now_point <= 1 then
		return true
	else
		return false
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
		end
	end
	return true
end

--命令单位攻击移动到指定点
local function attack_move(u)
	local line = ai_groups[u].line
	local index = ai_groups[u].index
	if index <= #line then
		local target = line[index]
		u:attack(target)
	end
	return true
end

add_action(check)
add_action(check_point)
add_action(attack_move)