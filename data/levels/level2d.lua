--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 39
levelh = 49

create_world(levelw, levelh)
draw_border("st-greenbrown")
fill_floor("fl-leaves")

draw_stones("st-glass", {1,12},{1,0}, 18)
draw_stones("st-glass", {1,24},{1,0}, 1)
draw_stones("st-glass", {3,24},{1,0}, 16)
draw_stones("st-greenbrown", {2,21}, {1,0}, 3)
draw_stones("st-greenbrown", {2,15}, {0,1}, 6)
draw_stones("st-greenbrown", {4,15}, {0,1}, 6)
draw_stones("st-greenbrown", {14,20}, {1,0}, 5)
draw_stones("st-greenbrown", {14,22}, {1,0}, 5)
draw_stones("st-greenbrown", {14,14}, {1,0}, 4)
draw_stones("st-greenbrown", {14,16}, {1,0}, 5)
draw_stones("st-greenbrown", {14,15}, {0,1}, 1)
set_stones("st-grate1", {{8,16},{8,18},{11,17},{11,18},{15,15},{18,14}})
set_stones("st-greenbrown",  {{6,13},{6,15},{6,17},{6,19},{6,21},{6,23}})
draw_stones("st-grate1",{10,16}, {1,0}, 4)
draw_stones("st-grate1",{10,19}, {1,0}, 2)
draw_stones("st-grate1",{13,19}, {1,0}, 5)
draw_stones("st-grate1",{12,17}, {1,0}, 5)
draw_stones("st-greenbrown", {2,46}, {1,0}, 16)
draw_stones("st-greenbrown", {20,36}, {1,0}, 14)
draw_stones("st-greenbrown", {35,36}, {1,0}, 3)

draw_stones("st-greenbrown", {2,26}, {0,1}, 17)
draw_stones("st-greenbrown", {4,28}, {0,1}, 15)
draw_stones("st-greenbrown", {7,27}, {0,1}, 19)
draw_stones("st-greenbrown", {9,28}, {0,1}, 16)
draw_stones("st-greenbrown", {11,28}, {0,1}, 14)
draw_stones("st-greenbrown", {13,27}, {0,1}, 13)
draw_stones("st-greenbrown", {13,44}, {0,1}, 2)
draw_stones("st-greenbrown", {15,28}, {0,1}, 10)
draw_stones("st-greenbrown", {17,27}, {0,1}, 9)

draw_stones("st-greenbrown", {3,26}, {1,0}, 15)
draw_stones("st-greenbrown", {16,37}, {1,0}, 3)
draw_stones("st-greenbrown", {14,39}, {1,0}, 4)
draw_stones("st-greenbrown", {12,41}, {1,0}, 7)
draw_stones("st-greenbrown", {10,43}, {1,0}, 4)
draw_stones("st-greenbrown", {1,44}, {1,0}, 5)
draw_stones("st-greenbrown", {5,42}, {1,0}, 2)

draw_stones("st-greenbrown", {20,24}, {1,0}, 3)
draw_stones("st-greenbrown", {24,24}, {1,0}, 14)

draw_stones("st-brownie", {20,25}, {1,1}, 11)
draw_stones("st-brownie", {22,25}, {1,1}, 11)
draw_stones("st-brownie", {24,25}, {1,1}, 11)
draw_stones("st-brownie", {26,25}, {1,1}, 11)
draw_stones("st-brownie", {28,25}, {1,1}, 10)
draw_stones("st-brownie", {30,25}, {1,1}, 8)
draw_stones("st-brownie", {32,25}, {1,1}, 6)
draw_stones("st-brownie", {34,25}, {1,1}, 4)
draw_stones("st-brownie", {36,25}, {1,1}, 2)
draw_stones("st-brownie", {20,27}, {1,1}, 9)
draw_stones("st-brownie", {20,29}, {1,1}, 7)
draw_stones("st-brownie", {20,31}, {1,1}, 5)
draw_stones("st-brownie", {20,33}, {1,1}, 3)
draw_stones("st-brownie", {20,35}, {1,1}, 1)

puzzle(13,13,PUZ_0110)
puzzle(14,13,PUZ_0101)
puzzle(15,13,PUZ_0101)
puzzle(16,13,PUZ_0101)
puzzle(17,13,PUZ_0101)
puzzle(18,13,PUZ_0101)
puzzle(20,13,PUZ_0101)
puzzle(21,13,PUZ_0101)
puzzle(22,13,PUZ_0101)
puzzle(23,13,PUZ_0101)
puzzle(24,13,PUZ_0001)
puzzle(7,18,PUZ_0100)
puzzle(13,14,PUZ_1001)
puzzle(19,18,PUZ_0100)
puzzle(20,18,PUZ_0001)

set_stones("st-brownie", {{21,18}})

set_stones("st-swap", {{17,17}})
set_stone("st-shogun-s", 16,15)
doorh(2,24, {name="door9"})

shogundot1(15,15, {action="openclose", target="door9"})

draw_stones("st-greenbrown", {19,1}, {0,1}, 12)
draw_stones("st-greenbrown", {19,14}, {0,1}, 4)
draw_stones("st-greenbrown", {19,19}, {0,1}, 28)

set_attrib(laser(12,5, TRUE, WEST), "name", "laser")

mirror3(7,5,0,1,1)
mirror3(6,5,0,1,1)
mirror3(5,5,0,1,1)
mirror3(4,5,0,1,1)
mirror3(3,5,0,1,1)
mirror3(2,5,0,1,1)
mirror3(1,5,0,1,1)

oxyd(18,21)
oxyd(18,15)
oxyd(6,41)
oxyd(12,45)
fakeoxyd(8,45)
fakeoxyd(16,44)
oxyd_shuffle()

shogundot3(5,35)
shogundot1(14,33)
shogundot3(18,42)
shogundot2(12,47)

set_stone("st-shogun-m", 5,38)
set_stone("st-shogun-l", 14,43)
set_stone("st-shogun-s", 12,47)


-- these are the doors that hold back the laser beam
doorv(11,5, {name="door1"})
doorv(10,5, {name="door2"})
doorv(9,5,  {name="door3"})
doorv(8,5,  {name="door4"})

shogundot1(4,47, {action="openclose", target="door8"})
set_stone("st-shogun-s", 21,45)

fill_floor("fl-water", 21,44, 1,1)
fill_floor("fl-water", 21,46, 1,1)

-- these are the doors that protect the oxyd stone on the first screen
doorv(14,21,  {name="door5"})
doorv(15,21,  {name="door6"})
doorv(16,21,  {name="door7"})
doorv(17,21,  {name="door8"})

function sdot2()
    SendMessage("door1", "open")
    SendMessage("door5", "open")
end

shogundot3(3,19, {action="callback", target="sdot2"})

function sdot3()
    SendMessage("door2", "open")
    SendMessage("door6", "open")
end

shogundot3(3,18, {action="callback", target="sdot3"})

function sdot4()
    SendMessage("door3", "open")
    SendMessage("door7", "open")
end

shogundot3(3,17, {action="callback", target="sdot4"})

-- this topmost shogun dot unleashes the laser beam!
shogundot3(3,16, {action="open", target="door4"})

set_stone("st-shogun-m", 8,15)
set_stone("st-shogun-l", 7,16)
set_stone("st-shogun-sl", 9,16)
set_stone("st-shogun-ml", 8,17)
set_stone("st-shogun-sm", 10,17)
set_stone("st-shogun-sl", 9,18)
set_stone("st-shogun-m", 8,19)

draw_stones("st-glass", {23,40},{1,0}, 11)
draw_stones("st-glass", {35,40},{1,0}, 3)
draw_stones("st-glass", {23,41},{0,1}, 1)
draw_stones("st-glass", {23,43},{0,1}, 4)

oneway(23,42, enigma.WEST)
oneway(34,40, enigma.SOUTH)

mirrorp(22,41,TRUE,FALSE, 1)
mirrorp(29,47,0,0,4)
mirror3(25,47,0,1,2)

set_attrib(laser(23,47, TRUE, EAST), "name", "laser1")
set_stone("st-switch", 27,46, {action="onoff", target="laser1"})

fill_floor("fl-water", 24,41, 10,1)
fill_floor("fl-water", 24,43, 10,3)
fill_floor("fl-water", 35,41, 3,7)
fill_floor("fl-water", 24,47, 11,1)
fill_floor("fl-water", 35,37, 3,3)
fill_floor("fl-water", 31,37, 3,1)
fill_floor("fl-water", 24,39, 9,1)
fill_floor("fl-water", 20,37, 1,6)
fill_floor("fl-water", 21,37, 4,1)

draw_stones("st-glass", {20,12},{1,0}, 18)

draw_stones("st-greenbrown", {22,15}, {0,1}, 8)
draw_stones("st-greenbrown", {21,16}, {0,1}, 1)
draw_stones("st-greenbrown", {21,21}, {0,1}, 1)
draw_stones("st-grate1",{23,20}, {1,0}, 7)
draw_stones("st-grate1",{31,20}, {1,0}, 7)
draw_stones("st-grate1",{30,15}, {1,0}, 5)
draw_stones("st-grate1",{36,15}, {1,0}, 2)
draw_stones("st-grate1",{30,16}, {0,1}, 4)
draw_stones("st-grate1",{24,21}, {0,1}, 2)

set_stones("st-brownie", {{25,17}})

set_stones("st-swap", {{35,15}})

set_actor("ac-blackball", 13.5, 19.5)
