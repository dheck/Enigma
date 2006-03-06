--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

enigma.ConserveLevel=FALSE                  -- \dh\

levelw = 77
levelh = 25

create_world(levelw, levelh)
draw_border("st-marble")
fill_floor("fl-rough")

oxyd( 2, 2)
oxyd( 6, 2)

fill_floor("fl-abyss", 1,4, 3 ,1)
fill_floor("fl-abyss", 5,4, 3 ,1)

draw_stones("st-invisible", {5,9},{1,0}, 3)
draw_stones("st-invisible", {1,6},{1,0}, 6)
draw_stones("st-marble", {19,1},{0,1}, 3)
draw_stones("st-marble", {19,5},{0,1}, 7)
draw_stones("st-marble", {19,13},{0,1}, 6)
draw_stones("st-marble", {19,20},{0,1}, 4)
draw_stones("st-marble", {8,1},{0,1}, 11)
draw_stones("st-marble", {38,2},{0,1}, 2)
draw_stones("st-marble_hole", {38,1},{0,1}, 1)
draw_stones("st-marble", {38,5},{0,1}, 7)
draw_stones("st-marble", {38,13},{0,1}, 6)
draw_stones("st-marble", {38,20},{0,1}, 4)
draw_stones("st-marble", {57,1},{0,1}, 3)
draw_stones("st-marble", {57,5},{0,1}, 7)
draw_stones("st-marble", {57,13},{0,1}, 6)
draw_stones("st-marble", {57,20},{0,1}, 4)
draw_stones("st-marble", {5,12},{1,0}, 65)
draw_stones("st-marble", {1,12},{1,0}, 3)
draw_stones("st-marble", {71,12},{1,0}, 5)
set_stones("st-wood", {{12,2},{21,11},{55,11},{73,8},{74,22},
                            {40,21},{21,14},{37,1}})
set_stones("st-wood", {{14,3},{17,7},{16,9},{22,5},{28,7},
                            {31,4},{24,11},{44,2},{55,8}})
set_stones("st-wood", {{60,3},{67,7},{67,9},{61,16},{70,23},
                            {62,20},{43,18},{51,19},{55,18}})
set_stones("st-wood", {{22,23},{27,17},{25,19},{21,15},{33,17},
                            {7,19},{12,16},{4,10},{3,18}})
set_stones("st-invisible", {{3,8},{3,9},{3,10},{5,8},{5,10}})

set_item("it-coin2", 12,2 )
set_item("it-coin2", 21,11)
set_item("it-coin2", 37,1 )
set_item("it-coin2", 55,11)
set_item("it-coin2", 73,8 )
set_item("it-coin2", 74,22)
set_item("it-coin2", 40,21)
set_item("it-coin2", 21,14)

set_floor("fl-bridge", 4,4, {name="bridge1"})
set_item("it-trigger", 4,5, {target="bridge1", action="openclose"})
set_stone("st-coinslot", 13,11, {action="openclose", target="door1"})
doorv(19,4, {name="door1"})
set_stone("st-coinslot", 29,11, {action="openclose", target="door2"})
doorv(38,4, {name="door2"})
set_stone("st-coinslot", 49,11, {action="openclose", target="door3"})
doorv(57,4, {name="door3"})
set_stone("st-coinslot", 75,4, {action="openclose", target="door4"})
doorh(70,12, {name="door4"})
set_stone("st-coinslot", 75,19, {action="openclose", target="door5"})
doorv(57,19, {name="door5"})
set_stone("st-coinslot", 49,13, {action="openclose", target="door6"})
doorv(38,19, {name="door6"})
set_stone("st-coinslot", 29,13, {action="openclose", target="door7"})
doorv(19,19, {name="door7"})
set_stone("st-coinslot", 2,20, {action="openclose", target="door8"})
doorh(4,12, {name="door8"})

set_actor("ac-blackball", 13.5, 6.5)















