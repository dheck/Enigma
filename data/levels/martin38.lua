--
-- A level for Enigma
--
-- Copyright (c) 2003 Martin Hawlisch
-- Licensed under the GPL version 2.

levelw = 20
levelh = 13

create_world( levelw, levelh)

draw_border( "st-death")
draw_stones( "st-death", {6,6}, {1,0}, 8)

draw_floor("fl-gradient", { 2, 1}, {1,0},  16, {type=2})
draw_floor("fl-gradient", { 3, 2}, {1,0},  14, {type=2})
draw_floor("fl-gradient", { 4, 3}, {1,0},  12, {type=2})
draw_floor("fl-gradient", { 5, 4}, {1,0},  10, {type=2})
draw_floor("fl-gradient", { 6, 5}, {1,0},   8, {type=2})

draw_floor("fl-gradient", { 2,11}, {1,0},  16, {type=1})
draw_floor("fl-gradient", { 3,10}, {1,0},  14, {type=1})
draw_floor("fl-gradient", { 4, 9}, {1,0},  12, {type=1})
draw_floor("fl-gradient", { 5, 8}, {1,0},  10, {type=1})
draw_floor("fl-gradient", { 6, 7}, {1,0},   8, {type=1})

draw_floor("fl-gradient", { 1, 2}, {0,1},   9, {type=4})
draw_floor("fl-gradient", { 2, 3}, {0,1},   7, {type=4})
draw_floor("fl-gradient", { 3, 4}, {0,1},   5, {type=4})
draw_floor("fl-gradient", { 4, 5}, {0,1},   3, {type=4})

draw_floor("fl-gradient", {18, 2}, {0,1},   9, {type=3})
draw_floor("fl-gradient", {17, 3}, {0,1},   7, {type=3})
draw_floor("fl-gradient", {16, 4}, {0,1},   5, {type=3})
draw_floor("fl-gradient", {15, 5}, {0,1},   3, {type=3})

draw_floor("fl-gradient", { 1, 1}, { 1, 1},   5, {type=12})

draw_floor("fl-gradient", {18, 1}, {-1, 1},   5, {type=10})

draw_floor("fl-gradient", { 1,11}, { 1,-1},   5, {type=11})

draw_floor("fl-gradient", {18,11}, {-1,-1},   5, {type=9})

oxyd( 5, 6)
oxyd(14, 6)
oxyd( 7, 5)
oxyd( 7, 7)
oxyd(12, 5)
oxyd(12, 7)

oxyd_shuffle()


set_actor("ac-blackball", 5.5, 7.5)
