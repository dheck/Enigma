--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 25

create_world(levelw, levelh)
enigma.ConserveLevel = FALSE
draw_border("st-rock4")
fill_floor("fl-samba")

oxyd_default_flavor = "c"

oxyd ( 1, 1)
oxyd (18, 1)
oxyd (10,11)
oxyd (10,13)
oxyd ( 1,23)
oxyd (18,23)

oxyd_shuffle()

draw_stones("st-rock4", { 1,12}, {1,0}, 2)
draw_stones("st-rock4", { 6, 3}, {0,1}, 5)
draw_stones("st-rock4", { 6, 9}, {0,1}, 8)
draw_stones("st-rock4", { 6,18}, {0,1}, 5)
draw_stones("st-rock4", {14, 3}, {0,1}, 7)
draw_stones("st-rock4", {14,11}, {0,1}, 5)
draw_stones("st-rock4", {14,17}, {0,1}, 2)
draw_stones("st-rock4", {14,20}, {0,1}, 4)
draw_stones("st-rock4", { 7, 9}, {1,0}, 2)
draw_stones("st-rock4", { 9, 9}, {0,1}, 3)
draw_stones("st-rock4", { 9,12}, {1,0}, 2)
draw_stones("st-rock4", {11,12}, {0,1}, 4)
draw_stones("st-rock4", {12,15}, {1,0}, 2)
set_stones("st-rock4", {{6,1},{14,1},{17,1},{4,20},{16,19},{18,12}})

puzzle(3,6,PUZ_0010)
puzzle(3,7,PUZ_1010)
puzzle(3,8,PUZ_1010)
puzzle(3,9,PUZ_1010)
puzzle(3,10,PUZ_1010)
puzzle(3,11,PUZ_0000)
puzzle(3,12,PUZ_1010)
puzzle(3,13,PUZ_1010)
puzzle(3,14,PUZ_1010)
puzzle(3,15,PUZ_1010)
puzzle(3,16,PUZ_1010)
puzzle(3,17,PUZ_1000)

puzzle(4,5,PUZ_0010)
puzzle(4,6,PUZ_1010)
puzzle(4,7,PUZ_1010)
puzzle(4,8,PUZ_0000)
puzzle(4,9,PUZ_1010)
puzzle(4,10,PUZ_1010)
puzzle(4,11,PUZ_1010)
puzzle(4,12,PUZ_1010)
puzzle(4,13,PUZ_1010)
puzzle(4,14,PUZ_1010)
puzzle(4,15,PUZ_1010)
puzzle(4,16,PUZ_1010)
puzzle(4,17,PUZ_0000)
puzzle(4,18,PUZ_1000)

puzzle(5,4,PUZ_0010)
puzzle(5,5,PUZ_1010)
puzzle(5,6,PUZ_1010)
puzzle(5,7,PUZ_1010)
puzzle(5,8,PUZ_1010)
puzzle(5,9,PUZ_0000)
puzzle(5,10,PUZ_1010)
puzzle(5,11,PUZ_1010)
puzzle(5,12,PUZ_1010)
puzzle(5,13,PUZ_1010)
puzzle(5,14,PUZ_1010)
puzzle(5,15,PUZ_1010)
puzzle(5,16,PUZ_0000)
puzzle(5,17,PUZ_1010)
puzzle(5,18,PUZ_1000)

puzzle(15,5,PUZ_0010)
puzzle(15,6,PUZ_1010)
puzzle(15,7,PUZ_1010)
puzzle(15,8,PUZ_1010)
puzzle(15,9,PUZ_1010)
puzzle(15,10,PUZ_0000)
puzzle(15,11,PUZ_1010)
puzzle(15,12,PUZ_1010)
puzzle(15,13,PUZ_1010)
puzzle(15,14,PUZ_1010)
puzzle(15,15,PUZ_0000)
puzzle(15,16,PUZ_1010)
puzzle(15,17,PUZ_1000)

puzzle(16,4,PUZ_0010)
puzzle(16,5,PUZ_1010)
puzzle(16,6,PUZ_1010)
puzzle(16,7,PUZ_1010)
puzzle(16,8,PUZ_1010)
puzzle(16,9,PUZ_1010)
puzzle(16,10,PUZ_1010)
puzzle(16,11,PUZ_0000)
puzzle(16,12,PUZ_1010)
puzzle(16,13,PUZ_1010)
puzzle(16,14,PUZ_0000)
puzzle(16,15,PUZ_1010)
puzzle(16,16,PUZ_1000)

puzzle(17,3,PUZ_0010)
puzzle(17,4,PUZ_1010)
puzzle(17,5,PUZ_1010)
puzzle(17,6,PUZ_1010)
puzzle(17,7,PUZ_1010)
puzzle(17,8,PUZ_0000)
puzzle(17,9,PUZ_1010)
puzzle(17,10,PUZ_1010)
puzzle(17,11,PUZ_1010)
puzzle(17,12,PUZ_0000)
puzzle(17,13,PUZ_1010)
puzzle(17,14,PUZ_1010)
puzzle(17,15,PUZ_1000)

set_stone("st-oneway_white-w", 6, 2)
set_stone("st-oneway_white-e",14, 2)
set_stone("st-oneway_black-w", 6,23)
set_stone("st-oneway_black-e",14,19)

set_item("it-yinyang",  7,10)
set_item("it-yinyang", 13,14)

set_actor("ac-blackball",  7.5,10.5)
set_actor("ac-whiteball", 13.5,14.5)










