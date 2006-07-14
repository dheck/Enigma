--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 13

create_world(levelw, levelh)
draw_border("st-rock4")
fill_floor("fl-normal")

oxyd_default_flavor = "d"

oxyd ( 5, 5)
oxyd (14, 4)
oxyd ( 1, 6)
oxyd ( 4, 9)
oxyd (18, 3)
oxyd (18, 8)

oxyd_shuffle()

fill_floor("fl-abyss", 1, 1,18, 1)
fill_floor("fl-abyss", 1, 2, 3, 1)
fill_floor("fl-abyss", 3, 4, 1, 3)
fill_floor("fl-abyss", 3, 7, 6, 1)
fill_floor("fl-abyss", 8, 4, 1, 3)
fill_floor("fl-abyss", 9, 4, 2, 1)
fill_floor("fl-abyss",10, 5, 2, 1)
fill_floor("fl-abyss",12, 4, 1, 2)
fill_floor("fl-abyss",12, 2, 5, 1)
fill_floor("fl-abyss",17, 2, 1, 3)
fill_floor("fl-abyss",16, 4, 1, 4)
fill_floor("fl-abyss", 1, 2, 3, 1)
fill_floor("fl-abyss", 9, 9, 6, 1)
fill_floor("fl-abyss",14, 8, 3, 1)
fill_floor("fl-abyss",17,10, 2, 1)
fill_floor("fl-abyss", 5,10, 2, 1)
fill_floor("fl-abyss", 7, 9, 1, 2)
fill_floor("fl-abyss", 1,11,18, 1)

set_stone("st-oneway-w", 3, 3)
set_stone("st-oneway-w",12, 3)

set_item("it-hollow", 4, 3)
set_item("it-hollow",10,10)
set_item("it-hollow",17, 8)
set_item("it-hill", 2, 5)
set_item("it-hill", 5, 9)
set_item("it-hill", 7, 5)
set_item("it-hill",11, 3)
set_item("it-hill",12, 8)
set_item("it-hill",15,10)
set_item("it-hill",16, 3)
set_item("it-tinyhollow", 1,10)
set_item("it-tinyhollow", 7, 8)
set_item("it-tinyhollow", 9, 2)
set_item("it-tinyhollow",11, 4)
set_item("it-tinyhollow",18, 7)
set_item("it-tinyhill", 1, 7)
set_item("it-tinyhill", 8, 3)
set_item("it-tinyhill", 8, 9)
set_item("it-tinyhill", 9, 6)
set_item("it-tinyhill",15, 7)
set_item("it-tinyhill",17, 5)
set_item("it-tinyhill",18, 9)
set_item("it-crack3", 2, 3)
set_item("it-crack1", 1, 3)
set_item("it-crack2", 1, 4)
set_item("it-crack1", 1, 5)
set_item("it-crack1", 2, 4)
set_item("it-spade",12, 3)

SetDefaultAttribs("it-wormhole", {range=1.0, strength=5})
set_item("it-wormhole", 3, 3, {targetx="1.5",targety="10.5"})

function basis( x, y)
       set_floor("fl-gradient",   x, y,         {type=12})
       set_floor("fl-gradient",   x+1, y,       {type=10})
       set_floor("fl-gradient",   x, y+1,       {type=11})
       set_floor("fl-gradient",   x+1, y+1,     {type=9})
end

basis ( 5, 3)
basis ( 2, 8)
basis ( 9, 7)
basis (13, 5)

set_actor("ac-blackball",11.5,7.5)
















