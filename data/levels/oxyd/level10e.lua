--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 13

create_world(levelw, levelh)
fill_floor("fl-abyss")
fill_floor("fl-water")
fill_floor("fl-sahara", 1,2, 18,9)

oxyd_default_flavor = "d"

oxyd( 4, 4)
oxyd( 9, 4)
oxyd(14, 5)
oxyd( 9, 6)
oxyd( 4, 7)
oxyd(13, 7)

oxyd_shuffle()

set_stones("st-white4", {{9,5},{10,6},{16,5},{12,6},{8,7},{12,9}})
set_stones("st-black4", {{14,3},{7,4},{4,6},{5,6},{11,6},
                         {13,6},{15,7},{5,8},{13,8}})

set_stone("st-oneway_black-w", 2, 3)
set_stone("st-oneway_black-w", 4, 3)
set_stone("st-oneway_black-w",12, 4)
set_stone("st-oneway_black-w",12, 5)
set_stone("st-oneway_black-w",13, 5)
set_stone("st-oneway_black-w",15, 6)
set_stone("st-oneway_black-w", 2, 7)
set_stone("st-oneway_black-w", 3, 7)
set_stone("st-oneway_black-w", 9, 7)

set_stone("st-oneway_black-n", 3, 3)
set_stone("st-oneway_black-n", 7, 3)
set_stone("st-oneway_black-n", 3, 4)
set_stone("st-oneway_black-n", 5, 4)
set_stone("st-oneway_black-n", 2, 3)
set_stone("st-oneway_black-n",14, 4)
set_stone("st-oneway_black-n",16, 4)
set_stone("st-oneway_black-n",11, 5)
set_stone("st-oneway_black-n", 3, 6)
set_stone("st-oneway_black-n", 7, 6)
set_stone("st-oneway_black-n", 8, 6)
set_stone("st-oneway_black-n",14, 6)
set_stone("st-oneway_black-n", 5, 7)
set_stone("st-oneway_black-n",16, 7)
set_stone("st-oneway_black-n", 7, 8)
set_stone("st-oneway_black-n",15, 8)
set_stone("st-oneway_black-n",16, 8)
set_stone("st-oneway_black-n", 2, 9)
set_stone("st-oneway_black-n", 4, 9)
set_stone("st-oneway_black-n", 8, 9)
set_stone("st-oneway_black-n", 9, 9)
set_stone("st-oneway_black-n",11, 9)
set_stone("st-oneway_black-n",15, 9)

set_stone("st-oneway_black-e",11, 3)
set_stone("st-oneway_black-e",12, 7)
set_stone("st-oneway_black-e", 3, 8)

set_stone("st-oneway_black-n",11, 4)
set_stone("st-oneway_black-n", 4, 8)
set_stone("st-oneway_black-n", 3, 9)

set_stone("st-oneway_white-e", 5, 3)
set_stone("st-oneway_white-e", 8, 3)
set_stone("st-oneway_white-e",17, 3)
set_stone("st-oneway_white-e",13, 4)
set_stone("st-oneway_white-e", 2, 5)
set_stone("st-oneway_white-e", 3, 5)
set_stone("st-oneway_white-e", 5, 5)
set_stone("st-oneway_white-e", 7, 5)
set_stone("st-oneway_white-e", 8, 5)
set_stone("st-oneway_white-e",15, 5)
set_stone("st-oneway_white-e", 2, 6)
set_stone("st-oneway_white-e",16, 6)
set_stone("st-oneway_white-e",17, 6)
set_stone("st-oneway_white-e", 7, 7)
set_stone("st-oneway_white-e",10, 7)
set_stone("st-oneway_white-e",11, 7)
set_stone("st-oneway_white-e",14, 7)
set_stone("st-oneway_white-e", 6, 8)
set_stone("st-oneway_white-e", 8, 8)
set_stone("st-oneway_white-e", 9, 8)
set_stone("st-oneway_white-e",17, 8)

set_stone("st-oneway_white-s", 6, 3)
set_stone("st-oneway_white-s",10, 3)
set_stone("st-oneway_white-s",15, 3)
set_stone("st-oneway_white-s",17, 5)
set_stone("st-oneway_white-s", 6, 6)
set_stone("st-oneway_white-s",17, 7)
set_stone("st-oneway_white-s",14, 9)

set_stone("st-oneway_white-n", 9, 3)
set_stone("st-oneway_white-n",12, 3)
set_stone("st-oneway_white-n",13, 3)
set_stone("st-oneway_white-n",16, 3)
set_stone("st-oneway_white-n", 6, 4)
set_stone("st-oneway_white-n",10, 4)
set_stone("st-oneway_white-n",15, 4)
set_stone("st-oneway_white-n",17, 4)
set_stone("st-oneway_white-n", 4, 5)
set_stone("st-oneway_white-n", 6, 5)
set_stone("st-oneway_white-n",10, 5)
set_stone("st-oneway_white-n",10, 8)
set_stone("st-oneway_white-n",12, 8)
set_stone("st-oneway_white-n", 7, 9)
set_stone("st-oneway_white-n",10, 9)
set_stone("st-oneway_white-n",16, 9)
set_stone("st-oneway_white-n",17, 9)

set_stone("st-oneway_white-w", 2, 4)
set_stone("st-oneway_white-w", 8, 4)
set_stone("st-oneway_white-w", 6, 7)
set_stone("st-oneway_white-w", 2, 8)
set_stone("st-oneway_white-w",11, 8)
set_stone("st-oneway_white-w",14, 8)
set_stone("st-oneway_white-w", 5, 9)
set_stone("st-oneway_white-w", 6, 9)
set_stone("st-oneway_white-w",13, 9)

set_item("it-yinyang",  1, 4)
set_item("it-yinyang",  1, 8)

set_actor("ac-blackball", 1.5, 4.5)
set_actor("ac-whiteball", 1.5, 8.5)










