-- Glacial Chasm, a level for Enigma
-- Copyright (C) 2006 Lukas Schueller
-- Licensed under GPL v2.0 or above
-------------------------------------------------
-- Environment
CreateWorld(20,13)
fill_floor("fl-sahara")
draw_border("st-bluegray")
fill_floor("fl-abyss",6,1,13,11)
fill_floor("fl-sahara",9,6,2,1)
fill_floor("fl-sahara",13,0,7,13)
draw_border("st-grate1",1,1,18,11)
set_floor("fl-bridge",8,4,{name="bridgea"})
set_floor("fl-bridge",8,8,{name="bridgeb"})
set_floor("fl-bridge",11,6,{name="bridgec"})
set_floor("fl-bridge",12,6,{name="bridged"})
set_item("it-magicwand",2,11)
set_item("it-trigger",9,6,{action="openclose",target="bridgea",invisible=1})
set_item("it-trigger",10,6,{action="openclose",target="bridgeb",invisible=1})
set_stone("st-switch",9,3,{action="openclose",target="bridgec"})
set_stone("st-switch",9,9,{action="openclose",target="bridged"})
oxyd_default_flavor = "d"
oxyd(0,1)
oxyd(0,6)
oxyd(0,11)
oxyd(19,1)
oxyd(19,6)
oxyd(19,11)
oxyd(14,6)
oxyd(16,6)
oxyd_shuffle()
------------------------------------------------
-- Puzzles
puzzle(3,4,PUZ_0010)
puzzle(4,4,PUZ_0010)
puzzle(5,4,PUZ_0010)
puzzle(3,5,PUZ_1010)
puzzle(4,5,PUZ_1010)
puzzle(5,5,PUZ_1010)
puzzle(3,6,PUZ_1010)
puzzle(4,6,PUZ_1010)
puzzle(5,6,PUZ_1010)
puzzle(3,7,PUZ_1010)
puzzle(4,7,PUZ_1010)
puzzle(5,7,PUZ_1010)
puzzle(3,8,PUZ_1000)
puzzle(4,8,PUZ_1000)
puzzle(5,8,PUZ_1000)
puzzle(3,3,PUZ_0101)
puzzle(4,3,PUZ_0101)
puzzle(5,3,PUZ_0101)
puzzle(3,9,PUZ_0101)
puzzle(4,9,PUZ_0101)
puzzle(5,9,PUZ_0101)
-----------------------------------------------
-- Actor
set_actor("ac-blackball",1.5,6.5,{player=0})



