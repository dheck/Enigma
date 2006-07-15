--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 25

create_world(levelw, levelh)
draw_border("st-rock6")
enigma.ConserveLevel = FALSE
oxyd_default_flavor = "d"
fill_floor("fl-sahara")

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c == "t" then
         set_stone("st-thief",i-1,line)
      elseif c == "o" then
         oxyd( i-1, line)
      elseif c == "g" then
         set_stone("st-grate2",i-1,line)
      elseif c == "r" then
         set_stone("st-rock6",i-1,line)
      elseif c == "w" then
         set_stone("st-window",i-1,line)
      elseif c == "b" then
         set_stone("st-break_acblack",i-1,line)
      elseif c == "#" then
         mirrorp(i-1,line,TRUE,FALSE, 1)
      elseif c == "y" then
         mirrorp(i-1,line,FALSE,FALSE, 1)
      elseif c == "x" then
         mirrorp(i-1,line,FALSE,FALSE, 2)
      elseif c == "z" then
         mirrorp(i-1,line,FALSE,TRUE, 2)
      elseif c == "s" then
         set_stone("st-timer",i-1,line)
      elseif c == "a" then
         set_actor("ac-blackball", i-.5,line+.5)
      elseif c == "d" then
         document(i-1,line,"Forget the laser, try using force!")
        end
    end
end
--              01234567890123456789
renderLine(00, "                    ")
renderLine(01, "                    ")
renderLine(02, "  o         t       ")
renderLine(03, "        t           ")
renderLine(04, "     t              ")
renderLine(05, "                    ")
renderLine(06, "                    ")
renderLine(07, "         t          ")
renderLine(08, "                rrr ")
renderLine(09, "rrrrrrrrrrrrrr rrrr ")
renderLine(10, "               rrrr ")
renderLine(11, "               rrrr ")
renderLine(12, "rrrrrrwrrrrrr rrrrr ")
renderLine(13, "          ordbrrrgg ")
renderLine(14, "   #      y rbrsrgg ")
renderLine(15, "            rbr rgg ")
renderLine(16, "          a   ggggg ")
renderLine(17, "o                   ")
renderLine(18, "                    ")
renderLine(19, "          y  z    x ")
renderLine(20, "                    ")
renderLine(21, "                    ")
renderLine(22, "      y   o    y  x ")
renderLine(23, "                    ")
renderLine(24, "                    ")
--              01234567890123456789

oxyd_shuffle()

set_attrib(laser( 0,22, FALSE, EAST), "name", "laser1")
set_stone("st-switch", 0,21, {action="onoff", target="laser1"})

set_attrib(laser(15, 0, TRUE, SOUTH), "name", "laser2")
set_stone("st-laserswitch",15,09, {action="callback", target="sw1"})
set_stone("st-door",14,09, {name="door1", type="h"})

function sw1()
    SendMessage("door1", "openclose")
end

set_stone("st-laserswitch",15,15, {action="callback", target="sw2"})
set_stone("st-door",13,12, {name="door2", type="h"})

function sw2()
    SendMessage("door2", "open")
    SendMessage("laser2", "off")
end











