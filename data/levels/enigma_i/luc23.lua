-- Advanced Lasers, a level for Enigma
-- Copyright (C) 2006 Lukas Schueller
-- Licensed under GPL v2.0 or above

enigma.ConserveLevel = FALSE

--some functions
function killit()
  set_stone("st-glass",17,6)
end
function closedoors()
  enigma.SendMessage(enigma.GetNamedObject("door1"),"close",nil)
  enigma.SendMessage(enigma.GetNamedObject("door2"),"close",nil)
end
function opendoors()
  enigma.SendMessage(enigma.GetNamedObject("door1"),"open",nil)
  enigma.SendMessage(enigma.GetNamedObject("door2"),"open",nil)
end
function startlasers()
  enigma.SendMessage(enigma.GetNamedObject("laser1"),"on",nil)
  enigma.SendMessage(enigma.GetNamedObject("timer"),"on",nil)
end
------------------------------
function writeLine( line, cells)
  for i=1, strlen(cells) do
    local c = strsub(cells,i,i)
    if(c =="#") then
      set_stone("st-brick",i-1,line)
    elseif(c == "/") then
      mirrorp(i-1,line,TRUE,FALSE,4)
    elseif(c == "K") then
      mirror3(i-1,line,FALSE,FALSE,2)
    elseif(c == "-") then
      set_attrib(laser(i-1,line,FALSE,EAST),"name","laser1")
    elseif(c == "+") then
      set_attrib(laser(i-1,line,FALSE,EAST),"name","laser2")
    elseif(c == "V") then
      set_stone("st-oneway-s",i-1,line)
    elseif(c == "1") then
      set_stone("st-laserswitch",i-1,line,{action="callback",target="closedoors"})
    elseif(c == "2") then
      set_stone("st-laserswitch",i-1,line,{action="callback",target="killit"})
    elseif(c == "s") then
      set_stone("st-switch",i-1,line,{action="callback",target="startlasers"})
    elseif(c == "*") then
      set_stone("st-door_a",i-1,line,{name="door1"})
    elseif(c == "~") then
      set_stone("st-door_a",i-1,line,{name="door2"})
    elseif(c =="o") then
      oxyd(i-1,line)
    elseif(c =="0") then
      set_actor("ac-blackball",i-0.5,line+0.5,{player="0"})
    end
  end
end

CreateWorld(20,14)
fill_floor("fl-gray",0,0,20,14)
oxyd_default_flavor="c"
----------------------------------
--Environment
writeLine(00,"####################")
writeLine(01,"#0               #o#")
writeLine(02,"#  /  /  /  /  / #*#")
writeLine(03,"#                # #")
writeLine(04,"#                # #")
writeLine(05,"#                # #")
writeLine(06,"-                1K#")
writeLine(07,"+                2 #")
writeLine(08,"#                # #")
writeLine(09,"#                # #")
writeLine(10,"#V#              #~#")
writeLine(11,"# #              #o#")
writeLine(12,"#s##################")
set_stone("st-timer",0,13,{action="on",target="laser2",interval=0.015,name="timer"})
SendMessage("timer","off")
opendoors()
oxyd_shuffle()



















