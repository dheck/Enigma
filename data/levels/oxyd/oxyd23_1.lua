--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 73

create_world(levelw, levelh)
enigma.ConserveLevel = FALSE
enigma.SetCompatibility("oxyd1")
oxyd_default_flavor = "a"
fill_floor("fl-abyss")
fill_floor("fl-rough", 0, 0, level_width, 48)
fill_floor("fl-wood", 0,49, level_width,10)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c =="#" then
         fill_floor("fl-abyss", i-1,line, 1,1)
      elseif c =="x" then
         fill_floor("fl-wood", i-1,line, 1,1)
      elseif c == "o" then
         oxyd( i-1, line)
      elseif c == "r" then
         set_stone("st-rock1",i-1,line)
      elseif c == "h" then
         set_stone("st-rock1_hole",i-1,line)
      elseif c == "i" then
         set_stone("st-invisible",i-1,line)
      elseif c == "g" then
         set_stone("st-glass",i-1,line)
      elseif c == "s" then
         set_stone("st-rock6",i-1,line)
      elseif c == "l" then
         set_stone("st-actorimpulse",i-1,line)
      elseif c == "b" then
         set_stone("st-block",i-1,line)
      elseif c=="n" then
         set_stone("st-oneway-n", i-1,line)
      elseif c=="m" then
         set_stone("st-oneway-w", i-1,line)
      elseif c == "w" then
         set_stone("st-break_acwhite",i-1,line)
      elseif c == "a" then
         set_actor("ac-blackball", i-.5,line+.5)
      elseif c == "d" then
         document(i-1,line,"Don't believe all that you see!")
        end
    end
end
--              01234567890123456789
renderLine(00, "                    ")
renderLine(01, "                    ")
renderLine(02, "                    ")
renderLine(03, "                    ")
renderLine(04, "                    ")
renderLine(05, "                    ")
renderLine(06, "                    ")
renderLine(07, "                    ")
renderLine(08, "                    ")
renderLine(09, "                    ")
renderLine(10, "                    ")
renderLine(11, "                    ")
renderLine(12, "rrrrrrrgrrrrrrrrrr r")
renderLine(13, "r      i r i      or")
renderLine(14, "r rhrrhr h rhrrir  r")
renderLine(15, "r r h  r r i  r r  r")
renderLine(16, "r r r  r r r  h r  r")
renderLine(17, "r i rirrhr h  r rirr")
renderLine(18, "r r    h i r  r    r")
renderLine(19, "r hhrrrr r rrhrrirrr")
renderLine(20, "r r i  r h         r")
renderLine(21, "r r r  r r         r")
renderLine(22, "r r r    r         r")
renderLine(23, "rdr r    r         r")
renderLine(24, "rrrrrrrgrrrrrrrrrr r")
renderLine(25, "r      i r i      or")
renderLine(26, "r rhrrhr h rhrrir  r")
renderLine(27, "r r h  r r i  r r  r")
renderLine(28, "r r r  r r r  h r  r")
renderLine(29, "r i rirrhr h  r rirr")
renderLine(30, "r r    h i r  r    r")
renderLine(31, "r hhrrrr r rrhrrirrr")
renderLine(32, "r r i  r h         r")
renderLine(33, "r r r  r r         r")
renderLine(34, "r r r    r         r")
renderLine(35, "rdr r    r         r")
renderLine(36, "rrrrrrrgrrrrrrrrrr r")
renderLine(37, "                    ")
renderLine(38, "                    ")
renderLine(39, "                    ")
renderLine(40, "                    ")
renderLine(41, "wwwwwwwwwwwwwwwwwww ")
renderLine(42, "wwwwwwwwwwwwwwwwwww ")
renderLine(43, "                    ")
renderLine(44, "                    ")
renderLine(45, "                    ")
renderLine(46, "                    ")
renderLine(47, "       w            ")
renderLine(48, "     s w            ")
renderLine(49, "#s     w   s#      #")
renderLine(50, "s# ####wss    #s## #")
renderLine(51, "o #####wssss #     s")
renderLine(52, "s #    w   s o ##s #")
renderLine(53, "# l # sws ss #     i")
renderLine(54, "s  i   w a   #s ## #")
renderLine(55, "s sss### s s      b#")
renderLine(56, "#ns    # s s isss# s")
renderLine(57, "#   ol w s s b  m  s")
renderLine(58, "#######w## s #####o#")
renderLine(59, "       w  xsx       ")
renderLine(60, "       w  xxx       ")
renderLine(61, "       w  x         ")
renderLine(62, "       w  x         ")
renderLine(63, "       w  x         ")
renderLine(64, "       w  x         ")
renderLine(65, "       w  x         ")
renderLine(66, "                    ")
renderLine(67, "                    ")
renderLine(68, "                    ")
renderLine(69, "                    ")
renderLine(70, "                    ")
renderLine(71, "                    ")
renderLine(72, "                    ")
--              01234567890123456789

oxyd_shuffle()

set_stones("st-wood", {{ 2,51},{10,60},{10,65}})

set_stones("st-break_acwhite", {{ 7,55},{ 7,56}})

set_attrib(laser(19,41, TRUE, WEST), "name", "laser")
set_stone("st-switch",18,12)

set_attrib(laser(19,42, FALSE, WEST), "name", "laser3")
set_attrib(laser( 7,11, FALSE, SOUTH), "name", "laser4")

set_attrib(laser( 7,22, FALSE, SOUTH), "name", "laser1")
set_stone("st-switch",18,24, {action="callback", target="sw1"})

function sw1()
    SendMessage("laser1", "onoff")
    SendMessage("laser3", "onoff")
end

set_attrib(laser( 7,34, FALSE, SOUTH), "name", "laser2")
set_stone("st-switch",18,36, {action="callback", target="sw2"})

function sw2()
    SendMessage("laser2", "onoff")
    SendMessage("laser4", "onoff")
end

SetDefaultAttribs("it-wormhole", {range=1.0, strength=10})

set_item("it-wormhole", 3,15, {targetx=" 9.5",targety="54.5"})
set_item("it-wormhole",10,52, {targetx=" 3.5",targety="14.5"})
set_item("it-wormhole", 3,27, {targetx=" 9.5",targety="54.5"})
set_item("it-wormhole",10,65, {targetx=" 3.5",targety="26.5"})











