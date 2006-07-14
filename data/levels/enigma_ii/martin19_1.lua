--
-- A level for Enigma
--
-- Copyright (c) 2003 Martin Hawlisch
-- Licensed under the GPL version 2.

levelw = 20
levelh = 25

stone="st-greenbrown"
mover="st-greenbrown_move"
hole="st-greenbrown_hole"

create_world( levelw, levelh)
draw_border(stone)

fill_floor("fl-hay", 0,0,levelw,levelh)

draw_stones( stone, {9, 1}, {0,1}, 11)
set_stone("st-floppy", 9, 4, {action="openclose", target="door1"})
doorv( 9, 5, {name="door1"})
set_item("it-floppy", 1,3)
set_stone( mover, 1, 3)
set_stone( mover, 2, 2)
set_stone( stone, 3, 1)

set_item( "it-magicwand", 18, 3)
set_stone( mover, 18, 3)
set_stone( mover, 17, 2)
set_stone( stone, 16, 1)

draw_stones( stone, {10,8}, {1,0}, 9)
set_stone( hole, 16, 8)
set_stone( "st-switch", 9,11, {action="openclose", target="door2"})
doorv( 13, 13, {name="door2"})

draw_stones( stone, {1,12}, {1,0}, 18)
set_stone( "st-stoneimpulse", 14, 12)
set_stone( mover, 14, 13)
set_stone( "st-floppy", 17,12, {action="openclose", target="door4"})
doorh( 18,12, {name="door4"})

draw_stones( stone, {13,14}, {0,1}, 10)
draw_stones( stone, {1,16}, {1,0}, 12)
draw_stones( stone, {6,13}, {0,1}, 11)
draw_stones( stone, {5,19}, {2,0}, 2)
draw_stones( stone, {5,21}, {2,0}, 2)

draw_stones( "st-wood", {14,18}, {1,0}, 5)
draw_stones( "st-wood", {14,20}, {1,0}, 5)

set_stone( "st-floppy", 13, 17, {action="openclose", target="door3"})
doorh( 7,16, {name="door3"})

enigma.KillStone(6, 20)
doorv(7,20, {name="door5"})
set_item("it-trigger", 8,20, {action="open", target="door5"})
set_item("it-trigger", 5,20, {invisible=1,action="close", target="door5"})

oneway( 2,16, enigma.SOUTH)
set_stone( mover, 3,12)
set_stone( mover, 3,13)

oxyd( 2, 1)
oxyd(17, 1)
oxyd(10,11)
oxyd( 2,14)
oxyd(18,14)
oxyd( 2,23)
oxyd(11,23)
oxyd(17,23)
oxyd_shuffle()


set_actor("ac-blackball", 5.5, 5.5)
















