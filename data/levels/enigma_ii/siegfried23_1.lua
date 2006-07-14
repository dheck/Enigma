--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 25

create_world(levelw, levelh)
draw_border("st-rock5")
fill_floor("fl-rough")
fill_floor("fl-water", 3,17, 16,2)
fill_floor("fl-water", 3,22, 16,2)
fill_floor("fl-water", 3,11,  2,5)
fill_floor("fl-water",17,11,  2,5)
fill_floor("fl-water", 7,13,  6,1)
fill_floor("fl-water", 8,15,  4,1)

oxyd_default_flavor = "c"

oxyd ( 3,21)
oxyd ( 5,19)
oxyd ( 7,21)
oxyd ( 9,20)
oxyd (11,19)
oxyd (13,20)
oxyd (15,19)
oxyd (17,21)
oxyd ( 5,11)
oxyd (14,13)
oxyd ( 6,15)
oxyd (13,15)

oxyd_shuffle()

draw_stones("st-rock5", { 2, 2}, {0,1}, 4)
draw_stones("st-rock5", { 2, 6}, {1,0}, 2)
draw_stones("st-rock5", { 2, 8}, {1,0}, 2)
draw_stones("st-rock5", { 4, 2}, {1,0}, 3)
draw_stones("st-rock5", { 4, 4}, {1,0}, 2)
draw_stones("st-rock5", { 5, 6}, {1,0}, 3)
draw_stones("st-rock5", { 5, 8}, {1,0}, 3)
draw_stones("st-rock5", { 7, 1}, {0,1}, 4)
draw_stones("st-rock5", { 9, 1}, {1,0}, 2)
draw_stones("st-rock5", { 9, 3}, {1,0}, 2)
draw_stones("st-rock5", {10, 7}, {1,0}, 3)
draw_stones("st-rock5", { 9, 4}, {0,1}, 4)
draw_stones("st-rock5", {11, 5}, {1,0}, 2)
draw_stones("st-rock5", {12, 4}, {1,0}, 3)
draw_stones("st-rock5", {14, 2}, {1,0}, 3)
draw_stones("st-rock5", {16, 4}, {1,0}, 2)
draw_stones("st-rock5", {14, 6}, {1,0}, 4)
draw_stones("st-rock5", {14, 8}, {1,0}, 4)
draw_stones("st-rock5", {13, 9}, {1,0}, 2)
draw_stones("st-rock5", {18, 1}, {0,1}, 2)
draw_stones("st-rock5", { 2,10}, {1,0}, 5)
draw_stones("st-rock5", { 8,10}, {1,0}, 4)
draw_stones("st-rock5", {13,10}, {1,0}, 6)
draw_stones("st-rock5", { 2,16}, {1,0},17)
draw_stones("st-rock5", { 2,17}, {0,1}, 2)
draw_stones("st-rock5", { 2,20}, {0,1}, 4)
draw_stones("st-rock5", { 2,11}, {0,1}, 5)
set_stones("st-rock5", {{5,5},{9,9},{11,9},{12,1},{12,3},{16,3}})
set_stones("st-rock5", {{3,17},{5,17},{7,17},{9,17},{11,17},
                       {13,17},{15,17},{17,17}})
set_stones("st-rock5", {{3,23},{5,23},{7,23},{9,23},{11,23},
                       {13,23},{15,23},{17,23}})
set_stones("st-rock5", {{3,11},{3,13},{3,15},{18,11},{18,13},{18,15}})

set_stone("st-oneway-e", 2, 7)
set_stone("st-oneway-e", 4, 3)
set_stone("st-oneway-e", 5, 7)
set_stone("st-oneway-e", 7, 7)
set_stone("st-oneway-e", 7, 9)
set_stone("st-oneway-e", 9, 2)
set_stone("st-oneway-e", 9, 8)
set_stone("st-oneway-e",12, 2)
set_stone("st-oneway-e",14, 1)
set_stone("st-oneway-e",14, 3)
set_stone("st-oneway-w",15, 5)
set_stone("st-oneway-w",17, 5)
set_stone("st-oneway-w",18, 6)
set_stone("st-oneway-n", 1, 4)
set_stone("st-oneway-n", 3, 2)
set_stone("st-oneway-n", 4, 6)
set_stone("st-oneway-n", 7,10)
set_stone("st-oneway-n", 8, 4)
set_stone("st-oneway-n",13, 7)
set_stone("st-oneway-s", 1, 6)
set_stone("st-oneway-s", 1, 8)
set_stone("st-oneway-s", 4, 8)
set_stone("st-oneway-s", 6, 4)
set_stone("st-oneway-s",11, 3)
set_stone("st-oneway-s",15, 4)
set_stone("st-oneway-s",18, 7)

set_stone("st-switch", 11,1, {action="openclose", target="door1"})
set_stone("st-switch", 10,9, {action="openclose", target="door2"})
doorh(12, 9, {name="door1"})
doorh(12,10, {name="door2"})

swc1 = 0;
function sw1()
   if (swc1 == 0) then
      SendMessage("bolder01", "direction",SOUTH)
      swc1 = 1
   end
end
function sw2()
   if (swc1 == 1) then
      SendMessage("bolder01", "direction",NORTH)
      swc1 = 0
   end
end
set_stone("st-bolder-n",  4,21, {name="bolder01"})
set_item("it-trigger",  4,17, {invisible=1, action="callback", target="sw1"})
set_item("it-trigger",  4,23, {invisible=1, action="callback", target="sw2"})

swc2 = 0;
function sw3()
   if (swc2 == 0) then
      SendMessage("bolder02", "direction",SOUTH)
      swc2 = 1
   end
end
function sw4()
   if (swc2 == 1) then
      SendMessage("bolder02", "direction",NORTH)
      swc2 = 0
   end
end
set_stone("st-bolder-n",  6,22, {name="bolder02"})
set_item("it-trigger",  6,17, {invisible=1, action="callback", target="sw3"})
set_item("it-trigger",  6,23, {invisible=1, action="callback", target="sw4"})

swc3 = 0;
function sw5()
   if (swc3 == 0) then
      SendMessage("bolder03", "direction",NORTH)
      swc3 = 1
   end
end
function sw6()
   if (swc3 == 1) then
      SendMessage("bolder03", "direction",SOUTH)
      swc3 = 0
   end
end
set_stone("st-bolder-s",  8,19, {name="bolder03"})
set_item("it-trigger",  8,23, {invisible=1, action="callback", target="sw5"})
set_item("it-trigger",  8,17, {invisible=1, action="callback", target="sw6"})

swc4 = 0;
function sw7()
   if (swc4 == 0) then
      SendMessage("bolder04", "direction",SOUTH)
      swc4 = 1
   end
end
function sw8()
   if (swc4 == 1) then
      SendMessage("bolder04", "direction",NORTH)
      swc4 = 0
   end
end
set_stone("st-bolder-n", 10,21, {name="bolder04"})
set_item("it-trigger", 10,17, {invisible=1, action="callback", target="sw7"})
set_item("it-trigger", 10,23, {invisible=1, action="callback", target="sw8"})

swc5 = 0;
function sw9()
   if (swc5 == 0) then
      SendMessage("bolder05", "direction",SOUTH)
      swc5 = 1
   end
end
function sw10()
   if (swc5 == 1) then
      SendMessage("bolder05", "direction",NORTH)
      swc5 = 0
   end
end
set_stone("st-bolder-n", 12,18, {name="bolder05"})
set_item("it-trigger", 12,17, {invisible=1, action="callback", target="sw9"})
set_item("it-trigger", 12,23, {invisible=1, action="callback", target="sw10"})

swc6 = 0;
function sw11()
   if (swc6 == 0) then
      SendMessage("bolder06", "direction",SOUTH)
      swc6 = 1
   end
end
function sw12()
   if (swc6 == 1) then
      SendMessage("bolder06", "direction",NORTH)
      swc6 = 0
   end
end
set_stone("st-bolder-n", 14,19, {name="bolder06"})
set_item("it-trigger", 14,17, {invisible=1, action="callback", target="sw11"})
set_item("it-trigger", 14,23, {invisible=1, action="callback", target="sw12"})

swc7 = 0;
function sw13()
   if (swc7 == 0) then
      SendMessage("bolder07", "direction",SOUTH)
      swc7 = 1
   end
end
function sw14()
   if (swc7 == 1) then
      SendMessage("bolder07", "direction",NORTH)
      swc7 = 0
   end
end
set_stone("st-bolder-n", 16,21, {name="bolder07"})
set_item("it-trigger", 16,17, {invisible=1, action="callback", target="sw13"})
set_item("it-trigger", 16,23, {invisible=1, action="callback", target="sw14"})

swc8 = 0;
function sw15()
   if (swc8 == 0) then
      SendMessage("bolder08", "direction",EAST)
      swc8 = 1
   end
end
function sw16()
   if (swc8 == 1) then
      SendMessage("bolder08", "direction",WEST)
      swc8 = 0
   end
end
set_stone("st-bolder-w",  6,12, {name="bolder08"})
set_item("it-trigger",  3,12, {invisible=1, action="callback", target="sw15"})
set_item("it-trigger", 18,12, {invisible=1, action="callback", target="sw16"})

swc9 = 0;
function sw17()
   if (swc9 == 0) then
      SendMessage("bolder09", "direction",EAST)
      swc9 = 1
   end
end
function sw18()
   if (swc9 == 1) then
      SendMessage("bolder09", "direction",WEST)
      swc9 = 0
   end
end
set_stone("st-bolder-w", 14,14, {name="bolder09"})
set_item("it-trigger",  3,14, {invisible=1, action="callback", target="sw17"})
set_item("it-trigger", 18,14, {invisible=1, action="callback", target="sw18"})

set_actor("ac-blackball", 1.5, 5.5)
















