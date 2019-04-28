local pick_mark = {}
local origin = ac.point(1460,-8770)
--英雄,x,y,面向角度
local hero_data = {
	--普通英雄
	['随机英雄'] = {point = ac.point(1460,-8770)},
	['关羽'] = {point = ac.point(1716,-9026),Aghanim = '青龙偃月刀'},	-- +256 +256
	['张飞'] = {point = ac.point(1716,-8514),Aghanim = '破军蛇矛'},	-- +256 -256
	['黄忠'] = {point = ac.point(1972,-8770),Aghanim = '破邪旋风斩'},	-- +512 +0
	['诸葛亮'] = {point = ac.point(1204,-9026),Aghanim = '朱雀羽扇'},	-- -256 +256
	['星彩'] = {point = ac.point(1204,-8514),Aghanim = '煌天'},	-- -256 -256
	['孙尚香'] = {point = ac.point(948,-8770),Aghanim = '日月乾坤剑'},	-- -512 +0
	--积分英雄
	['马超'] = {point = ac.point(1460,-9282),score = {['杀敌'] = 1000},Aghanim = '龙雷骑尖'},
	--付费英雄
	['刘备'] = {point = ac.point(692,-8130),shop = '传奇三国-刘备',Aghanim = '真黄龙剑'},
	['貂蝉'] = {point = ac.point(1076,-8130),shop = '传奇三国-貂蝉',Aghanim = '金丽玉霞'},
	['吕布'] = {point = ac.point(1460,-8130),shop = '传奇三国-吕布',Aghanim = '无双方天戟'},
	['司马懿'] = {point = ac.point(1844,-8130),shop = '传奇三国-司马懿',Aghanim = '穷奇羽扇'},
	['赵云'] = {point = ac.point(2228,-8130),shop = '传奇三国-赵云',Aghanim = '豪龙胆'},
}

--平凡的积分英雄,
--local score_hero_tbl = {
--	{'马超', 1460, -9282, 270, 1000},	-- +0 +512
--}

--场景特效
ac.effect{
	target = origin,
	model = [[effect\galaxy.mdx]],
	size = 5,
	speed = 2,
	heitht = -500,
}
--ac.effect{
--	target = origin,
--	model = [[effect\antimagiczone.mdx]],
--	xScale = 5,
--	yScale = 5,
--	zScale = 0.01,
--	heitht = -500,
--}

--高贵的传奇英雄(随机不到)
--local Legend_hero_tbl = {
--	{'刘备', 692, -8130, 270},
--	{'貂蝉', 1076, -8130, 270},
--	{'吕布', 1460, -8130, 270},
--	{'司马懿', 1844, -8130, 270},
--	{'赵云', 2228, -8130, 270},    
--}

--local Aghanim = {
--    ['刘备'] = '真黄龙剑',
--    ['关羽'] = '青龙偃月刀',
--    ['张飞'] = '破军蛇矛',
--    ['黄忠'] = '破邪旋风斩',
--    ['诸葛亮'] = '朱雀羽扇',
--    ['吕布'] = '无双方天戟',
--    ['赵云'] = '豪龙胆',
--    ['司马懿'] = '穷奇羽扇',
--    ['星彩'] = '煌天',
--    ['貂蝉'] = '金丽玉霞',
--    ['孙尚香'] = '日月乾坤剑',
--    ['马超'] = '龙雷骑尖',
--}

for name,data in pairs(hero_data) do
	local unit = ac.player(16):createUnit(name,data.point,270)
	ac.effect{
		target = unit:getPoint(),
		model = [[buildings\other\CircleOfPower\CircleOfPower.mdl]],
		size = 2,
	}
end
--local hero_mark = {}
--local Legend_hero_mark = {}
--local score_hero_mark = {}
--for i = 1, #hero_tbl do
--	local name = hero_tbl[i][1]
--    local unit = ac.player(16):createUnit(name, ac.point(hero_tbl[i][2], hero_tbl[i][3]), hero_tbl[i][4])
--    if name ~= '随机英雄' then
--    	table.insert(hero_mark, unit)
--	end
--	ac.effect{
--		target = unit:getPoint(),
--		model = [[buildings\other\CircleOfPower\CircleOfPower.mdl]],
--		size = 2,
--	}
--end
--for i = 1, #score_hero_tbl do
--    local unit = ac.player(16):createUnit(Legend_hero_tbl[i][1], ac.point(Legend_hero_tbl[i][2], Legend_hero_tbl[i][3]), Legend_hero_tbl[i][4])
--    table.insert(score_hero_mark, unit)
--    ac.effect{
--		target = unit:getPoint(),
--		model = [[buildings\other\CircleOfPower\CircleOfPower.mdl]],
--		size = 2,
--	}
--end
--for i = 1, #Legend_hero_tbl do
--    local unit = ac.player(16):createUnit(Legend_hero_tbl[i][1], ac.point(Legend_hero_tbl[i][2], Legend_hero_tbl[i][3]), Legend_hero_tbl[i][4])
--    table.insert(Legend_hero_mark, unit)
--    ac.effect{
--		target = unit:getPoint(),
--		model = [[buildings\other\CircleOfPower\CircleOfPower.mdl]],
--		size = 2,
--	}
--end

--判断积分是否足够
local function score(player,name)
	local data = hero_data[name].score
	if data then
   		for key,num in pairs(data) do
       		if tonumber(player:get_score(key)) < num then
	       		return false,key,num
       		end
   		end
	end
	return true
end
--判断是否购买
local function shop(player,name)
	local data = hero_data[name].shop
	if data and player:get_shop_info(data) <= 0 then
		return false,data
	end
	return true
end

sg.family = {}
ac.game:event('地图-选择难度', function ()
    for i = 1,sg.max_player do
        ac.player(i):add('金币', 50000)
        ac.player(i):event('玩家-选中单位', function (trg, player, unit)
            if unit:getOwner():id() == 16 and not player:getHero() then
                if pick_mark[i] == unit then
	               	local name = unit:getName()
	               	--当你点击平凡的积分英雄时
	               	local ressult,key,num = score(player,name)
	               	if ressult == false then
						player:message('|cffffff00您的|cffff00ff'..key..'|r|cffffff00不足|r|cffffaa00'..num..'|r，|cffffff00不能选择|r', 5)
						return
		            end
		            --当你点击高贵的付费英雄时
		            ressult,key = shop(player,name)
		            if ressult == false then
			            player:message('|cffffff00您未购买|cffff00ff英雄|cffffff00:|cffffaa00'..key..'|r', 5)
						return
		            end
		            --if sg.isintable(Legend_hero_mark,unit) then
			           -- local hero_name = '传奇三国-' .. name
			           -- if player:get_shop_info(hero_name) <= 0 then
				          --  player:message('|cffffff00您未购买|cffff00ff'..'英雄'..'|cffffff00:|cffffaa00'..hero_name..'|r', 5)
				          --  return
			           -- end
		            --end
                    trg:remove()
                    --特殊处理随机英雄
                    local random = false
                    if name == '随机英雄' then
	                    --创建一个随机池
	                    local hero_mark = {}
	                    for name,_ in pairs(hero_data) do
		                    if score(player,name) == true and shop(player,name) == true then
			                    table.insert(hero_mark,name)
		                    end
	                    end
	                    random = true
                        unit = hero_mark[math.random(#hero_mark)]                        
                        name = unit:getName()
                    else
	                    random = false
                    end
       --             for i = 1,#hero_mark do
	      --              if unit == hero_mark[i] then
							--table.remove(hero_mark,i)
							--break
	      --              end
       --             end
       --             unit:remove()              
                    for _ = 1, 1 do
                        sg.player_count = sg.player_count + 1
                        local start_p = ac.point(7044, -8792)
                        local hero = player:createUnit(name, start_p, 270)
                        player:addHero(hero)
                        hero:bagSize(6)
                        hero:addSkill('@命令', '技能', 12)
                        hero:addSkill('传送', '技能', 4)
                        local skill = hero:addSkill('1级威望', '技能', 5)
                        hero:userData('威望技能', skill)
                        local skill = hero:addSkill('0阶觉醒', '技能', 6)
                        hero:userData('觉醒技能', skill)
                        hero:userData('战魂技能', {})
                        hero:userData('坐骑技能', {})
                        hero:addSkill('战魂魔法书', '技能', 7)
                        hero:addSkill('坐骑魔法书', '技能', 8)
                        local item_name = hero_data[name].Aghanim
                        if item_name then
                            local item = hero:createItem(item_name..'-1')
                            hero:userData('专属', item)
                            hero:userData('专属名字', item:getName())
                            hero:userData('专属等级', 1)
                            hero:userData('专属挑战等级', 1)
                        end
                        --随机大礼包
                        if random == true then
	                        hero:createItem('治疗药水-小')
                        end                       
                        player:moveCamera(start_p, 0.2)
                        hero:userData('杀敌数', 0)
                        sg.family[player] = {}
                        ac.game:eventNotify('地图-选择英雄', hero, player)
                    end
                else
                    pick_mark[i] = unit
                    ac.wait(0.3, function()
                        pick_mark[i] = false
                    end)
                end
            end
        end)
    end
end)

local point = ac.point(1300, -9100)
local textTag_msg = '|cffff9900双击|cffffff00选择英雄|r'
ac.textTag()
: text(textTag_msg, 0.05)
: at(point, 10)