--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 13

create_world(levelw, levelh)
draw_border("st-greenbrown")
fill_floor("fl-wood")

oxyd(2,0)
oxyd(0,8)
oxyd(0,11)
oxyd(10,5)
oxyd(19,4)
oxyd(19,9)

draw_stones("st-greenbrown", {1,1}, {0,1}, 2)
draw_stones("st-greenbrown", {3,2}, {0,1}, 2)
draw_stones("st-greenbrown", {5,2}, {0,1}, 2)
draw_stones("st-greenbrown", {9,2}, {0,1}, 2)
draw_stones("st-greenbrown", {13,5}, {0,1}, 2)
draw_stones("st-greenbrown", {17,2}, {0,1}, 2)
draw_stones("st-greenbrown", {18,5}, {0,1}, 2)
draw_stones("st-greenbrown", {2,7}, {0,1}, 2)
draw_stones("st-greenbrown", {15,5}, {0,1}, 3)
draw_stones("st-greenbrown", {6,2}, {1,0}, 3)
draw_stones("st-greenbrown", {11,3}, {1,0}, 2)
draw_stones("st-greenbrown", {4,7}, {1,0}, 4)
draw_stones("st-greenbrown", {9,7}, {1,0}, 2)
draw_stones("st-greenbrown", {12,8}, {1,0}, 2)
draw_stones("st-greenbrown", {1,10}, {1,0}, 16)
set_stones("st-greenbrown", {{11,1},{14,1},{15,3},{1,4},{3,5},
                            {5,5},{7,5},{9,5},{11,5}})
set_stones("st-greenbrown", {{17,5},{10,8},{8,9},{15,9},{18,10}})

shogundot1( 8,1,{target="bridge1" , action="openclose"})
shogundot1(13,1,{target="bridge2" , action="openclose"})
shogundot1( 4,3,{target="bridge3" , action="openclose"})
shogundot1( 8,3,{target="bridge4" , action="openclose"})
shogundot1(16,3,{target="bridge5" , action="openclose"})
shogundot1(12,4,{target="bridge6" , action="openclose"})
shogundot1( 2,5,{target="bridge7" , action="openclose"})
shogundot1( 5,6,{target="bridge8" , action="openclose"})
shogundot1( 9,6,{target="bridge9" , action="openclose"})
shogundot1(16,6,{target="bridge10", action="openclose"})
shogundot1( 3,7,{target="bridge11", action="openclose"})
shogundot1(11,7,{target="bridge12", action="openclose"})
shogundot1(14,7,{target="bridge13", action="openclose"})
shogundot1(17,7,{target="bridge14", action="openclose"})
shogundot1( 4,9,{target="bridge15", action="openclose"})
shogundot1(12,9,{target="bridge16", action="openclose"})

set_stone("st-shogun-s", 5,1)
set_stone("st-shogun-s", 12,2)
set_stone("st-shogun-s", 15,2)
set_stone("st-shogun-s", 2,4)
set_stone("st-shogun-s", 4,4)
set_stone("st-shogun-s", 7,4)
set_stone("st-shogun-s", 9,4)
set_stone("st-shogun-s", 14,4)
set_stone("st-shogun-s", 17,4)
set_stone("st-shogun-s", 12,5)
set_stone("st-shogun-s", 4,6)
set_stone("st-shogun-s", 8,6)
set_stone("st-shogun-s", 4,8)
set_stone("st-shogun-s", 7,8)
set_stone("st-shogun-s", 15,8)
set_stone("st-shogun-s", 6,9)

set_floor("fl-bridge",  1,11, {name="bridge1", type="x"})
set_floor("fl-bridge",  2,11, {name="bridge2", type="x"})
set_floor("fl-bridge",  3,11, {name="bridge3", type="x"})
set_floor("fl-bridge",  4,11, {name="bridge4", type="x"})
set_floor("fl-bridge",  5,11, {name="bridge5", type="x"})
set_floor("fl-bridge",  6,11, {name="bridge6", type="x"})
set_floor("fl-bridge",  7,11, {name="bridge7", type="x"})
set_floor("fl-bridge",  8,11, {name="bridge8", type="x"})
set_floor("fl-bridge",  9,11, {name="bridge9", type="x"})
set_floor("fl-bridge", 10,11, {name="bridge10",type="x"})
set_floor("fl-bridge", 11,11, {name="bridge11",type="x"})
set_floor("fl-bridge", 12,11, {name="bridge12",type="x"})
set_floor("fl-bridge", 13,11, {name="bridge13",type="x"})
set_floor("fl-bridge", 14,11, {name="bridge14",type="x"})
set_floor("fl-bridge", 15,11, {name="bridge15",type="x"})
set_floor("fl-bridge", 16,11, {name="bridge16",type="x"})

set_actor("ac-blackball", 17.5,8.5)
















