-- tripple threat, a level for Enigma
-- Copyright (C) 2005 illmind
-- Licensed under GPL v2.0 or above 

-- level dimensions and standards
levelw = 20
levelh = 13
create_world(levelw, levelh)
oxyd_default_flavor = "d"
draw_border("st-rock1")
fill_floor("fl-black", 0,0, level_width,level_height)

-- extra stones in level
set_stones("st-rock1", {{1,2},{2,2},{3,2},{4,2},{5,2},{14,2},{15,2},{16,2},{17,2},{18,2}})
set_stones("st-rock1", {{1,4},{2,4},{3,4},{4,4},{5,4},{14,4},{15,4},{16,4},{17,4},{18,4}})
set_stones("st-rock1", {{1,6},{2,6},{3,6},{4,6},{5,6},{14,6},{15,6},{16,6},{17,6},{18,6}})
set_stones("st-rock1", {{1,8},{2,8},{3,8},{4,8},{5,8},{14,8},{15,8},{16,8},{17,8},{18,8}})
set_stones("st-rock1", {{1,10},{2,10},{3,10},{4,10},{5,10},{14,10},{15,10},{16,10},{17,10},{18,10}})
set_stone( "st-timer", 0, 0, {action="callback", target="ill_timer", interval=10})
-- set_stone("st-wood", 8, 2)

-- items and documents
set_item("it-document", 11,10, {text=" illmind's  tripple  threat  ..."})

-- westbound stationary lasers
set_stone("st-laser", 5, 1, {on=FALSE, dir=WEST, name="illactivator01"})
set_stone("st-laser", 5, 3, {on=FALSE, dir=WEST, name="illactivator02"})
set_stone("st-laser", 5, 5, {on=FALSE, dir=WEST, name="illactivator03"})
set_stone("st-laser", 5, 7, {on=FALSE, dir=WEST, name="illactivator04"})
set_stone("st-laser", 5, 9, {on=FALSE, dir=WEST, name="illactivator05"})
set_stone("st-laser", 5, 11, {on=FALSE, dir=WEST, name="illactivator06"})

-- eastbound stationary lasers
set_stone("st-laser", 14, 1, {on=FALSE, dir=EAST, name="illactivator07"})
set_stone("st-laser", 14, 3, {on=FALSE, dir=EAST, name="illactivator08"})
set_stone("st-laser", 14, 5, {on=FALSE, dir=EAST, name="illactivator09"})
set_stone("st-laser", 14, 7, {on=FALSE, dir=EAST, name="illactivator10"})
set_stone("st-laser", 14, 9, {on=FALSE, dir=EAST, name="illactivator11"})
set_stone("st-laser", 14, 11, {on=FALSE, dir=EAST, name="illactivator12"})

-- trapdoors vertical
set_stone("st-door", 2,  1, {name="illactivator13", type="v"})
set_stone("st-door", 3,  1, {name="illactivator14", type="v"})
set_stone("st-door", 2,  3, {name="illactivator15", type="v"})
set_stone("st-door", 3,  3, {name="illactivator16", type="v"})
set_stone("st-door", 2,  5, {name="illactivator17", type="v"})
set_stone("st-door", 3,  5, {name="illactivator18", type="v"})
set_stone("st-door", 2,  7, {name="illactivator19", type="v"})
set_stone("st-door", 3,  7, {name="illactivator20", type="v"})
set_stone("st-door", 2,  9, {name="illactivator21", type="v"})
set_stone("st-door", 3,  9, {name="illactivator22", type="v"})
set_stone("st-door", 2,  11, {name="illactivator23", type="v"})
set_stone("st-door", 3,  11, {name="illactivator24", type="v"})
set_stone("st-door", 16,  1, {name="illactivator25", type="v"})
set_stone("st-door", 17,  1, {name="illactivator26", type="v"})
set_stone("st-door", 16,  3, {name="illactivator27", type="v"})
set_stone("st-door", 17,  3, {name="illactivator28", type="v"})
set_stone("st-door", 16,  5, {name="illactivator29", type="v"})
set_stone("st-door", 17,  5, {name="illactivator30", type="v"})
set_stone("st-door", 16,  7, {name="illactivator31", type="v"})
set_stone("st-door", 17,  7, {name="illactivator32", type="v"})
set_stone("st-door", 16,  9, {name="illactivator33", type="v"})
set_stone("st-door", 17,  9, {name="illactivator34", type="v"})
set_stone("st-door", 16,  11, {name="illactivator35", type="v"})
set_stone("st-door", 17,  11, {name="illactivator36", type="v"})

-- trigger platforms
set_item("it-trigger", 7, 2, {action="openclose", target="illactivator17"})
set_item("it-trigger", 7, 3, {action="onoff", target="illactivator08"})
set_item("it-trigger", 7, 4, {action="openclose", target="illactivator34"})
set_item("it-trigger", 7, 5, {action="openclose", target="illactivator29"})
set_item("it-trigger", 7, 6, {action="openclose", target="illactivator22"})
set_item("it-trigger", 7, 7, {action="onoff", target="illactivator01"})
set_item("it-trigger", 7, 8, {action="onoff", target="illactivator12"})
set_item("it-trigger", 7, 9, {action="openclose", target="illactivator28"})
set_item("it-trigger", 7, 10, {action="onoff", target="illactivator04"})
set_item("it-trigger", 9, 2, {action="onoff", target="illactivator10"})
set_item("it-trigger", 9, 3, {action="openclose", target="illactivator15"})
set_item("it-trigger", 9, 4, {action="openclose", target="illactivator26"})
set_item("it-trigger", 9, 5, {action="onoff", target="illactivator03"})
set_item("it-trigger", 9, 6, {action="openclose", target="illactivator32"})
set_item("it-trigger", 9, 7, {action="openclose", target="illactivator19"})
set_item("it-trigger", 9, 8, {action="openclose", target="illactivator25"})
set_item("it-trigger", 9, 9, {action="onoff", target="illactivator06"})
set_item("it-trigger", 9, 10, {action="openclose", target="illactivator36"})
set_item("it-trigger", 10, 2, {action="openclose", target="illactivator31"})
set_item("it-trigger", 10, 3, {action="openclose", target="illactivator13"})
set_item("it-trigger", 10, 4, {action="openclose", target="illactivator23"})
set_item("it-trigger", 10, 5, {action="openclose", target="illactivator35"})
set_item("it-trigger", 10, 6, {action="onoff", target="illactivator11"})
set_item("it-trigger", 10, 7, {action="openclose", target="illactivator33"})
set_item("it-trigger", 10, 8, {action="onoff", target="illactivator07"})
set_item("it-trigger", 10, 9, {action="openclose", target="illactivator18"})
set_item("it-trigger", 10, 10, {action="openclose", target="illactivator20"})
set_item("it-trigger", 12, 2, {action="openclose", target="illactivator24"})
set_item("it-trigger", 12, 3, {action="onoff", target="illactivator05"})
set_item("it-trigger", 12, 4, {action="openclose", target="illactivator30"})
set_item("it-trigger", 12, 5, {action="openclose", target="illactivator14"})
set_item("it-trigger", 12, 6, {action="openclose", target="illactivator16"})
set_item("it-trigger", 12, 7, {action="onoff", target="illactivator09"})
set_item("it-trigger", 12, 8, {action="openclose", target="illactivator27"})
set_item("it-trigger", 12, 9, {action="onoff", target="illactivator02"})
set_item("it-trigger", 12, 10, {action="openclose", target="illactivator21"})

-- effect timer
mytimer=-1
function ill_timer()
mytimer=mytimer+1
if mytimer==0 then
fill_floor("fl-inverse", 0,0)
elseif mytimer==1 then
fill_floor("fl-black", 0,0)
mytimer=-1
end
end

-- oxyd stones
oxyd(1,1)
oxyd(1,3)
oxyd(1,5)
oxyd(1,7)
oxyd(1,9)
oxyd(1,11)
oxyd(18,1)
oxyd(18,3)
oxyd(18,5)
oxyd(18,7)
oxyd(18,9)
oxyd(18,11)

oxyd_shuffle()

-- multiplayer function with no yinyang
function multiplayer_mode()
actor={"ac-blackball", {player=0, mouseforce=1}}
actor={"ac-whiteball", {player=1, mouseforce=1}}
end

-- blackball
set_actor("ac-blackball", 11.5, 2.5, {player=0})

-- whiteball
set_actor("ac-whiteball", 8.5, 10.5, {player=1})

-- horse
set_actor("ac-horse", 8.5, 2.5)





















