--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 25

create_world(levelw, levelh)
draw_border("st-rock5")
--enigma.ConserveLevel = FALSE
oxyd_default_flavor = "d"
fill_floor("fl-rough")

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c == "g" then
         set_stone("st-glass1",i-1,line)
      elseif c == "h" then
         set_stone("st-glass1_hole",i-1,line)
      elseif c == "r" then
         set_stone("st-rock5",i-1,line)
      elseif c == "l" then
         set_attrib(laser(i-1,line, TRUE, NORTH), "name", "laser")
      elseif c == "o" then
         oxyd( i-1, line)
      elseif c == "a" then
         set_actor("ac-blackball", i-.5,line+.5)
         set_item("it-yinyang", i-1, line+.5)
      elseif c == "b" then
         set_actor("ac-whiteball", i-.5,line+.5)
         set_item("it-yinyang", i-1, line+.5)
        end
    end
end
--              01234567890123456789
renderLine(00, "                    ")
renderLine(01, " gggggggggggggggggg ")
renderLine(02, " hh                 ")
renderLine(03, " hh        hhh      ")
renderLine(04, " hh        hhh      ")
renderLine(05, "           h        ")
renderLine(06, "                    ")
renderLine(07, "                    ")
renderLine(08, " hh                 ")
renderLine(09, " hh          hhh    ")
renderLine(10, " hh          hhh b  ")
renderLine(11, " gggggggggggggggggg ")
renderLine(12, " rrrrrrrrrrrrrrrrrr ")
renderLine(13, " rr      rrr    rrr ")
renderLine(14, " rr      g g     g  ")
renderLine(15, " o  gg   ggr r   gg ")
renderLine(16, " r g g      orgg    ")
renderLine(17, "   ggggg ggr   g    ")
renderLine(18, "   g   g g g   g    ")
renderLine(19, "  g  ggg ggggggg    ")
renderLine(20, " r gg  g            ")
renderLine(21, " o   ggg       r    ")
renderLine(22, " rr          ror    ")
renderLine(23, " rr          rrr al ")
renderLine(24, "                    ")
--              01234567890123456789

oxyd_shuffle()

set_stone("st-fourswitch",18, 2, {action="callback", target="mf01"})
set_attrib (mirrorp (18,14, 1,0,3), "name", "mirror01")
function mf01()
    mir=enigma.GetNamedObject("mirror01")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch",10, 2, {action="callback", target="mf02"})
set_attrib (mirrorp (10,14, 1,0,3), "name", "mirror02")
function mf02()
    mir=enigma.GetNamedObject("mirror02")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch",10, 6, {action="callback", target="mf03"})
set_attrib (mirrorp (10,18, 1,1,3), "name", "mirror03")
function mf03()
    mir=enigma.GetNamedObject("mirror03")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch", 6, 8, {action="callback", target="mf04"})
set_attrib (mirrorp ( 6,20, 1,1,3), "name", "mirror04")
function mf04()
    mir=enigma.GetNamedObject("mirror04")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch", 4, 4, {action="callback", target="mf05"})
set_attrib (mirrorp ( 4,16, 1,1,3), "name", "mirror05")
function mf05()
    mir=enigma.GetNamedObject("mirror05")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch", 4, 6, {action="callback", target="mf06"})
set_attrib (mirror3 ( 4,18, 1,0,1), "name", "mirror06")
function mf06()
    mir=enigma.GetNamedObject("mirror06")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch", 5, 6, {action="callback", target="mf07"})
set_attrib (mirror3 ( 5,18, 1,0,1), "name", "mirror07")
function mf07()
    mir=enigma.GetNamedObject("mirror07")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch", 6, 6, {action="callback", target="mf08"})
set_attrib (mirror3 ( 6,18, 1,0,1), "name", "mirror08")
function mf08()
    mir=enigma.GetNamedObject("mirror08")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch", 3, 7, {action="callback", target="mf09"})
set_attrib (mirror3 ( 3,19, 1,0,1), "name", "mirror09")
function mf09()
    mir=enigma.GetNamedObject("mirror09")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch", 4, 7, {action="callback", target="mf10"})
set_attrib (mirror3 ( 4,19, 1,0,1), "name", "mirror10")
function mf10()
    mir=enigma.GetNamedObject("mirror10")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch", 5, 8, {action="callback", target="mf11"})
set_attrib (mirror3 ( 5,20, 1,0,1), "name", "mirror11")
function mf11()
    mir=enigma.GetNamedObject("mirror11")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch",12, 5, {action="callback", target="mf12"})
set_attrib (mirror3 (12,17, 1,0,1), "name", "mirror12")
function mf12()
    mir=enigma.GetNamedObject("mirror12")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch",13, 5, {action="callback", target="mf13"})
set_attrib (mirror3 (13,17, 1,0,1), "name", "mirror13")
function mf13()
    mir=enigma.GetNamedObject("mirror13")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch",14, 5, {action="callback", target="mf14"})
set_attrib (mirror3 (14,17, 1,0,1), "name", "mirror14")
function mf14()
    mir=enigma.GetNamedObject("mirror14")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch",12, 6, {action="callback", target="mf15"})
set_attrib (mirror3 (12,18, 1,0,1), "name", "mirror15")
function mf15()
    mir=enigma.GetNamedObject("mirror15")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch",13, 6, {action="callback", target="mf16"})
set_attrib (mirror3 (13,18, 1,0,1), "name", "mirror16")
function mf16()
    mir=enigma.GetNamedObject("mirror16")
    SendMessage(mir, "turn")
end

set_stone("st-fourswitch",14, 6, {action="callback", target="mf17"})
set_attrib (mirror3 (14,18, 1,0,1), "name", "mirror17")
function mf17()
    mir=enigma.GetNamedObject("mirror17")
    SendMessage(mir, "turn")
end

set_stone("st-laserswitch", 2,16, {action="callback", target="sw1"})
set_stone("st-door", 2,15, {name="door1", type="v"})

function sw1()
    doora=enigma.GetNamedObject("door1")
    SendMessage(doora, "openclose")
end

set_stone("st-laserswitch",11,16, {action="callback", target="sw2"})
set_stone("st-door",12,15, {name="door2", type="h"})

function sw2()
    doora=enigma.GetNamedObject("door2")
    SendMessage(doora, "openclose")
end

set_stone("st-laserswitch", 2,20, {action="callback", target="sw3"})
set_stone("st-door", 2,21, {name="door3", type="v"})

function sw3()
    doora=enigma.GetNamedObject("door3")
    SendMessage(doora, "openclose")
end

set_stone("st-laserswitch",13,21, {action="callback", target="sw4"})
set_stone("st-door",14,21, {name="door4", type="h"})

function sw4()
    doora=enigma.GetNamedObject("door4")
    SendMessage(doora, "openclose")
end

document( 7,11, " ")
document( 8,11, " ")
document( 9,17, " ")
document(10,11, " ")











