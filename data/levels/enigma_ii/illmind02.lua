-- Disk Royal, a level for Enigma
-- Copyright (C) 2005 illmind
-- Licensed under GPL v2.0 or above

-- level dimensions and standards
levelw = 20
levelh = 25
create_world(levelw, levelh)
oxyd_default_flavor = "c"
draw_border("st-rock1")
fill_floor("fl-black", 0,0, level_width,level_height)

-- extra stones
set_stones("st-rock1", {{2,2},{4,2},{5,2},{6,2},{7,2},{8,2},{9,2},{10,2},{10,3},{17,3},{10,12},{11,12},{12,12}})
set_stones("st-rock1", {{2,4},{3,4},{4,4},{5,4},{6,4},{7,4},{8,4},{8,5},{17,5},{2,7},{6,7},{15,7},{17,7},{13,12}})
set_stones("st-rock1", {{10,4},{11,4},{12,4},{13,4},{14,4},{15,4},{16,4},{17,4},{2,8},{3,8},{4,8},{14,12},{15,12}})
set_stones("st-rock1", {{2,6},{3,6},{4,6},{5,6},{6,6},{8,6},{9,6},{10,6},{11,6},{12,6},{13,6},{14,6},{15,6},{16,12}})
set_stones("st-rock1", {{6,8},{7,8},{8,8},{9,8},{10,8},{11,8},{12,8},{13,8},{14,8},{15,8},{17,9},{17,12},{18,12}})
set_stones("st-rock1", {{4,10},{5,10},{6,10},{7,10},{8,10},{9,10},{10,10},{11,10},{12,10},{13,10},{14,10},{4,23}})
set_stones("st-rock1", {{15,10},{16,10},{17,10},{1,12},{2,12},{3,12},{4,12},{5,12},{6,12},{7,12},{8,12},{9,12}})
set_stones("st-rock1", {{2,17},{3,17},{4,17},{5,17},{6,17},{13,17},{14,17},{15,17},{16,17},{17,17},{15,23},{18,14}})
set_stones("st-rock1", {{4,13},{15,13},{1,14},{2,14},{4,14},{15,14},{5,15},{14,15},{15,15},{17,15},{2,15},{4,15}})
set_stones("st-rock1", {{2,19},{3,19},{4,19},{5,19},{6,19},{13,19},{14,19},{15,19},{16,19},{17,19},{2,20},{17,20}})
set_stones("st-rock1", {{2,21},{4,21},{5,21},{14,21},{15,21},{17,21},{1,22},{2,22},{4,22},{15,22},{17,22},{18,22}})
set_stones("st-rock1", {{2,16},{17,16},{17,14},{17,6},{17,8}})
set_stones("st-rock1_move", {{11,2},{8,16},{10,16},{11,16},{8,20},{9,20},{11,20}})
set_stones("st-rock1_hole", {{4,9},{1,15},{18,21},{2,3},{9,16},{10,20}})
set_stones("st-knight", {{1,9},{2,9},{3,9},{1,10},{3,10},{1,11},{2,11},{3,11}})
set_stones("st-stone_break", {{1,16},{18,16},{1,17},{18,17},{1,19},{18,19},{1,20},{18,20},{8,18},{11,18}})
set_stones("st-stone_break", {{8,17},{9,17},{10,17},{11,17},{8,19},{9,19},{10,19},{11,19}})
set_stones("st-stone_break", {{1,18},{2,18},{3,18},{4,18},{5,18},{14,18},{15,18},{16,18},{17,18},{18,18}})
set_stones("st-wood", {{16,2},{5,11},{12,19}})
set_stones("st-floppy", {{5,22},{14,22},{5,23},{6,23},{13,23},{14,23},{5,13},{6,13},{12,13},{14,13},{5,14}})

-- extra floors
set_floor("fl-abyss_fake", 6, 14)
set_floor("fl-abyss_fake", 6, 22)
set_floor("fl-abyss_fake", 13, 22)
set_floor("fl-abyss", 13,14)

-- trapdoors horizontal
set_stone("st-door", 3,  2, {name="ill01", type="h"})
set_stone("st-door", 3,  14, {name="ill02", type="h"})
set_stone("st-door", 16,  14, {name="ill03", type="h"})
set_stone("st-door", 3,  15, {name="ill04", type="h"})
set_stone("st-door", 16,  15, {name="ill05", type="h"})
set_stone("st-door", 3,  21, {name="ill06", type="h"})
set_stone("st-door", 16,  21, {name="ill07", type="h"})
set_stone("st-door", 3,  22, {name="ill08", type="h"})
set_stone("st-door", 16,  22, {name="ill09", type="h"})

-- trapdoors vertical
set_stone("st-door", 4,  7, {name="ill10", type="v"})
set_stone("st-door", 2,  13, {name="ill11", type="v"})
set_stone("st-door", 17,  13, {name="ill12", type="v"})
set_stone("st-door", 4,  16, {name="ill13", type="v"})
set_stone("st-door", 5,  16, {name="ill14", type="v"})
set_stone("st-door", 14,  16, {name="ill15", type="v"})
set_stone("st-door", 15,  16, {name="ill16", type="v"})
set_stone("st-door", 4,  20, {name="ill17", type="v"})
set_stone("st-door", 5,  20, {name="ill18", type="v"})
set_stone("st-door", 14,  20, {name="ill19", type="v"})
set_stone("st-door", 15,  20, {name="ill20", type="v"})
set_stone("st-door", 6,  18, {name="ill21", type="v"})
set_stone("st-door", 13,  18, {name="ill22", type="v"})
set_stone("st-door", 2,  23, {name="ill23", type="v"})
set_stone("st-door", 17,  23, {name="ill24", type="v"})

-- trigger platforms
set_item("it-trigger", 17, 1, {action="openclose", target="ill24"})
set_item("it-trigger", 17, 2, {action="openclose", target="ill10"})
set_item("it-trigger", 7, 14, {action="openclose", target="ill23"})
set_item("it-trigger", 12, 14, {action="openclose", target="ill14"})
set_item("it-trigger", 9, 18, {action="openclose", target="ill11"})
set_item("it-trigger", 10, 18, {action="openclose", target="ill21"})
set_item("it-trigger", 7, 22, {action="openclose", target="ill04"})
set_item("it-trigger", 12, 22, {action="openclose", target="ill22"})
set_item("it-trigger", 4, 11, {action="openclose", target="ill01"})

-- trigger floppystones
set_stone("st-floppy", 7, 13, {action="openclose", target="ill19"})
set_stone("st-floppy", 8, 13, {action="openclose", target="ill09"})
set_stone("st-floppy", 9, 13, {action="openclose", target="ill03"})
set_stone("st-floppy", 10, 13, {action="openclose", target="ill08"})
set_stone("st-floppy", 11, 13, {action="openclose", target="ill02"})
set_stone("st-floppy", 13, 13, {action="openclose", target="ill13"})
set_stone("st-floppy", 14, 14, {action="openclose", target="ill07"})
set_stone("st-floppy", 7, 23, {action="openclose", target="ill18"})
set_stone("st-floppy", 8, 23, {action="openclose", target="ill20"})
set_stone("st-floppy", 9, 23, {action="openclose", target="ill05"})
set_stone("st-floppy", 10, 23, {action="openclose", target="ill17"})
set_stone("st-floppy", 11, 23, {action="openclose", target="ill15"})
set_stone("st-floppy", 12, 23, {action="openclose", target="ill16"})
set_stone("st-floppy", 18, 15, {action="openclose", target="ill06"})
set_stone("st-floppy", 1, 21, {action="openclose", target="ill12"})

-- objects and items
set_item("it-floppy", 2,10)
set_item("it-floppy", 3,16)
set_item("it-floppy", 9,16)
set_item("it-floppy", 16,16)
set_item("it-floppy", 10,20)
set_item("it-floppy", 16,20)
set_item("it-sword", 1,15)
set_item("it-hammer", 3,13)

-- wormhole passageway
SetDefaultAttribs("it-wormhole", {range=0.0, strength=0.0})
set_item("it-wormhole", 3, 7, {targetx="1.5",targety="15.5"})
set_item("it-wormhole", 18, 21, {targetx="14.5",targety="2.5"})

-- documents
document(12,17," illmind's  disk  royal  ...")
document(10,14," is  black  always  beautifull  ?")

-- oxyd stones
oxyd(13,3)
oxyd(14,3)
oxyd(15,3)
oxyd(14,7)
oxyd(1,13)
oxyd(18,13)
oxyd(1,23)
oxyd(18,23)
oxyd_shuffle()

-- blackball
set_actor("ac-blackball", 12.5, 18.5, {player=0})






























