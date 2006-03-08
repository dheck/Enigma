--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 58
levelh = 13

create_world( levelw, levelh)
draw_border( "st-greenbrown")
fill_floor("fl-wood", 0,0, levelw,levelh)

oxyd(1, 1)
oxyd(1, 5)

oneway(9,6, enigma.SOUTH)

draw_stones("st-greenbrown", {1,6}, {1,0},6)
draw_stones("st-greenbrown", {10,6}, {1,0},43)
draw_stones("st-greenbrown", {8,1}, {0,1},2)
draw_stones("st-greenbrown", {8,4}, {0,1},3)
draw_stones("st-greenbrown", {8,8}, {1,0},5)
draw_stones("st-greenbrown", {17,10}, {1,0},5)
draw_stones("st-greenbrown", {27,8}, {1,0},5)
draw_stones("st-greenbrown", {36,10}, {1,0},5)
draw_stones("st-greenbrown", {46,8}, {1,0},5)
set_stones("st-greenbrown", {{10,9},{10,11},{19,7},{19,9},{29,9},{29,11},
                            {38,7},{38,9},{48,9},{48,11}})

draw_stones("st-death", {18,1}, {0,1},3)
draw_stones("st-death", {34,3}, {0,1},3)
draw_stones("st-death", {48,1}, {0,1},3)

set_stones("st-wood", {{14,8},{14,9},{15,10},{25,9},{26,9},{26,10},
                       {34,8},{34,9},{34,10},{44,9},{44,10},{45,8},
                       {52,8},{53,9},{54,9},{55,10}})
abyss(12,7)
abyss(16,8)
abyss(17,11)
abyss(22,11)
abyss(24,8)
abyss(28,7)
abyss(31,10)
abyss(33,10)
abyss(37,8)
abyss(40,11)
abyss(46,10)
abyss(50,10)
abyss(46,7)
abyss(53,6)
abyss(54,7)
abyss(55,8)

set_item("it-floppy", 3,9)

set_item("it-coin1", 4,8)
set_item("it-coin4", 49,1,{value=27})

set_stone("st-coinslot", 7,6, {action="openclose", target="bridge6"})
set_floor("fl-bridge", 8,3, {name="bridge6", type="y"})

set_stone("st-floppy", 10,7, {action="openclose", target="bridge1"})
set_floor("fl-bridge", 10,10, {name="bridge1", type="x"})

set_stone("st-floppy", 19,11, {action="openclose", target="bridge2"})
set_floor("fl-bridge", 19,8, {name="bridge2", type="x"})

set_stone("st-floppy", 29,7, {action="openclose", target="bridge3"})
set_floor("fl-bridge", 29,10, {name="bridge3", type="x"})

set_stone("st-floppy", 38,11, {action="openclose", target="bridge4"})
set_floor("fl-bridge", 38,8, {name="bridge4", type="x"})

set_stone("st-floppy", 48,7, {action="openclose", target="bridge5"})
set_floor("fl-bridge", 48,10, {name="bridge5", type="x"})

set_actor("ac-blackball", 5.5, 9.5)










