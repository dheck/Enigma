--
-- A level for Enigma
--
-- Copyright (c) 2002 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 13

create_world( levelw, levelh)

fill_floor("fl-rough", 0,0,levelw,levelh)
draw_border( "st-rock1")

oxyd_default_flavor = "a"

oxyd( 3, 0)
oxyd( 6, 0)
oxyd( 13, 0)
oxyd( 16, 0)
oxyd( 19, 4)
oxyd( 19, 8)
oxyd( 0, 4)
oxyd( 0, 8)
oxyd( 3, 12)
oxyd( 9, 12)
oxyd( 13, 12)
oxyd( 16, 12)

oxyd_shuffle()

function yy1( color, x, y)
        stone = format( "st-%s4", color)
        set_stone( stone, x, y)
end

yy1( "white",  3, 3)
yy1( "white",  9, 3)
yy1( "white", 15, 3)
yy1( "white",  5, 4)
yy1( "white", 11, 4)
yy1( "white", 17, 4)
yy1( "white",  2, 5)
yy1( "white",  8, 5)
yy1( "white", 14, 5)
yy1( "white",  4, 6)
yy1( "white", 10, 6)
yy1( "white", 16, 6)
yy1( "white",  4, 9)
yy1( "white", 10, 9)
yy1( "white", 15, 9)
yy1( "black",  7, 3)
yy1( "black", 13, 3)
yy1( "black",  6, 6)
yy1( "black",  12,6)
yy1( "black",  2, 7)
yy1( "black",  8, 7)
yy1( "black", 14, 7)
yy1( "black",  5, 8)
yy1( "black", 11, 8)
yy1( "black", 17, 8)
yy1( "black",  6, 9)
yy1( "black", 12, 9)

draw_stones( "st-stoneimpulse", { 2, 3}, {0,1},  2)
draw_stones( "st-stoneimpulse", { 4, 3}, {1,0},  3)
draw_stones( "st-stoneimpulse", { 8, 3}, {0,1},  2)
draw_stones( "st-stoneimpulse", {10, 3}, {1,0},  3)
draw_stones( "st-stoneimpulse", {14, 3}, {0,1},  2)
draw_stones( "st-stoneimpulse", {16, 3}, {1,0},  2)
draw_stones( "st-stoneimpulse", { 2, 6}, {1,0},  2)
draw_stones( "st-stoneimpulse", { 5, 5}, {0,1},  3)
draw_stones( "st-stoneimpulse", { 7, 6}, {1,0},  3)
draw_stones( "st-stoneimpulse", {11, 5}, {0,1},  3)
draw_stones( "st-stoneimpulse", {13, 6}, {1,0},  3)
draw_stones( "st-stoneimpulse", {17, 5}, {0,1},  3)
draw_stones( "st-stoneimpulse", { 2, 9}, {1,0},  2)
draw_stones( "st-stoneimpulse", { 7, 9}, {1,0},  3)
draw_stones( "st-stoneimpulse", {13, 9}, {1,0},  2)
draw_stones( "st-stoneimpulse", {16, 9}, {1,0},  2)
set_stones("st-stoneimpulse", {{2,8},{8,8},{14,8}})
set_stones("st-stoneimpulse", {{5,9},{11,9}})
set_stones("st-wood", {{3,4},{6,4},{9,4},{12,4},{15,4}})
set_stones("st-wood", {{3,7},{6,7},{9,7},{12,7},{15,7}})
set_stones("st-rock1", {{1,6},{18,6}})
set_stones("st-rock1", {{2,1},{17,1},{2,11},{17,11}})
draw_stones( "st-rock1", { 1, 1}, {0,1},  2)
draw_stones( "st-rock1", { 5, 1}, {0,1},  2)
draw_stones( "st-rock1", { 8, 1}, {0,1},  2)
draw_stones( "st-rock1", {11, 1}, {0,1},  2)
draw_stones( "st-rock1", {14, 1}, {0,1},  2)
draw_stones( "st-rock1", {18, 1}, {0,1},  2)
draw_stones( "st-rock1", { 1,10}, {0,1},  2)
draw_stones( "st-rock1", { 5,10}, {0,1},  2)
draw_stones( "st-rock1", { 8,10}, {0,1},  2)
draw_stones( "st-rock1", {11,10}, {0,1},  2)
draw_stones( "st-rock1", {14,10}, {0,1},  2)
draw_stones( "st-rock1", {18,10}, {0,1},  2)

set_item("it-yinyang", 6,11)
set_item("it-yinyang", 9,1)

set_actor("ac-blackball", 6.5, 11.5)
set_actor("ac-whiteball",  9.5, 1.5)















