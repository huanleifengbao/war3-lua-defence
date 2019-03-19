--基地
local shop = sg.base:createShop()
shop:setBuyRange(1000000)
shop:setItem('交换金币', 9, 'Q')
shop:setItem('交换木材', 10, 'W')
shop:setItem('基地无敌', 5, 'A')
shop:setItem('暂停刷怪', 6, 'S')
shop:setItem('基地升级', 7, 'D')
shop:setItem('你知道吗-1', 8, 'F')
shop:setItem('副本-虎牢关大战', 1, 'Z')
shop:setItem('副本-大战黄巾贼', 2, 'X')
shop:setItem('副本-过五关斩六将', 3, 'C')

local shop_list = {
	['商城道具'] = {p = ac.point(4944, -10529),n = [[shop\shangchengdaoju.mdx]]},
	['黑市商人'] = {p = ac.point(5644, -10529),n = [[shop\heishishangren.mdx]]},
    ['药水商店'] = {p = ac.point(6344, -10529),n = [[shop\yaoshuishangdian.mdx]]},
    --中心
	['新手装备'] = {p = ac.point(7044, -10529),n = [[shop\xinshouzhuangbei.mdx]]},
	['进阶挑战'] = {p = ac.point(7744, -10529),n = [[shop\jinjietiaozhan.mdx]]},
	['装备进阶'] = {p = ac.point(8444, -10529),n = [[shop\zhuangbeijinjie.mdx]]},
	['野外挑战'] = {p = ac.point(9144, -10529),n = [[shop\yewaitiaozhan.mdx]]},
}

for name,data in pairs(shop_list) do
	local p = data.p
	local n = data.n
	shop_list[name] = ac.player(16):createShop(name,p,270)
	ac.effect {
	    target = p,
	    model = n,
	    size = 2,
	    height = 300,
	}
end

--药水商店
local shop = shop_list['药水商店']
shop:setBuyRange(1000000)
shop:setItem('治疗药水-小', 9, 'Q')
shop:setItem('治疗药水-大', 10, 'W')
shop:setItem('经验之书', 5, 'A')
shop:setItem('作弊等级', 6, 'S')
shop:setItem('作弊属性', 7, 'D')
shop:setItem('作弊自杀', 1, 'Z')

--新手装备
local shop = shop_list['新手装备']
shop:setBuyRange(1000000)
shop:setItem('新手武器-1', 9, 'Q')
shop:setItem('新手衣服-1', 10, 'W')
shop:setItem('新手鞋子-1', 11, 'E')
shop:setItem('新手饰品-1', 12, 'R')
shop:setItem('武器升级', 5, 'A')
shop:setItem('衣服升级', 6, 'S')
shop:setItem('鞋子升级', 7, 'D')
shop:setItem('饰品升级', 8, 'F')
shop:setItem('专属升级', 1, 'Z')
shop:setItem('作弊武器', 2, 'X')
shop:setItem('作弊防具', 3, 'C')
shop:setItem('作弊金钱', 4, 'V')

--进阶挑战
local shop = shop_list['进阶挑战']
shop:setBuyRange(1000000)
shop:setItem('挑战锻造石boss-1', 9, 'Q')
shop:setItem('挑战锻造石boss-2', 10, 'W')
shop:setItem('挑战锻造石boss-3', 11, 'E')
shop:setItem('挑战锻造石boss-4', 12, 'R')
shop:setItem('挑战锻造石boss-5', 5, 'A')
shop:setItem('挑战锻造石boss-6', 6, 'S')
shop:setItem('挑战锻造石boss-7', 7, 'D')
shop:setItem('挑战锻造石boss-8', 8, 'F')
shop:setItem('挑战锻造石boss-9', 1, 'Z')
shop:setItem('挑战锻造石boss-10', 2, 'X')
shop:setItem('挑战锻造石boss-11', 3, 'C')

--作弊:出售锻造石
local shop = ac.player(16):createShop('商店', ac.point(7444, -10829), 270)
shop:setBuyRange(1000000)
shop:setItem('一级锻造石', 9, 'Q')
shop:setItem('二级锻造石', 10, 'W')
shop:setItem('三级锻造石', 11, 'E')
shop:setItem('四级锻造石', 12, 'R')
shop:setItem('五级锻造石', 5, 'A')
shop:setItem('六级锻造石', 6, 'S')
shop:setItem('七级锻造石', 7, 'D')
shop:setItem('八级锻造石', 8, 'F')
shop:setItem('九级锻造石', 1, 'Z')
shop:setItem('十级锻造石', 2, 'X')
shop:setItem('终极锻造石', 3, 'C')
shop:setItem('商城作弊怪', 4, 'V')

--作弊:方便测试随便写
local shop = ac.player(16):createShop('商店', ac.point(7444, -11129), 270)
shop:setBuyRange(1000000)
shop:setItem('进阶武器-10', 9, 'Q')
shop:setItem('进阶衣服-10', 10, 'W')
shop:setItem('进阶鞋子-10', 11, 'E')
shop:setItem('进阶饰品-10', 12, 'R')
shop:setItem('终极神器', 5, 'A')
shop:setItem('玄铁', 7, 'D')
shop:setItem('百年玄铁', 8, 'F')
shop:setItem('千年玄铁', 1, 'Z')
shop:setItem('九幽玄铁', 2, 'X')


--装备进阶
local shop = shop_list['装备进阶']
shop:setBuyRange(1000000)
shop:setItem('装备进阶-1', 9, 'Q')
shop:setItem('装备进阶-2', 10, 'W')
shop:setItem('装备进阶-3', 11, 'E')
shop:setItem('装备进阶-4', 12, 'R')
shop:setItem('装备进阶-5', 5, 'A')
shop:setItem('装备进阶-6', 6, 'S')
shop:setItem('装备进阶-7', 7, 'D')
shop:setItem('装备进阶-8', 8, 'F')
shop:setItem('装备进阶-9', 1, 'Z')
shop:setItem('装备进阶-10', 2, 'X')
shop:setItem('终极合成', 3, 'C')

--野外挑战
local shop = shop_list['野外挑战']
shop:setBuyRange(1000000)
shop:setItem('挑战电', 9, 'Q')
shop:setItem('挑战雷', 10, 'W')
shop:setItem('挑战晓', 11, 'E')
shop:setItem('挑战响', 12, 'R')
shop:setItem('练功房', 5, 'A')
shop:setItem('觉醒挑战房', 6, 'S')

--黑市商人
local shop = shop_list['黑市商人']
shop:setBuyRange(1000000)
shop:setItem('抽奖', 9, 'Q')
shop:setItem('十连抽奖', 10, 'W')
shop:setItem('使用抽奖券', 11, 'E')
shop:setItem('兑换玄铁-1', 5, 'A')
shop:setItem('兑换玄铁-2', 6, 'S')
shop:setItem('兑换玄铁-3', 7, 'D')
shop:setItem('兑换玄铁-4', 8, 'F')

--商城道具
local shop = shop_list['商城道具']
shop:setBuyRange(1000000)
shop:setItem('新手礼包', 9, 'Q')
shop:setItem('荣光不败的白亚之翼', 10, 'W')
shop:setItem('原初的符文', 11, 'E')
shop:setItem('土豪玩家', 12, 'R')
shop:setItem('时为朦胧的雪花之翼', 5, 'A')

--练功
local point = {
    ac.point(6593, 10301),   ac.point(9834, 10301),
    ac.point(6593, 7740),    ac.point(9834, 7740),
    ac.point(6593, 5547),    ac.point(9834, 5547),
}
for i = 1, #point do
    local shop = ac.player(16):createShop('野外挑战', point[i], 270)
    ac.effect {
	    target = point[i],
	    model = [[shop\liangongfang.mdx]],
	    size = 2,
	    height = 300,
	}
    shop:setBuyRange(1500)
    shop:setItem('刷经验1', 9, 'Q')
    shop:setItem('作弊刷怪', 10, 'W')
    shop:setItem('刷钱1', 5, 'A')
    shop:setItem('刷钱2', 6, 'S')
    --shop:setItem('刷钱3', 7, 'D')
    --shop:setItem('刷钱4', 8, 'F')
    shop:setItem('刷木1', 1, 'Z')
    shop:setItem('刷木2', 2, 'X')
    shop:setItem('刷木3', 3, 'C')
    --shop:setItem('刷木4', 4, 'V')
end

--觉醒挑战房
local point = {
    ac.point(-6250, -3500),
    ac.point(-3950, -3500),
    ac.point(-1750, -3500),
    ac.point(400, -3500),
    ac.point(2450, -3500),
    ac.point(4600, -3500),
}
for i = 1, #point do
    local shop = ac.player(16):createShop('野外挑战', point[i], 270)
    shop:setBuyRange(1500)
    ac.effect {
	    target = point[i],
	    model = [[shop\juexingtiaozhan.mdx]],
	    size = 2,
	    height = 300,
	}
    shop:setBuyRange(1500)
    shop:setItem('挑战觉醒boss-1', 9, 'Q')
    shop:setItem('挑战觉醒boss-2', 10, 'W')
    shop:setItem('挑战觉醒boss-3', 11, 'E')
    shop:setItem('挑战觉醒boss-4', 12, 'R')
    shop:setItem('挑战觉醒boss-5', 5, 'A')
    shop:setItem('挑战觉醒boss-6', 6, 'S')
    shop:setItem('挑战觉醒boss-7', 7, 'D')
    shop:setItem('挑战觉醒boss-8', 8, 'F')
    shop:setItem('挑战觉醒boss-9', 1, 'Z')
    shop:setItem('挑战觉醒boss-10', 2, 'X')
    shop:setItem('继续-觉醒boss', 3, 'C')
    shop:setItem('放弃-觉醒boss', 4, 'V')
end