-- Laserpushing, a level for Enigma
-- Copyright (C) JAHR JuSt
-- Licensed under GPL v2.0 or above 
-- Level had been automatically created with Star.LUA Editor v0.32 beta

create_world(39, 13)
oxyd_default_flavor="b"

-- Floor Layer
fill_floor("fl-rough-blue")

-- Item Layer
set_item("it-vortex-open", 37, 1, {name="vortex16", targetx="11.5", targety="11.5", strength="1"})
set_item("it-trigger", 23, 3, {action="openclose", target="door17", invisible=FALSE})
set_item("it-trigger", 29, 5, {action="openclose", target="door18", invisible=FALSE})
set_item("it-trigger", 22, 8, {action="openclose", target="door20", invisible=FALSE})
set_item("it-trigger", 25, 8, {action="openclose", target="door19", invisible=FALSE})
set_item("it-trigger", 29, 9, {action="openclose", target="door21", invisible=FALSE})
set_item("it-trigger", 37, 11, {action="onoff", target="laser1", invisible=FALSE})

-- Stone Layer
oxyd(18, 10)
oxyd(1, 10)
oxyd(18, 8)
oxyd(1, 8)
oxyd(18, 6)
oxyd(1, 6)
oxyd(18, 4)
oxyd(1, 4)
oxyd(18, 2)
oxyd(1, 2)
draw_stones("st-rock6", {0, 0}, {1, 0}, 39)
draw_stones("st-rock6", {0, 1}, {0, 1}, 6)
draw_stones("st-glass3", {3, 1}, {0, 1}, 11)
draw_stones("st-glass3", {16, 1}, {0, 1}, 11)
draw_stones("st-rock6", {19, 1}, {0, 1}, 12)
draw_stones("st-pmirror", {32, 1}, {0, 1}, 3, {movable=FALSE, transparent=TRUE, orientation="4"})
draw_stones("st-rock6", {36, 1}, {0, 1}, 6)
draw_stones("st-rock6", {38, 1}, {0, 1}, 12)
draw_stones("st-pmirror", {32, 5}, {0, 1}, 6, {movable=FALSE, transparent=TRUE, orientation="2"})
draw_stones("st-rock6", {0, 8}, {0, 1}, 5)
draw_stones("st-rock6", {1, 12}, {1, 0}, 18)
draw_stones("st-rock6", {20, 12}, {1, 0}, 18)
set_stone("st-stoneimpulse", 21, 2, {name="stoneimpulse79"})
set_stone("st-door", 37, 2, {name="door17", type="h"})
set_stone("st-stoneimpulse", 21, 3, {name="stoneimpulse77"})
set_stones("st-wood", {{22, 3}, {29, 4}, {25, 7}, {22, 9}, {28, 9}})
set_stone("st-stoneimpulse", 24, 3, {name="stoneimpulse52"})
set_stone("st-stoneimpulse", 25, 3, {name="stoneimpulse53"})
set_stone("st-stoneimpulse", 26, 3, {name="stoneimpulse55"})
set_stone("st-stoneimpulse", 27, 3, {name="stoneimpulse56"})
set_stone("st-stoneimpulse", 28, 3, {name="stoneimpulse57"})
set_stone("st-stoneimpulse", 29, 3, {name="stoneimpulse45"})
set_stone("st-door", 37, 3, {name="door18", type="h"})
set_stones("st-3mirror", {{12, 4}, {8, 8}}, {movable=TRUE, transparent=FALSE, orientation="3"})
set_stone("st-stoneimpulse", 21, 4, {name="stoneimpulse74"})
set_stone("st-3mirror", 32, 4, {movable=FALSE, transparent=FALSE, orientation="1"})
set_stone("st-laser", 35, 4, {name="laser1", dir=WEST, on="0"})
set_stone("st-door", 37, 4, {name="door19", type="h"})
set_stone("st-stoneimpulse", 21, 5, {name="stoneimpulse75"})
set_stone("st-stoneimpulse", 22, 5, {name="stoneimpulse71"})
set_stone("st-door", 37, 5, {name="door20", type="h"})
set_stone("st-stoneimpulse", 22, 6, {name="stoneimpulse72"})
set_stone("st-stoneimpulse", 25, 6, {name="stoneimpulse80"})
set_stone("st-stoneimpulse", 26, 6, {name="stoneimpulse43"})
set_stone("st-stoneimpulse", 27, 6, {name="stoneimpulse50"})
set_stone("st-stoneimpulse", 28, 6, {name="stoneimpulse51"})
set_stone("st-stoneimpulse", 29, 6, {name="stoneimpulse44"})
set_stone("st-door", 37, 6, {name="door21", type="h"})
set_stone("st-laser", 0, 7, {name="laser94", dir=EAST, on="1"})
set_stone("st-stoneimpulse", 22, 7, {name="stoneimpulse48"})
set_stone("st-stoneimpulse", 23, 7, {name="stoneimpulse91"})
set_stone("st-stoneimpulse", 27, 8, {name="stoneimpulse78"})
set_stone("st-stoneimpulse", 25, 9, {name="stoneimpulse81"})
set_stone("st-stoneimpulse", 26, 9, {name="stoneimpulse42"})
set_stone("st-stoneimpulse", 27, 9, {name="stoneimpulse41"})
set_stone("st-stoneimpulse", 30, 9, {name="stoneimpulse40"})
set_stone("st-stoneimpulse", 22, 10, {name="stoneimpulse49"})
set_stone("st-stoneimpulse", 30, 10, {name="stoneimpulse67"})
set_stone("st-stoneimpulse", 22, 11, {name="stoneimpulse58"})
set_stone("st-stoneimpulse", 23, 11, {name="stoneimpulse59"})
set_stone("st-stoneimpulse", 24, 11, {name="stoneimpulse60"})
set_stone("st-stoneimpulse", 25, 11, {name="stoneimpulse61"})
set_stone("st-stoneimpulse", 26, 11, {name="stoneimpulse62"})
set_stone("st-stoneimpulse", 27, 11, {name="stoneimpulse63"})
set_stone("st-stoneimpulse", 28, 11, {name="stoneimpulse64"})
set_stone("st-stoneimpulse", 29, 11, {name="stoneimpulse65"})
set_stone("st-stoneimpulse", 30, 11, {name="stoneimpulse66"})
set_stone("st-pmirror", 32, 11, {movable=FALSE, transparent=TRUE, orientation="4"})

-- Actor Layer
set_actor("ac-blackball", 37.5, 11.5, {player="0", mouseforce="1"})

oxyd_shuffle()

-- Total Count: 93
-- Time: 0 sec 20 msec


























