-- Manamana, a level for Enigma
-- Copyright (C) 2005 JuSt
-- Licensed under GPL v2.0 or above 
-- Level had been automatically created with Star.LUA Editor v0.32 beta

create_world(39, 13)
oxyd_default_flavor="b"

-- Floor Layer
fill_floor("fl-gravel")
fill_floor("fl-water", 20, 1, 8, 5)
draw_floor("fl-water", {37, 1}, {0, 1}, 5)
draw_floor("fl-water", {29, 2}, {0, 1}, 4)
draw_floor("fl-water", {30, 5}, {1, 0}, 7)
fill_floor("fl-water", 20, 7, 8, 5)
draw_floor("fl-water", {37, 7}, {0, 1}, 5)
draw_floor("fl-water", {29, 11}, {1, 0}, 8)

-- Item Layer
draw_items("it-seed", {26, 2}, {1, 0}, 3)
set_item("it-yinyang", 2, 3)
draw_items("it-seed", {24, 3}, {1, 0}, 3)
set_item("it-hammer", 11, 4)
draw_items("it-seed", {21, 4}, {1, 0}, 4)
draw_items("it-seed", {20, 5}, {1, 0}, 2)
draw_items("it-seed", {20, 7}, {1, 1}, 3)
draw_items("it-seed", {21, 7}, {1, 1}, 3)
set_item("it-yinyang", 2, 9)
draw_items("it-seed", {24, 9}, {1, 0}, 3)
draw_items("it-seed", {26, 10}, {0, 1}, 2)
draw_items("it-seed", {27, 11}, {1, 0}, 2)

-- Stone Layer
oxyd(38, 8)
oxyd(38, 4)
draw_stones("st-stone1", {0, 0}, {1, 0}, 39)
draw_stones("st-stone1", {0, 1}, {0, 1}, 12)
draw_stones("st-stone1", {4, 1}, {0, 1}, 3)
draw_stones("st-stone1", {14, 1}, {0, 1}, 3)
draw_stones("st-stone1", {32, 1}, {0, 1}, 2)
draw_stones("st-stone1", {38, 1}, {0, 1}, 3)
draw_stones("st-puzzle", {7, 3}, {0, 1}, 3, {connections=PUZ_1010})
draw_stones("st-puzzle", {11, 3}, {1, 0}, 2, {connections=PUZ_1010, oxyd="1"})
draw_stones("st-stone1", {32, 4}, {0, 1}, 5)
draw_stones("st-stone1", {4, 5}, {0, 1}, 3)
draw_stones("st-stone1", {14, 5}, {0, 1}, 3)
draw_stones("st-stone1", {38, 5}, {0, 1}, 3)
draw_stones("st-stone1", {1, 6}, {1, 0}, 3)
draw_stones("st-stone1", {5, 6}, {1, 0}, 2)
draw_stones("st-stone1", {8, 6}, {1, 0}, 6)
draw_stones("st-stone1", {15, 6}, {1, 0}, 2)
draw_stones("st-stone1", {19, 6}, {1, 0}, 4)
draw_stones("st-stone1", {26, 6}, {1, 0}, 6)
draw_stones("st-stone1", {33, 6}, {1, 0}, 5)
draw_stones("st-puzzle", {7, 7}, {0, 1}, 4, {connections=PUZ_1010})
draw_stones("st-puzzle", {12, 8}, {-1, 1}, 2, {connections=PUZ_0001, oxyd="1"})
draw_stones("st-stone1", {4, 9}, {0, 1}, 4)
draw_stones("st-stone1", {14, 9}, {0, 1}, 4)
draw_stones("st-stone1", {38, 9}, {0, 1}, 4)
draw_stones("st-stone1", {32, 10}, {0, 1}, 3)
draw_stones("st-stone1", {1, 12}, {1, 0}, 3)
draw_stones("st-stone1", {5, 12}, {1, 0}, 9)
draw_stones("st-stone1", {15, 12}, {1, 0}, 17)
draw_stones("st-stone1", {33, 12}, {1, 0}, 5)
set_stones("st-pmirror", {{17, 1}, {23, 1}}, {movable=FALSE, transparent=FALSE, orientation="2"})
set_stones("st-puzzle", {{6, 2}, {6, 11}}, {connections=PUZ_0100})
set_stone("st-puzzle", 7, 2, {connections=PUZ_0011})
set_stone("st-laser", 18, 2, {name="laser1", dir=EAST, on="0"})
set_stones("st-3mirror", {{25, 2}, {23, 10}}, {movable=FALSE, transparent=FALSE, orientation="2"})
set_stone("st-puzzle", 10, 3, {connections=PUZ_1100, oxyd="1"})
set_stones("st-puzzle", {{10, 4}, {12, 5}, {11, 8}, {14, 8}, {11, 10}}, {connections=PUZ_0101, oxyd="1"})
set_stones("st-puzzle", {{12, 4}, {12, 9}}, {connections=PUZ_0110, oxyd="1"})
set_stones("st-pmirror", {{17, 4}, {17, 9}}, {movable=TRUE, transparent=TRUE, orientation="2"})
set_stone("st-break_bolder", 6, 5)
set_stone("st-puzzle", 10, 5, {connections=PUZ_0011, oxyd="1"})
set_stone("st-puzzle", 11, 5, {connections=PUZ_1001, oxyd="1"})
set_stone("st-puzzle", 7, 6, {connections=PUZ_0000})
set_stone("st-switch_black", 17, 6, {action="onoff", target="laser2", on="1", name="switch5"})
set_stone("st-switch_white", 18, 6, {action="onoff", target="laser1", on="1", name="switch6"})
set_stones("st-glass", {{23, 6}, {25, 6}}, {type="0"})
set_stone("st-stone1", 24, 6)
set_stone("st-puzzle", 13, 8, {connections=PUZ_1110, oxyd="1"})
set_stone("st-puzzle", 13, 9, {connections=PUZ_1000, oxyd="1"})
set_stone("st-laser", 18, 10, {name="laser2", dir=EAST, on="0"})
set_stone("st-puzzle", 7, 11, {connections=PUZ_1001})
set_stones("st-pmirror", {{17, 11}, {25, 11}}, {movable=FALSE, transparent=FALSE, orientation="4"})

-- Actor Layer
set_actor("ac-blackball", 2.5, 3.5, {player="0", mouseforce="1"})
set_actor("ac-whiteball", 2.5, 9.5, {player="1", mouseforce="1"})

oxyd_shuffle()



















