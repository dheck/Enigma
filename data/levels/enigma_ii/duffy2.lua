-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: The Disappearing Block

levelw = 39
levelh = 13

create_world(levelw, levelh)
enigma.ConserveLevel=FALSE

draw_border("st-greenbrown")
fill_floor("fl-hay")

oxyd(37,11)
oxyd(5,1)
oxyd(33,10)
oxyd(5,11)


set_item( "it-magicwand", 34,10)

set_stone("st-greenbrown",19,1)
set_stone("st-greenbrown",19,2)
set_stone("st-greenbrown",19,3)
set_stone("st-greenbrown",19,4)
set_stone("st-greenbrown",19,5)
set_stone("st-greenbrown",19,6)
set_stone("st-greenbrown",19,7)
set_stone("st-greenbrown_hole",19,8)
set_stone("st-greenbrown",19,9)
set_stone("st-greenbrown",19,10)
set_stone("st-greenbrown",19,11)
set_stone("st-greenbrown",19,12)

set_stone("st-greenbrown",2,2)
set_stone("st-greenbrown",3,2)
set_stone("st-greenbrown",4,2)
set_stone("st-greenbrown",5,2)
set_stone("st-greenbrown",6,2)
set_stone("st-greenbrown",6,1)

set_stone("st-greenbrown",2,10)
set_stone("st-greenbrown",3,10)
set_stone("st-greenbrown",4,10)
set_stone("st-greenbrown",5,10)
set_stone("st-greenbrown",6,10)
set_stone("st-greenbrown",6,11)


set_stone("st-greenbrown",19,11)
set_stone("st-greenbrown",20,11)
set_stone("st-greenbrown",21,11)
set_stone("st-greenbrown",23,11)
set_stone("st-greenbrown",24,11)
set_stone("st-greenbrown",25,11)
set_stone("st-greenbrown",26,11)
set_stone("st-greenbrown",27,11)
set_stone("st-greenbrown",28,11)
set_stone("st-greenbrown",29,11)
set_stone("st-greenbrown",30,11)
set_stone("st-greenbrown",31,11)
set_stone("st-greenbrown",32,11)
set_stone("st-greenbrown",33,11)
set_stone("st-greenbrown",34,11)
set_stone("st-greenbrown",35,11)
set_stone("st-greenbrown",36,11)
set_stone("st-greenbrown",38,11)

set_stone("st-door", 23, 6 , {name="door1", type="v"})
set_item("it-trigger", 22,11, {action="openclose", target="door1"})

set_stone("st-door", 37, 4 , {name="door2", type="h"})
set_item("it-trigger", 27,4, {action="openclose", target="door2"})

set_stone("st-door", 4, 1 , {name="door4", type="v"})
set_stone("st-key_a", 7, 11, {action="openclose", target="door4"})
set_item("it-key_a", 37 ,10)

set_stone("st-brownie",30,7)

fill_floor("fl-space", 25,1, 7,10)
fill_floor("fl-space", 32,1, 4,8)
fill_floor("fl-space", 36,1, 1,3)
fill_floor("fl-inverse", 24,1, 1,10)
fill_floor("fl-metal", 24,6, 1,1)
fill_floor("fl-metal", 30,3, 2,2)
fill_floor("fl-metal", 31,7, 2,2)

set_stone("st-greenbrown",36,9)
set_stone("st-greenbrown",36,8)
set_stone("st-greenbrown",36,7)
set_stone("st-greenbrown",36,6)
set_stone("st-greenbrown",36,5)
set_stone("st-greenbrown",36,4)
set_stone("st-greenbrown",35,9)
set_stone("st-greenbrown",34,9)
set_stone("st-greenbrown",33,9)
set_stone("st-greenbrown",32,9)
set_stone("st-greenbrown",32,10)

set_stone("st-greenbrown",23,1)
set_stone("st-greenbrown",23,2)
set_stone("st-greenbrown",23,3)
set_stone("st-greenbrown",23,4)
set_stone("st-greenbrown",23,5)
set_stone("st-greenbrown",23,7)
set_stone("st-greenbrown",23,8)
set_stone("st-greenbrown",23,9)
set_stone("st-greenbrown",23,10)
set_stone("st-greenbrown",23,11)

set_stone("st-greenbrown",17,5)
set_stone("st-greenbrown",17,7)

set_attrib(laser(0,6, TRUE, EAST), "name", "laser")

set_stone("st-bolder-s", 22,1)
set_stone("st-bolder-w", 22,2)
set_stone("st-bolder-w", 22,3)
set_stone("st-bolder-w", 22,4)
set_stone("st-bolder-w", 22,5)
set_stone("st-bolder-w", 22,6)
set_stone("st-bolder-w", 22,7)
set_stone("st-bolder-w", 22,8)
set_stone("st-bolder-w", 22,9)
set_stone("st-bolder-w", 22,10)

draw_stones("st-stone_break", {21,1}, {0,1},10)

set_stone("st-greenbrown",18,3)

hammer(2,1)

set_item("it-trigger", 18,7, {invisible=1,action="open", target="door3"})
set_stone("st-door_b", 17,6, {name="door3", type="v"})

set_actor("ac-blackball" ,10, 4)














