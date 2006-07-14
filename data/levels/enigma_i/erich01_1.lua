-- balance, a level for Enigma
-- Copyright (C) JAHR Erich Schubert
-- Licensed under GPL v2.0 or above

levelw = 39
levelh = 25

create_world(levelw, levelh)
draw_border("st-brownie")

fill_floor("fl-water")


current_point = {0,0}
current_dir = 0
function set_point(x, y) 
    current_point={x,y}
end
function set_dir(dir)
    current_dir=dir
end
function advance_point()
    local xinc = {0,1,0,-1}
    local yinc = {-1,0,1,0}
    current_point[1] = current_point[1] + xinc[current_dir+1]
    current_point[2] = current_point[2] + yinc[current_dir+1]
end

function draw_with_floor(name, commands)
    for i=1,strlen(commands) do
        local c = strsub(commands, i,i)
        if c=="r" then -- turn right
            local tab = {1,2,3,0}
            current_dir = tab[current_dir+1]
        elseif c=="l" then -- turn left
            local tab = {3,0,1,2}
            current_dir = tab[current_dir+1]
        else
            for j=1,tonumber(c) do
                -- draw floor
                advance_point()
                set_floor(name, current_point[1], current_point[2])
            end
        end
    end
end

fl="fl-gray"
-- with oxyd stone:
fill_floor(fl, 1,1,3,3)
fill_floor(fl, 6,6,3,3)
fill_floor(fl, 13,2,3,3)
fill_floor(fl, 15,10,3,3)
-- fill_floor(fl, 2,7,3,3)
fill_floor(fl, 3,10,3,3)
-- with oxyd stone:
fill_floor(fl, 1,19,3,3)
fill_floor(fl, 8,21,3,3)
fill_floor(fl, 13,14,3,3)
fill_floor(fl, 17,19,3,3)
fill_floor(fl, 24,13,3,3)
fill_floor(fl, 21,21,3,3)
-- with oxyd stone:
fill_floor(fl, 35,21,3,3)
-- on fourth screen
fill_floor(fl, 30,8,3,3)
fill_floor(fl, 30,2,3,3)
-- with oxyd stone:
fill_floor(fl, 35,1,3,3)

-- set_stone("st-bombs", 10,7)

fl="fl-sand"
set_point(2,2)
set_dir(1)
advance_point()
-- on first screen
draw_with_floor(fl, "4r5l4l4r3r5l2r3r93l4")
-- on second screen
draw_with_floor(fl, "r2l8l4l1r3l7r5r8l4l6r4")
-- on third screen
draw_with_floor(fl, "l3r3r5r3l3l5l2r2r2l2l2r2r2l3l5l1r1l1r1l1r1l1r1l1r4")
-- on fourth screen
draw_with_floor(fl, "l91r2r7l2l7r2r91r3l3r3l3l5")
set_point()

-- fl="fl-sand"
-- draw_floor(fl, {4,2}, {1,0}, 3)
-- draw_floor(fl, {7,2}, {0,1}, 4)
-- draw_floor(fl, {9,8}, {1,0}, 2)
-- draw_floor(fl, {11,8}, {0,-1}, 6)
-- draw_floor(fl, {11,3}, {1,0}, 2)
-- draw_floor(fl, {14,5}, {0,1}, 8)
-- draw_floor(fl, {15,10}, {0,1}, 3)


oxyd(2,0)
oxyd(level_width-1,level_height-3)
oxyd(level_width-1, 2)
oxyd(0,level_height-5)
oxyd_shuffle()
-- set_stone("st-chameleon", 3,3)

set_actor("ac-blackball", 2, 2)





























