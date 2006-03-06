--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 13

create_world(levelw, levelh)
draw_border("st-blue-sand")
fill_floor("fl-mortar")

puzzle(5,3,PUZ_0101)
puzzle(6,3,PUZ_0100)
puzzle(7,3,PUZ_0101)
puzzle(8,3,PUZ_0101)
puzzle(9,3,PUZ_0101)
puzzle(10,3,PUZ_1000)
puzzle(11,3,PUZ_0101)
puzzle(12,3,PUZ_0001)
puzzle(13,3,PUZ_0100)
puzzle(14,3,PUZ_1010)
puzzle(5,9,PUZ_0101)
puzzle(6,9,PUZ_0101)
puzzle(7,9,PUZ_0101)
puzzle(8,9,PUZ_0001)
puzzle(9,9,PUZ_0101)
puzzle(10,9,PUZ_1010)
puzzle(11,9,PUZ_0100)
puzzle(12,9,PUZ_0101)
puzzle(13,9,PUZ_0101)
puzzle(14,9,PUZ_1010)
puzzle(6,4,PUZ_0101)
puzzle(7,4,PUZ_0101)
puzzle(8,4,PUZ_0001)
puzzle(9,4,PUZ_0101)
puzzle(10,4,PUZ_1000)
puzzle(11,4,PUZ_1000)
puzzle(12,4,PUZ_1010)
puzzle(13,4,PUZ_0101)
puzzle(6,8,PUZ_0100)
puzzle(7,8,PUZ_0101)
puzzle(8,8,PUZ_0101)
puzzle(9,8,PUZ_1010)
puzzle(10,8,PUZ_0101)
puzzle(11,8,PUZ_0101)
puzzle(12,8,PUZ_0101)
puzzle(13,8,PUZ_0001)
puzzle(4,7,PUZ_1010)
puzzle(4,8,PUZ_0101)
puzzle(4,9,PUZ_1010)
puzzle(4,3,PUZ_1010)
puzzle(4,4,PUZ_0101)
puzzle(4,5,PUZ_0101)
puzzle(4,6,PUZ_0010)
puzzle(15,7,PUZ_1010)
puzzle(15,8,PUZ_1010)
puzzle(15,9,PUZ_0101)
puzzle(15,3,PUZ_0010)
puzzle(15,4,PUZ_0101)
puzzle(15,5,PUZ_0101)
puzzle(15,6,PUZ_1010)
puzzle(5,4,PUZ_0101)
puzzle(5,5,PUZ_1010)
puzzle(5,6,PUZ_1010)
puzzle(5,7,PUZ_1010)
puzzle(5,8,PUZ_1000)
puzzle(14,4,PUZ_0101)
puzzle(14,5,PUZ_0010)
puzzle(14,6,PUZ_0010)
puzzle(14,7,PUZ_1010)
puzzle(14,8,PUZ_1010)

draw_stones("st-blue-sand", {6,5}, {1,0},2)
draw_stones("st-blue-sand", {9,5}, {1,0},5)
draw_stones("st-blue-sand", {9,6}, {1,0},2)
draw_stones("st-blue-sand", {6,7}, {1,0},5)
draw_stones("st-blue-sand", {12,7}, {1,0},2)

oxyd (8,6)
oxyd (11,6)
oxyd (7,6)
oxyd (12,6)

set_stones("st-grate1", {{8,5},{11,7},{6,6},{13,6}})

set_item("it-magicwand",17,8)

set_actor("ac-blackball", 17.5,10.5)















