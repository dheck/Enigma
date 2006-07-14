-- A level for Enigma
-- Name:        Welcome to the machine
-- Filename: 	ralf03.lua
-- Copyright: 	(C) Mar 2003 Ralf Westram
-- Contact: 	amgine@reallysoft.de
-- License: 	GPL v2.0 or above

Require("levels/lib/ralf.lua")

--debug_mode()

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

first = 1

lightfloorface = "fl-sahara"
darkfloorface  = "fl-tigris"
bluefloorface  = "fl-bluegray"

stonefaces   = { "st-rock1", "st-rock6", "st-rock2", "st-rock3"}
rotdirection = { 1, -1, 1, -1 }
switchface   = "st-switch"
borderface   = "st-rock5"

lightfloor   = cell{floor={face = lightfloorface}}
border       = cell{stone={face = borderface}}
--marble       = cell{item={face  = "ac-blackball", attr={player=0}, actor=1}}
marble       = cell{actor={face="ac-blackball", attr={player=0}}}

test = 0 -- test layout
easy = 1 -- 1=easy 0=hard

mx,my = 1,1

if (test==0) then
   floormap={
      "**   **",
      "*     *",
      "   !   ",
      "  !!!  ",
      "   !   ",
      "*     *",
      "**   **"
   }
   stonemap={
      "  #    ",
      " ##### ",
      "##   ##",
      " # O   ",
      " #   ##",
      " $# ## ",
      "  & #  "
   }
   metamap={
      "2413",
      "4324",
      "3112",
   }
   mx,my = 2,2

elseif (test==1) then
   easy = 1
   floormap={
      "* ! *",
      "  !  ",
      "!!!!!",
      "  !  ",
      "* ! *"
   }
   stonemap={
      " & & ",
      " # ##",
      "  O  ",
      "#$ # ",
      " # # "
   }
   metamap={
      "4231",
      "3421",
      "1234",
      "3142",
   }
   mx,my = 3,2

end

floorcells={}
floorcells["*"] = cell{parent = lightfloor}
floorcells[" "] = cell{floor={face = darkfloorface}}
floorcells["!"] = cell{floor={face = bluefloorface}}

-- ---------------
--     metamap
-- ---------------

usedmap   = nil
usedcells = nil
currmetacell = nil

function draw_used_metamap_oriented(x,y,flipx,flipy,rotate)
   draw_metamap_oriented(x,y,usedmap,usedcells,flipx, flipy,rotate)
end

metacellstate={1,2,3,4}
nextState={2,3,4,1} -- rotate
--nextState={2,1,4,3} -- toggle

function draw_metacell(x,y,metacellnum)
   currmetacell = metacellnum --store for switch callback
   draw_metamap_oriented(x,y,usedmap,usedcells,0,0,metacellstate[metacellnum])
end

metacells={}
metacells["1"] = cell{parent={{draw_metacell,1}}}
metacells["2"] = cell{parent={{draw_metacell,2}}}
metacells["3"] = cell{parent={{draw_metacell,3}}}
metacells["4"] = cell{parent={{draw_metacell,4}}}

function draw_my_metamap()
   draw_map(0,0,metamap,metacells)
end

-- ----------------
--     rotation
-- ----------------

function rot(cellnum)
   local oldstate = metacellstate[cellnum]
   local newstate = oldstate + rotdirection[cellnum]
   if (newstate < 1) then newstate = 4
   elseif (newstate > 4) then newstate = 1
   end

   metacellstate[cellnum] = newstate
   debug("rot cell #"..cellnum.." from state "..oldstate.." to "..newstate)

   draw_my_metamap()
end

function rot1() rot(1) end
function rot2() rot(2) end
function rot3() rot(3) end
function rot4() rot(4) end
function rot0() error("illegal rotation callback (0)")  end
function rot5() error("illegal rotation callback (5)")  end

function add_oxyd(x,y) if (first==1) then oxyd(x,y) end end
function add_stone(x,y) set_stone(stonefaces[currmetacell],x,y) end
function rem(x,y) if (first==0) then enigma.KillStone(x,y) end end

function repby_switch(x,y)
   rem(x,y)
   set_stone(switchface,x,y,{action="callback", target="rot"..currmetacell})
end
function repby_stone(x,y)
   rem(x,y)
   set_stone(stonefaces[currmetacell],x,y)
end
function repby_stone_or_gap(x,y)
   rem(x,y)
   if (currmetacell ~= 2) then
      set_stone(stonefaces[currmetacell],x,y)
   end
end


stonecells={}
stonecells["O"]=cell{parent={{add_oxyd}}}
stonecells[" "]=cell{parent={{rem}}}
stonecells["#"]=cell{parent={{repby_stone}}}
stonecells["$"]=cell{parent={{repby_switch}}}
if (easy==1) then
   stonecells["&"]=cell{parent={{repby_stone_or_gap}}}
else
   stonecells["&"]= stonecells["#"]
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- build the level

mapw,maph       = get_map_size(metamap)
blockw,blockh   = get_map_size(stonemap)
blockw2,blockh2 = get_map_size(floormap)

if ((blockh ~= blockh2) or (blockw ~= blockw2)) then
   error("floormap and stonemap must be of same size");
end

worldw,worldh = mapw*blockw+2,maph*blockh+2

create_world(worldw, worldh)
oxyd_default_flavor = "a"
enigma.ConserveLevel = FALSE

fill_world_func(lightfloor)
draw_border_func(border)

-- draw the floor
usedmap   = floormap
usedcells = floorcells
draw_my_metamap()

-- draw the items
usedmap = stonemap
usedcells = stonecells
draw_my_metamap()

first = 0

document(4*blockw,1*blockh,"Sections which have the same color always turn at the same time and in the same way.")
document(1,2*blockh,"Maintenance code: metal-stone-stone-stone-red-yellow-yellow-red-red-stone-stone")

oxyd_shuffle()
display.SetFollowMode(display.FOLLOW_SMOOTH)
marble(mx*blockw+0.5,my*blockh+0.5)


















