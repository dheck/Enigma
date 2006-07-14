--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 25

create_world(levelw, levelh)
draw_border("st-rock2")
fill_floor("fl-gray")

oxyd (0,1)
oxyd (7,0)
oxyd (11,0)
oxyd (10,5)
oxyd (0,11)
oxyd (19,11)

puzzle(6,1,PUZ_0100)
puzzle(7,1,PUZ_0001)

puzzle(11,1,PUZ_0100)
puzzle(12,1,PUZ_0001)

puzzle(9,6,PUZ_0100)
puzzle(10,6,PUZ_0001)

puzzle(15,11,PUZ_0100)
puzzle(16,11,PUZ_0001)

puzzle(3,8,PUZ_1000)
puzzle(3,7,PUZ_1010)
puzzle(3,6,PUZ_1010)
puzzle(3,5,PUZ_1010)
puzzle(3,4,PUZ_1010)
puzzle(3,3,PUZ_0110)
puzzle(4,3,PUZ_0101)
puzzle(5,3,PUZ_0101)
puzzle(6,3,PUZ_0011)
puzzle(6,4,PUZ_1100)
puzzle(7,4,PUZ_0011)
puzzle(7,5,PUZ_1010)
puzzle(7,6,PUZ_1010)
puzzle(7,7,PUZ_1010)
puzzle(7,8,PUZ_1010)
puzzle(7,9,PUZ_1000)

puzzle(14,3,PUZ_0100)
puzzle(15,3,PUZ_0101)
puzzle(16,3,PUZ_0101)
puzzle(17,3,PUZ_0011)
puzzle(17,4,PUZ_1010)
puzzle(17,5,PUZ_1010)
puzzle(17,6,PUZ_1010)
puzzle(17,7,PUZ_1010)
puzzle(17,8,PUZ_1010)
puzzle(17,9,PUZ_1010)
puzzle(17,10,PUZ_1010)
puzzle(17,11,PUZ_1000)

puzzle(14,4,PUZ_0010)
puzzle(14,5,PUZ_1010)
puzzle(14,6,PUZ_1000)

puzzle(12,6,PUZ_0010)
puzzle(12,7,PUZ_1010)
puzzle(12,8,PUZ_1010)
puzzle(12,9,PUZ_1100)
puzzle(13,9,PUZ_0001)

puzzle(4,9,PUZ_0010)
puzzle(4,10,PUZ_1001)
puzzle(3,10,PUZ_0110)
puzzle(3,11,PUZ_1100)
puzzle(4,11,PUZ_0101)
puzzle(5,11,PUZ_0101)
puzzle(6,11,PUZ_0101)
puzzle(7,11,PUZ_0101)
puzzle(8,11,PUZ_0101)
puzzle(9,11,PUZ_0101)
puzzle(10,11,PUZ_1001)
puzzle(10,10,PUZ_0010)

draw_stones("st-rock2", {1,12}, {1,0},12)
draw_stones("st-rock2", {14,12}, {1,0},4)
draw_stones("st-rock2", {4,1}, {0,1},2)
draw_stones("st-rock2", {5,9}, {0,1},2)
draw_stones("st-rock2", {1,9}, {1,0},1)
draw_stones("st-rock2", {10,2}, {0,1},3)
draw_stones("st-rock2", {9,4}, {1,0},1)
draw_stones("st-rock2", {8,5}, {1,0},1)
draw_stones("st-rock2", {8,7}, {1,0},3)
draw_stones("st-rock2", {11,11}, {1,0},1)
draw_stones("st-rock2", {13,7}, {0,1},2)
draw_stones("st-rock2", {14,8}, {0,1},3)
draw_stones("st-rock2", {15,8}, {0,1},2)
draw_stones("st-rock2", {11,5}, {1,0},1)

draw_stones("st-grate1", {1,1}, {0,1},8)
draw_stones("st-grate1", {5,1}, {0,1},2)
draw_stones("st-grate1", {14,1}, {1,0},5)
draw_stones("st-grate1", {18,2}, {0,1},21)
draw_stones("st-grate1", {12,11}, {1,0},3)
set_stones("st-grate1", {{2,1},{10,1},{11,2},{13,2},{8,4},{8,6},{13,12}})
set_stones("st-grate1", {{12,5},{13,6},{14,7},{5,8},{13,10},{15,10}})

oxyd (0,13)
oxyd (7,24)
oxyd (0,23)
oxyd (10,19)
oxyd (19,13)
oxyd (11,24)

puzzle(15,13,PUZ_0100)
puzzle(16,13,PUZ_0001)

puzzle(9,18,PUZ_0100)
puzzle(10,18,PUZ_0001)

puzzle(6,23,PUZ_0100)
puzzle(7,23,PUZ_0001)

puzzle(11,23,PUZ_0100)
puzzle(12,23,PUZ_0001)

puzzle(3,16,PUZ_0010)
puzzle(3,17,PUZ_1010)
puzzle(3,18,PUZ_1010)
puzzle(3,19,PUZ_1010)
puzzle(3,20,PUZ_1010)
puzzle(3,21,PUZ_1100)
puzzle(4,21,PUZ_0101)
puzzle(5,21,PUZ_0101)
puzzle(6,21,PUZ_1001)
puzzle(6,20,PUZ_0110)
puzzle(7,20,PUZ_1001)
puzzle(7,19,PUZ_1010)
puzzle(7,18,PUZ_1010)
puzzle(7,17,PUZ_1010)
puzzle(7,16,PUZ_1010)
puzzle(7,15,PUZ_0010)

puzzle(14,21,PUZ_0100)
puzzle(15,21,PUZ_0101)
puzzle(16,21,PUZ_0101)
puzzle(17,21,PUZ_1001)
puzzle(17,20,PUZ_1010)
puzzle(17,19,PUZ_1010)
puzzle(17,18,PUZ_1010)
puzzle(17,17,PUZ_1010)
puzzle(17,16,PUZ_1010)
puzzle(17,15,PUZ_1010)
puzzle(17,14,PUZ_1010)
puzzle(17,13,PUZ_0010)

puzzle(14,18,PUZ_0010)
puzzle(14,19,PUZ_1010)
puzzle(14,20,PUZ_1000)

puzzle(13,15,PUZ_0001)
puzzle(12,15,PUZ_0110)
puzzle(12,16,PUZ_1010)
puzzle(12,17,PUZ_1010)
puzzle(12,18,PUZ_1000)

puzzle(4,15,PUZ_1000)
puzzle(4,14,PUZ_0011)
puzzle(3,14,PUZ_1100)
puzzle(3,13,PUZ_0110)
puzzle(4,13,PUZ_0101)
puzzle(5,13,PUZ_0101)
puzzle(6,13,PUZ_0101)
puzzle(7,13,PUZ_0101)
puzzle(8,13,PUZ_0101)
puzzle(9,13,PUZ_0101)
puzzle(10,13,PUZ_0011)
puzzle(10,14,PUZ_1000)

draw_stones("st-rock2", {4,22}, {0,1},2)
draw_stones("st-rock2", {5,14}, {0,1},2)
draw_stones("st-rock2", {1,15}, {1,0},1)
draw_stones("st-rock2", {10,20}, {0,1},3)
draw_stones("st-rock2", {9,20}, {1,0},1)
draw_stones("st-rock2", {8,19}, {1,0},1)
draw_stones("st-rock2", {8,17}, {1,0},3)
draw_stones("st-rock2", {11,13}, {1,0},1)
draw_stones("st-rock2", {13,16}, {0,1},2)
draw_stones("st-rock2", {14,14}, {0,1},3)
draw_stones("st-rock2", {15,15}, {0,1},2)
draw_stones("st-rock2", {11,19}, {1,0},1)

draw_stones("st-grate1", {1,16}, {0,1},8)
draw_stones("st-grate1", {5,22}, {0,1},2)
draw_stones("st-grate1", {14,23}, {1,0},5)
draw_stones("st-grate1", {12,13}, {1,0},3)
set_stones("st-grate1", {{2,23},{5,16},{8,18},{8,20},{10,23},{11,22}})
set_stones("st-grate1", {{13,22},{13,14},{15,14},{14,17},{13,18},{12,19}})

set_actor("ac-blackball", 16,19)
















