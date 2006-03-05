-- Laser Crossing, a level for Enigma
-- Copyright (C) 2005 Lukas Schueller
-- Licensed under GPL v2.0 or above
-----------------------------------------------
function lasers()
  enigma.SendMessage(enigma.GetNamedObject("lasere1"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("lasere2"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("laserw1"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("laserw2"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("lasern1"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("lasern2"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("lasers1"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("lasers2"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("lasere3"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("lasere4"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("laserw3"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("laserw4"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("lasern3"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("lasern4"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("lasers3"),"onoff",nil)
  enigma.SendMessage(enigma.GetNamedObject("lasers4"),"onoff",nil)
end
-- Environment
CreateWorld(20, 13) 
fill_floor("fl-abyss", 0,0, 20,13)
fill_floor("fl-wood",1,4,18,5)
fill_floor("fl-wood",7,1,5,11)
set_attrib(laser(19,5, FALSE, WEST), "name", "laserw1")
set_attrib(laser(19,8, TRUE, WEST), "name", "laserw2")
set_attrib(laser(0,4, TRUE, EAST), "name", "lasere1")
set_attrib(laser(0,7, FALSE, EAST), "name", "lasere2")
set_attrib(laser(7,12, TRUE, NORTH), "name", "lasern1")
set_attrib(laser(10,12, FALSE, NORTH), "name", "lasern2")
set_attrib(laser(8,0, FALSE, SOUTH), "name", "lasers1")
set_attrib(laser(11,0, TRUE, SOUTH), "name", "lasers2")
set_attrib(laser(19,4, TRUE, WEST), "name", "laserw3")
set_attrib(laser(19,7, FALSE, WEST), "name", "laserw4")
set_attrib(laser(0,5, FALSE, EAST), "name", "lasere3")
set_attrib(laser(0,8, TRUE, EAST), "name", "lasere4")
set_attrib(laser(8,12, FALSE, NORTH), "name", "lasern3")
set_attrib(laser(11,12, TRUE, NORTH), "name", "lasern4")
set_attrib(laser(7,0, TRUE, SOUTH), "name", "lasers3")
set_attrib(laser(10,0, FALSE, SOUTH), "name", "lasers4")
local st1 = set_stone("st-rock4",0,6)
local st2 = set_stone("st-rock4",19,6)
local st3 = set_stone("st-rock4",9,0)
local st4 = set_stone("st-rock4",9,12)
set_stone("st-timer",0,0,{action="callback",target="lasers",interval=1})
oxyd_default_flavor = "d"
oxyd(6,3)
oxyd(6,9)
oxyd(12,3)
oxyd(12,9)
oxyd_shuffle()
local ac = set_actor("ac-blackball",9.5,6.5, {player=0})
if difficult then
  AddRubberBand(ac,st1,10,9)
  AddRubberBand(ac,st2,10,10)
  AddRubberBand(ac,st3,10,6)
  AddRubberBand(ac,st4,10,6)
end











