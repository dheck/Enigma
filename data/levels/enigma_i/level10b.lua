--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 153
levelh =  61

create_world(levelw, levelh)
fill_floor("fl-space")

oxyd(  8, 6)
oxyd( 27, 6)
oxyd( 46, 6)
oxyd( 65, 6)
oxyd( 84, 6)
oxyd(103, 6)
oxyd(122, 6)
oxyd(141, 6)
oxyd(  8,18)
oxyd( 27,18)
oxyd( 46,18)
oxyd( 65,18)
oxyd( 84,18)
oxyd(103,18)
oxyd(122,18)
oxyd(141,18)

oxyd_shuffle()

function basis1( x, y)
       draw_stones("st-rock5", { x, y},     {1,0}, 8)
       draw_stones("st-rock5", { x, y+4},   {1,0}, 8)
       draw_stones("st-rock5", { x, y+1},   {0,1}, 3)
       draw_stones("st-rock5", { x+7, y+1}, {0,1}, 3)
       draw_floor("fl-gradient", {x+1,y+2}, {0,1}, 1, {type=3})
       draw_floor("fl-gradient", {x+2, y+1},{1,0}, 4, {type=1})
       draw_floor("fl-gradient", {x+6,y+2}, {0,1}, 1, {type=4})
       draw_floor("fl-gradient", {x+2,y+3}, {1,0}, 4, {type=2})
       set_floor("fl-gradient",   x+1, y+1,           {type=5})
       set_floor("fl-gradient",   x+6, y+1,           {type=6})
       set_floor("fl-gradient",   x+1, y+3,           {type=7})
       set_floor("fl-gradient",   x+6, y+3,           {type=8})
       fill_floor("fl-normal",    x+2,y+2, 4,1)
       set_item("it-hollow",      x+4,y+2)
end

basis1 (  6, 4)
basis1 ( 25, 4)
basis1 ( 44, 4)
basis1 ( 63, 4)
basis1 ( 82, 4)
basis1 (101, 4)
basis1 (120, 4)
basis1 (139, 4)
basis1 (  6,16)
basis1 ( 25,16)
basis1 ( 44,16)
basis1 ( 63,16)
basis1 ( 82,16)
basis1 (101,16)
basis1 (120,16)
basis1 (139,16)

function basis2( x, y)
       fill_floor("fl-metal",     x+1,y+3, 18,7)
       draw_stones("st-rock5",   {x, y+2},    {1,0},20)
       draw_stones("st-rock5",   {x, y+10},   {1,0},20)
       draw_stones("st-rock5",   {x, y+3},    {0,1}, 7)
       draw_stones("st-rock5",   {x+19, y+3}, {0,1}, 7)
       draw_floor("fl-gradient", {x+1,y+5}, {0,1}, 1, {type=3})
       draw_floor("fl-gradient", {x+2, y+4},{1,0},16, {type=1})
       draw_floor("fl-gradient", {x+18,y+5},{0,1}, 1, {type=4})
       draw_floor("fl-gradient", {x+2,y+6}, {1,0},16, {type=2})
       set_floor("fl-gradient",   x+1, y+4,           {type=5})
       set_floor("fl-gradient",   x+18, y+4,          {type=6})
       set_floor("fl-gradient",   x+1, y+6,           {type=7})
       set_floor("fl-gradient",   x+18, y+6,          {type=8})
       fill_floor("fl-normal",    x+2,y+5, 16,1)
       set_item("it-hollow",      x+10,y+8)
end

basis2 (38,48)
basis2 (95,48)

SetDefaultAttribs("it-wormhole", {range=1.0, strength=10})

set_item("it-wormhole", 11, 6, {targetx="48.5",targety="56.5"})
set_item("it-wormhole", 30, 6, {targetx="48.5",targety="56.5"})
set_item("it-wormhole", 49, 6, {targetx="105.5",targety="56.5"})
set_item("it-wormhole", 68, 6, {targetx="105.5",targety="56.5"})
set_item("it-wormhole", 87, 6, {targetx="48.5",targety="56.5"})
set_item("it-wormhole",106, 6, {targetx="48.5",targety="56.5"})
set_item("it-wormhole",125, 6, {targetx="105.5",targety="56.5"})
set_item("it-wormhole",144, 6, {targetx="105.5",targety="56.5"})
set_item("it-wormhole", 11,18, {targetx="48.5",targety="56.5"})
set_item("it-wormhole", 30,18, {targetx="48.5",targety="56.5"})
set_item("it-wormhole", 49,18, {targetx="105.5",targety="56.5"})
set_item("it-wormhole", 68,18, {targetx="105.5",targety="56.5"})
set_item("it-wormhole", 87,18, {targetx="48.5",targety="56.5"})
set_item("it-wormhole",106,18, {targetx="48.5",targety="56.5"})
set_item("it-wormhole",125,18, {targetx="105.5",targety="56.5"})
set_item("it-wormhole",144,18, {targetx="105.5",targety="56.5"})

set_item("it-wormhole", 40,53, {targetx="10.5",targety="6.5"})
set_item("it-wormhole", 41,53, {targetx="29.5",targety="6.5"})
set_item("it-wormhole", 42,53, {targetx="48.5",targety="6.5"})
set_item("it-wormhole", 43,53, {targetx="67.5",targety="6.5"})
set_item("it-wormhole", 44,53, {targetx="86.5",targety="6.5"})
set_item("it-wormhole", 45,53, {targetx="105.5",targety="6.5"})
set_item("it-wormhole", 46,53, {targetx="124.5",targety="6.5"})
set_item("it-wormhole", 47,53, {targetx="143.5",targety="6.5"})
set_item("it-wormhole", 48,53, {targetx="10.5",targety="18.5"})
set_item("it-wormhole", 49,53, {targetx="29.5",targety="18.5"})
set_item("it-wormhole", 50,53, {targetx="48.5",targety="18.5"})
set_item("it-wormhole", 51,53, {targetx="67.5",targety="18.5"})
set_item("it-wormhole", 52,53, {targetx="86.5",targety="18.5"})
set_item("it-wormhole", 53,53, {targetx="105.5",targety="18.5"})
set_item("it-wormhole", 54,53, {targetx="124.5",targety="18.5"})
set_item("it-wormhole", 55,53, {targetx="143.5",targety="18.5"})

set_item("it-wormhole", 97,53, {targetx="10.5",targety="18.5"})
set_item("it-wormhole", 98,53, {targetx="29.5",targety="18.5"})
set_item("it-wormhole", 99,53, {targetx="48.5",targety="18.5"})
set_item("it-wormhole",100,53, {targetx="67.5",targety="18.5"})
set_item("it-wormhole",101,53, {targetx="86.5",targety="18.5"})
set_item("it-wormhole",102,53, {targetx="105.5",targety="18.5"})
set_item("it-wormhole",103,53, {targetx="124.5",targety="18.5"})
set_item("it-wormhole",104,53, {targetx="143.5",targety="18.5"})
set_item("it-wormhole",105,53, {targetx="10.5",targety="6.5"})
set_item("it-wormhole",106,53, {targetx="29.5",targety="6.5"})
set_item("it-wormhole",107,53, {targetx="48.5",targety="6.5"})
set_item("it-wormhole",108,53, {targetx="67.5",targety="6.5"})
set_item("it-wormhole",109,53, {targetx="86.5",targety="6.5"})
set_item("it-wormhole",110,53, {targetx="105.5",targety="6.5"})
set_item("it-wormhole",111,53, {targetx="124.5",targety="6.5"})
set_item("it-wormhole",112,53, {targetx="143.5",targety="6.5"})

draw_stones( "st-magic", { 39,57}, {1,0}, 1)
draw_stones( "st-magic", { 96,57}, {1,0}, 2)

display.SetFollowMode(display.FOLLOW_SCROLLING)

set_actor("ac-blackball", 48.5, 56.5)















