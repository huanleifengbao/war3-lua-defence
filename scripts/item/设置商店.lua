
--新手装备
local shop = ac.player(16):createShop('刘备', ac.point(7044, -10529), 270)
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

--作弊:出售锻造石
local shop = ac.player(16):createShop('刘备', ac.point(7444, -10529), 270)
shop:setItem('锻造石-1', 9, 'Q')

--挑战锻造石boss
local shop = ac.player(16):createShop('刘备', ac.point(7844, -10529), 270)

--锻造石装备
local shop = ac.player(16):createShop('刘备', ac.point(8244, -10529), 270)

--挑战专武boss
local shop = ac.player(16):createShop('刘备', ac.point(8644, -10529), 270)
shop:setBuyRange(2000)
shop:setItem('挑战电', 9, 'Q')
shop:setItem('挑战雷', 10, 'W')
shop:setItem('挑战晓', 11, 'E')
shop:setItem('挑战响', 12, 'R')
shop:setItem('练功房', 5, 'A')

local point = {
    ac.point(6593, 10301),   ac.point(9834, 10301),
    ac.point(6593, 7740),    ac.point(9834, 7740),
    ac.point(6593, 5547),    ac.point(9834, 5547),
}
--练功
for i = 1, 6 do
    local shop = ac.player(16):createShop('刘备', point[i], 270)
    shop:setBuyRange(1500)
    shop:setItem('刷钱1', 9, 'Q')
    shop:setItem('刷钱2', 10, 'W')
    --shop:setItem('刷钱3', 11, 'E')
    --shop:setItem('刷钱4', 12, 'R')
    shop:setItem('刷木1', 5, 'A')
    shop:setItem('刷木2', 6, 'S')
    shop:setItem('刷木3', 7, 'D')
    --shop:setItem('刷木4', 8, 'F')
    shop:setItem('刷经验1', 1, 'Z')
end