-- The First!, a level for Enigma
-- Copyright (C) 2005 capkoh
-- Licensed under GPL v2.0 or above 
-- Level had been automatically created with Star.LUA Editor v0.32 beta

create_world(20, 13)
oxyd_default_flavor="b"

-- Code
dir=0
function bolder()
enigma.SendMessage(enigma.GetNamedObject("bolder1"),"direction",dir)
if dir==3 then dir=-1 end
dir=dir+1
end

-- Floor Layer
fill_floor("fl-wood")
fill_floor("fl-ice_001", 15, 1, 2, 4)
fill_floor("fl-ice_001", 17, 3, 2, 2)

-- Item Layer
set_item("it-hammer", 12, 1)
set_item("it-trigger", 17, 2, {action="openclose", target="d1", invisible=FALSE})
draw_items("it-yinyang", {2, 3}, {1, 0}, 2)
set_item("it-pipe-h", 2, 7)
set_item("it-magnet", 11, 7, {name="magnet1", strength="10", on="0"})
set_item("it-trigger", 2, 8, {action="callback", target="bolder", invisible=FALSE})
set_item("it-trigger", 10, 8, {action="onoff", target="magnet1", invisible=FALSE})
draw_items("it-pipe-h", {2, 10}, {0, 1}, 2)

-- Stone Layer
oxyd(6, 12)
oxyd(19, 10)
oxyd(10, 1)
oxyd(8, 1)
draw_stones("st-marble", {0, 0}, {1, 0}, 15)
draw_stones("st-actorimpulse", {15, 0}, {1, 0}, 2)
draw_stones("st-actorimpulse", {18, 0}, {1, 0}, 2)
draw_stones("st-marble", {0, 1}, {0, 1}, 12)
draw_stones("st-marble", {4, 1}, {0, 1}, 6)
draw_stones("st-marble", {9, 1}, {0, 1}, 3)
draw_stones("st-marble", {7, 3}, {1, 0}, 2)
draw_stones("st-marble", {12, 3}, {1, 0}, 2)
draw_stones("st-grate3", {14, 3}, {0, 1}, 3)
draw_stones("st-actorimpulse", {19, 3}, {0, 1}, 2)
draw_stones("st-grate3", {15, 5}, {1, 0}, 2)
draw_stones("st-marble", {19, 5}, {0, 1}, 5)
draw_stones("st-marble", {10, 7}, {1, 1}, 2)
draw_stones("st-marble", {4, 8}, {0, 1}, 5)
draw_stones("st-stone_break", {17, 9}, {0, 1}, 3)
draw_stones("st-stone_break", {5, 10}, {1, 0}, 3)
draw_stones("st-marble", {19, 11}, {0, 1}, 2)
draw_stones("st-marble", {1, 12}, {1, 0}, 3)
draw_stones("st-marble", {7, 12}, {1, 0}, 12)
set_stones("st-rubberband", {{17, 0}, {19, 2}}, {strength="10", length="2"})
set_stones("st-grate3", {{14, 1}, {18, 5}})
set_stone("st-actorimpulse", 19, 1)
set_stone("st-bolder", 5, 2, {name="bolder1", direction=NORTH})
set_stones("st-scissors", {{14, 2}, {17, 5}})
set_stones("st-marble", {{5, 3}, {10, 3}, {5, 12}})
set_stones("st-blocker", {{6, 3}, {18, 10}, {6, 11}})
set_stone("st-door", 11, 3, {name="d1", type="h"})
set_stone("st-mail-e", 1, 7)
set_stones("st-brownie", {{2, 7}, {2, 10}})
set_stone("st-glass", 4, 7, {type="0"})
set_stones("st-stone_break", {{18, 9}, {5, 11}, {7, 11}, {18, 11}})

-- Actor Layer
set_actor("ac-blackball", 3, 3, {player="0", mouseforce="1"})
set_actor("ac-horse", 12.5, 6.5)
set_actor("ac-whiteball", 12.5, 9.5, {player="1", mouseforce="1"})

oxyd_shuffle()


















