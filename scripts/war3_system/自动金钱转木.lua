
for i = 1,sg.max_player do
    local player = ac.player(i)
    player:event('玩家-属性变化', function (_, _, type, count)
        if type == '金币' then
            if player:get('金币') >= 1000000 then
                player:add('金币', -1000000)
                player:add('木材', 100)
                local hero = player:getHero()
                if hero then
                    hero:particle([[Abilities\Spells\Human\Polymorph\PolyMorphDoneGround.mdl]], 'origin', 0)
                end
            end
        end
    end)
end