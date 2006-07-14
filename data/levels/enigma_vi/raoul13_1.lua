-- Oxydrings, a level for Enigma
-- Copyright (C) 2006 Raoul Bourquin
-- Licensed under GPL v2.0 or above 
-- YAPSL (Yet Another PuzzleStone Level)

-- GENERAL --
Require("levels/lib/libpuzzle.lua")
levelw = 20
levelh = 13
create_world(levelw, levelh)
enigma.ConserveLevel = FALSE

-- DESIGN --
boden="fl-abyss_fake"
wand="st-glass"
bodenk="fl-normal"

-- FLOOR --
fill_floor(boden, 0,0,levelw,levelh)

fill_floor(bodenk,2,2,3,3)
fill_floor(bodenk,2,8,3,3)
fill_floor(bodenk,15,2,3,3)
fill_floor(bodenk,15,8,3,3)

--holes:
--self
set_item("it-wormhole",4,4,{targetx="3.5",targety="4.5",strength="1",range="1"})
set_item("it-wormhole",15,4,{targetx="15.5",targety="3.5",strength="1",range="1"})
set_item("it-wormhole",15,8,{targetx="16.5",targety="8.5",strength="1",range="1"})
set_item("it-wormhole",4,8,{targetx="4.5",targety="9.5",strength="1",range="1"})
--clock
set_item("it-wormhole",4,2,{targetx="17.5",targety="3.5",strength="1",range="1"})
set_item("it-wormhole",17,4,{targetx="16.5",targety="10.5",strength="1",range="1"})
set_item("it-wormhole",15,10,{targetx="2.5",targety="9.5",strength="1",range="1"})
set_item("it-wormhole",2,8,{targetx="3.5",targety="2.5",strength="1",range="1"})
--counterclock
set_item("it-wormhole",2,4,{targetx="3.5",targety="10.5",strength="1",range="1"})
set_item("it-wormhole",4,10,{targetx="17.5",targety="9.5",strength="1",range="1"})
set_item("it-wormhole",17,8,{targetx="16.5",targety="2.5",strength="1",range="1"})
set_item("it-wormhole",15,2,{targetx="2.5",targety="3.5",strength="1",range="1"})
--cross
set_item("it-wormhole",17,2,{targetx="3.5",targety="8.5",strength="1",range="1"})
set_item("it-wormhole",2,10,{targetx="16.5",targety="4.5",strength="1",range="1"})
set_item("it-wormhole",2,2,{targetx="15.5",targety="9.5",strength="1",range="1"})
set_item("it-wormhole",17,10,{targetx="4.5",targety="3.5",strength="1",range="1"})

-- ACTORS --
actor1=set_actor("ac-blackball", 4.5,4.5, {player=0})

-- OXYD --
oxyd(3,3)
oxyd(3,9)
oxyd(16,3)
oxyd(16,9)
oxyd_default_flavor = "d"
oxyd_shuffle()

-- RINGS --
puzzle({{1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1},{1,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,1},{1,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,1},{1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1},{0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0},{0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0},{1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1},{1,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,1},{1,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,1},{1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1}},2,2,"blue","no")

