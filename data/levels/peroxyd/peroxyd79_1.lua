--
-- A level for Enigma
--
-- Copyright (c) 2002 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 39
levelh = 13

create_world(levelw, levelh)
draw_border("st-rock5")
fill_floor("fl-sahara")

fill_floor("fl-water", 8,1, 10,level_height-2)
fill_floor("fl-water", 28,1, 3,7)
fill_floor("fl-water", 32,7, 4,5)
fill_floor("fl-water", 31,5, 1,3)
fill_floor("fl-water", 32,5, 1,2)
fill_floor("fl-water", 33,6, 2,1)

oxyd_default_flavor = "d"

oxyd (1,1)
oxyd (37,1)
oxyd (19,11)
oxyd (35,4)
oxyd (22,1)
oxyd (29,11)

draw_stones("st-grate1", {24,1}, {0,1},4)
draw_stones("st-grate1", {25,1}, {0,1},4)
draw_stones("st-grate1", {26,1}, {0,1},4)
draw_stones("st-grate1", {24,8}, {0,1},4)
draw_stones("st-grate1", {25,8}, {0,1},4)
draw_stones("st-grate1", {26,8}, {0,1},4)

set_stones("st-death", {{10,2},{8,3},{12,3},{16,3},{13,4},{14,5},{17,5}})
set_stones("st-death", {{17,15},{9,7},{17,7},{12,8},{10,9},{13,10}})

puzzle(4,4,PUZ_0100)
puzzle(5,4,PUZ_0011)
puzzle(6,4,PUZ_0010)
puzzle(2,5,PUZ_0100)
puzzle(3,5,PUZ_0101)
puzzle(4,5,PUZ_0101)
puzzle(5,5,PUZ_1001)
puzzle(6,5,PUZ_1100)
puzzle(7,5,PUZ_0001)
puzzle(5,6,PUZ_0110)
puzzle(6,6,PUZ_0001)
puzzle(4,7,PUZ_0100)
puzzle(5,7,PUZ_1001)
puzzle(6,7,PUZ_0010)
puzzle(4,8,PUZ_0100)
puzzle(5,8,PUZ_0101)
puzzle(6,8,PUZ_1001)
puzzle(20,5,PUZ_0101)
puzzle(22,5,PUZ_0010)
puzzle(25,5,PUZ_0001)
puzzle(26,5,PUZ_0101)
puzzle(22,6,PUZ_1010)
puzzle(24,6,PUZ_0110)
puzzle(25,6,PUZ_1100)
puzzle(26,6,PUZ_0011)
puzzle(20,7,PUZ_1010)
puzzle(22,7,PUZ_1000)
puzzle(24,7,PUZ_1001)
puzzle(25,7,PUZ_0100)
puzzle(26,7,PUZ_0101)

set_item( "it-magicwand", 22,5)

set_actor("ac-blackball", 2.5,8.5 )











