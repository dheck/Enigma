--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 13

create_world(levelw, levelh)
enigma.ConserveLevel = FALSE
oxyd_default_flavor = "d"
fill_floor("fl-abyss")

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c =="A" then
         set_item("it-vortex-open", i-1,line, {targetx = 10.5, targety =  5.5})
      elseif c == "B" then
         set_item("it-vortex-open", i-1,line, {targetx = 10.5, targety =  6.5})
      elseif c == "C" then
         set_item("it-vortex-open", i-1,line, {targetx =  2.5, targety =  3.5})
      elseif c == "D" then
         set_item("it-vortex-open", i-1,line, {targetx = 17.5, targety =  3.5})
      elseif c == "E" then
         set_item("it-vortex-open", i-1,line, {targetx = 11.5, targety =  7.5})
      elseif c == "F" then
         set_item("it-vortex-open", i-1,line, {targetx =  9.5, targety =  7.5})
      elseif c == "G" then
         set_item("it-vortex-open", i-1,line, {targetx = 10.5, targety =  6.5})
      elseif c == "H" then
         set_item("it-vortex-open", i-1,line, {targetx = 17.5, targety =  9.5})
      elseif c == "I" then
         set_item("it-vortex-open", i-1,line, {targetx =  9.5, targety =  7.5})
      elseif c == "J" then
         set_item("it-vortex-open", i-1,line, {targetx =  8.5, targety =  6.5})
      elseif c == "K" then
         set_item("it-vortex-open", i-1,line, {targetx =  2.5, targety =  9.5})
      elseif c == "L" then
         set_item("it-vortex-open", i-1,line, {targetx =  8.5, targety =  7.5})
      elseif c == "M" then
         set_item("it-vortex-open", i-1,line, {targetx = 10.5, targety =  6.5})
      elseif c == "N" then
         set_item("it-vortex-open", i-1,line, {targetx =  9.5, targety =  5.5})
      elseif c == "O" then
         set_item("it-vortex-open", i-1,line, {targetx = 10.5, targety =  5.5})
      elseif c == "P" then
         set_item("it-vortex-open", i-1,line, {targetx =  8.5, targety =  7.5})
      elseif c == "o" then
         oxyd( i-1, line)
      elseif c == "1" then
         basis1(i-1, line)
      elseif c == "2" then
         basis2(i-1, line)
        end
    end
end

function basis1 ( x, y)
         fill_floor("fl-stwood",x,y, 3, 3)
end

function basis2 ( x, y)
         fill_floor("fl-stwood",x,y, 6, 5)
end

--              01234567890123456789
renderLine(00, "                    ")
renderLine(01, "o                  o")
renderLine(02, " 1              1   ")
renderLine(03, "  A              E  ")
renderLine(04, "       2            ")
renderLine(05, "        NOBDa       ")
renderLine(06, "        KPCM        ")
renderLine(07, "        JGHF        ")
renderLine(08, " 1              1   ")
renderLine(09, "  L              I  ")
renderLine(10, "                    ")
renderLine(11, "o                  o")
renderLine(12, "                    ")
--              01234567890123456789

oxyd_shuffle()

set_actor("ac-blackball", 9.5, 6.5)










