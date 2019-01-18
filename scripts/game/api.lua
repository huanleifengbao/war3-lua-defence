--全体玩家计时器窗口
local timerdialog = {}
function sg.set_timer_title(key,name)
	local timer = timerdialog[key]
	if timer then
		for i = 1,#timer do
			timer[i]:setTitle(name)
		end
	end
end
function sg.set_timer_time(key,time)
	local timer = timerdialog[key]
	if timer then
		for i = 1,#timer do
			timer[i]:setTimer(time)
		end
	end
end
function sg.remove_timer(key)
	local timer = timerdialog[key]
	if timer then
		for i = #timer,1,-1 do
			timer[i]:remove()
		end
	end
	timerdialog[key] = nil
end
local function create_timer(name,time)
	local tbl = {}
	for i = 1,sg.max_player do
	    local player = ac.player(i)
	    local dialog = player:timerDialog(name,time)
	    table.insert(tbl,dialog)
	end
	return tbl
end
function sg.create_timer(key,name,time)
	if timerdialog[key] then
		local timer = timerdialog[key][1]
		if timer and timer._removed ~= true then		
			sg.set_timer_title(key,name)
			sg.set_timer_time(key,time)
		else
			timerdialog[key] = create_timer(name,time)
		end
	else
		timerdialog[key] = create_timer(name,time)
	end
end