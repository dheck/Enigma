-- A level for Enigma
-- Name:        ZigZag
-- Filename:    ralf06.lua
-- Copyright: 	(C) May 2003 Ralf Westram
-- Contact: 	amgine@reallysoft.de
-- License: 	GPL v2.0 or above

Require("levels/lib/ralf.lua")

--debug_mode()

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

level={
   "iiiiiiiiiiiii@@@@@@@",
   "iSi@@SSSSSSSi  @@@@@",
   "i@i  @@SSSoSi  !b! x",
   "i@<+>^ @SSSii B@@@@@",
   "i@  .+ @SSni@  !b! x",
   "iS@@ v. @@SiiB @@@@@",
   "iSSS@<+>^ @Si a!b!Xx",
   "iSSS@  .+ @Si B@@@@@",
   "iSsSS@@ v. @i  ! ! x",
   "iSSSSSS@<+>@i  @@@@@",
   "iSoSSSS@  i@i  | | x",
   "iSSSSSSS@@iSi  @@@@@",
   "iiiiiiiiiiiii@@@@@@@",
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

triggers = 0
function set_trigger(x,y)
   triggers=triggers+1
   set_item("it-trigger",x,y,{action="openclose", target="door"..triggers});
end

function set_two_triggers(x,y)
   set_trigger(x,y)
   set_trigger(x+1,y+1)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

doors=0
function set_door(x,y,t,o)
   doors=doors+1
   set_stone("st-door",x,y,{name="door"..doors,type=t})
   if (o==1) then
      SendMessage("door"..doors, "open")
   end
end
function set_doorvc(x,y) set_door(x,y,"v",0) end
function set_doorhc(x,y) set_door(x,y,"h",0) end
function set_doorvo(x,y) set_door(x,y,"v",1) end
function set_doorho(x,y) set_door(x,y,"h",1) end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function toggle0()
   SendMessage("laser1", "on")
   SendMessage("laser2", "on")
end
function toggle1()
   enigma.KillStone(12,4);
   set_stone("st-switch",12,4,{action="callback",target="toggle0"});
end
function toggle2()
   xdoors(1,2)
   xbridge(1,2)
end
function toggle3()
   xdoors(3,4)
   xbridge(3,4)
end
function toggle4()
   xdoors(5,6)
   xbridge(5,6)
end
function toggle5()
   xdoors(7,8)
end

function xdoors(d1,d2)
   SendMessage("door"..d1, "openclose")
   SendMessage("door"..d2, "openclose")
end
function xbridge(b1,b2)
   SendMessage("bridge"..b1, "openclose")
   SendMessage("bridge"..b2, "openclose")
end

switches=0
function set_switch(x,y)
   switches=switches+1
   set_stone("st-switch",x,y,{action="callback",target="toggle"..switches})
end

bridges=0
function set_bridgec(x,y)
   bridges=bridges+1
   set_floor("fl-bridge",x,y,{name="bridge"..bridges})
end
function set_bridgeo(x,y)
   set_bridgec(x,y)
   SendMessage("bridge"..bridges, "openclose")
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

cells={}

cells["S"] = cell{floor="fl-space"}

if (difficult) then
   cells[" "] = cell{floor="fl-inverse"} --hard
else
   cells[" "] = cell{floor="fl-white"} --easy
end

cells["#"] = cell{parent=cells[" "],stone="st-rock6"}
cells["@"] = cell{parent=cells[" "],stone="st-glass"}
cells["a"] = cell{parent=cells[" "],actor={"ac-blackball", {player=0}}}
--cells["A"] = cell{parent=cells[" "],actor={"ac-whiteball", {player=0,mouseforce=0}}}
cells["."] = cell{parent=cells[" "],actor={"ac-whiteball-small", {player=1,mouseforce=0}}}
cells["o"] = cell{oxyd}

cells["+"] = cell{parent=cells[" "],stone="st-turnstile-green"}
cells["^"] = cell{parent={cells[" "],set_two_triggers},stone="st-turnstile-n"}
cells["v"] = cell{parent=cells[" "],stone="st-turnstile-s"}
cells["<"] = cell{parent={cells[" "],set_two_triggers},stone="st-turnstile-w"}
cells[">"] = cell{parent=cells[" "],stone="st-turnstile-e"}

cells["i"] = cell{parent=cells[" "],stone="st-stoneimpulse"}
cells["I"] = cell{parent=cells["!"],stone="st-stoneimpulse_movable"}

cells["|"] = cell{parent={cells[" "],set_doorvc}}
cells["!"] = cell{parent={cells[" "],set_doorvo}}
cells["-"] = cell{parent={cells[" "],set_doorhc}}
cells["_"] = cell{parent={cells[" "],set_doorho}}

cells["x"] = cell{parent={cells[" "],set_switch}}
cells["n"] = cell{parent=cells[" "],stone={"st-laser", {on=FALSE, dir=NORTH, name="laser1"}}}
cells["s"] = cell{parent=cells[" "],stone={"st-laser", {on=FALSE, dir=SOUTH, name="laser2"}}}

cells["b"] = cell{parent={set_bridgec}}
cells["B"] = cell{parent={set_bridgeo}}

cells["X"] = cell{parent=cells[" "],item="it-extralife"}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

rs_create_world(level,cells)
oxyd_shuffle()


















