--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 39
levelh = 13

create_world(levelw, levelh)

draw_border("st-greenbrown")

fill_floor("fl-leaves")
fill_floor("fl-abyss", 2,2, 5,9)
fill_floor("fl-abyss", 31,2, 5,9)
fill_floor("fl-abyss", 8,2, 10,6)
fill_floor("fl-abyss", 9,8, 6,3)
fill_floor("fl-abyss", 16,9, 3,3)
abyss(7,2)

set_actor("ac-blackball", 26,10)

draw_stones("st-greenbrown", {23,7}, {1,0},7)
draw_stones("st-greenbrown", {19,1}, {0,1},7)
draw_stones("st-greenbrown", {19,9}, {0,1},3)
draw_stones("st-grate1", {7,1}, {0,1} ,11)

set_stone("st-swap", 21,6)
set_stone("st-swap", 22,7)
set_stone("st-greenbrown", 20,7)

set_stones("st-grate1", {{20,6},{21,7},{22,6}})
set_stone("st-glass", 19,2)

puzzle(10,8,PUZ_0100)
puzzle(11,8,PUZ_0101)
puzzle(12,8,PUZ_0101)
puzzle(13,8,PUZ_0101)
puzzle(14,8,PUZ_0101)
puzzle(15,8,PUZ_0101)
puzzle(16,8,PUZ_0101)
puzzle(17,8,PUZ_0101)
puzzle(18,8,PUZ_0101)
puzzle(19,8,PUZ_0101)
puzzle(28,9,PUZ_0011)
puzzle(28,8,PUZ_1000)
puzzle(24,4,PUZ_0101)

mirrorp(36,2,0,0,2)

set_attrib(laser(0,2, TRUE, EAST), "name", "laser")
set_stone("st-switch", 8,8, {action="onoff", target="laser"})

oxyd(1,1)
oxyd(37,11)
oxyd(1,11)
oxyd(37,1)

--document(7,3, "Mit F3 kann man neu beginnen")
document(7,3, "Restart with F3...")

















