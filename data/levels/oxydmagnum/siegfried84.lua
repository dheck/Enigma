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
fill_floor("fl-rough", 1, 2, 18, 9)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c =="t" then
         set_stone("st-turnstile",i-1,line)
      elseif c == "n" then
         set_stone("st-turnstile-n",i-1,line)
      elseif c == "s" then
         set_stone("st-turnstile-s",i-1,line)
      elseif c == "e" then
         set_stone("st-turnstile-e",i-1,line)
      elseif c == "w" then
         set_stone("st-turnstile-w",i-1,line)
      elseif c == "d" then
         set_stone("st-door_a",i-1,line)
      elseif c == "o" then
         oxyd( i-1, line)
      elseif c == "a" then
         set_actor("ac-blackball", i-.5,line+.5)
        end
    end
end
--              01234567890123456789
renderLine(00, "                    ")
renderLine(01, "                    ")
renderLine(02, "  wte wte           ")
renderLine(03, "   s   s            ")
renderLine(04, "  wte wte   d   d   ")
renderLine(05, " n    n  n   o o    ")
renderLine(06, "wtewtet wte  d d  a ")
renderLine(07, "      s      o o    ")
renderLine(08, "  wte wte   d   d   ")
renderLine(09, "   n   n            ")
renderLine(10, "  wte wte           ")
renderLine(11, "                    ")
renderLine(12, "                    ")
--              01234567890123456789

oxyd_shuffle()

set_item("it-trigger", 4, 5)
set_item("it-trigger", 6, 5)
set_item("it-trigger", 4, 7)
set_item("it-trigger", 6, 7)

set_item("it-trigger",  2, 3, {target="door01", action="openclose"})
set_item("it-trigger",  3, 3, {target="door02", action="openclose"})
set_item("it-trigger",  4, 3, {target="door03", action="openclose"})
set_item("it-trigger",  5, 3, {target="door04", action="openclose"})
set_item("it-trigger",  6, 3, {target="door05", action="openclose"})
set_item("it-trigger",  7, 3, {target="door06", action="openclose"})
set_item("it-trigger",  8, 3, {target="door07", action="openclose"})
set_item("it-trigger",  2, 4, {target="door08", action="openclose"})
set_item("it-trigger",  4, 4, {target="door10", action="openclose"})
set_item("it-trigger",  5, 4, {target="door11", action="openclose"})
set_item("it-trigger",  6, 4, {target="door12", action="openclose"})
set_item("it-trigger",  8, 4, {target="door14", action="openclose"})
set_item("it-trigger",  2, 5, {target="door15", action="openclose"})
set_item("it-trigger",  3, 5, {target="door16", action="openclose"})
set_item("it-trigger",  5, 5, {target="door18", action="openclose"})
set_item("it-trigger",  7, 5, {target="door20", action="openclose"})
set_item("it-trigger",  8, 5, {target="door21", action="openclose"})
set_item("it-trigger",  2, 6, {target="door22", action="openclose"})
set_item("it-trigger",  3, 6, {target="door23", action="openclose"})
set_item("it-trigger",  5, 6, {target="door25", action="openclose"})
set_item("it-trigger",  7, 6, {target="door27", action="openclose"})
set_item("it-trigger",  8, 6, {target="door28", action="openclose"})
set_item("it-trigger",  2, 7, {target="door29", action="openclose"})
set_item("it-trigger",  3, 7, {target="door30", action="openclose"})
set_item("it-trigger",  5, 7, {target="door32", action="openclose"})
set_item("it-trigger",  7, 7, {target="door34", action="openclose"})
set_item("it-trigger",  8, 7, {target="door35", action="openclose"})
set_item("it-trigger",  2, 8, {target="door36", action="openclose"})
set_item("it-trigger",  4, 8, {target="door38", action="openclose"})
set_item("it-trigger",  5, 8, {target="door39", action="openclose"})
set_item("it-trigger",  6, 8, {target="door40", action="openclose"})
set_item("it-trigger",  8, 8, {target="door42", action="openclose"})
set_item("it-trigger",  2, 9, {target="door43", action="openclose"})
set_item("it-trigger",  3, 9, {target="door44", action="openclose"})
set_item("it-trigger",  4, 9, {target="door45", action="openclose"})
set_item("it-trigger",  5, 9, {target="door46", action="openclose"})
set_item("it-trigger",  6, 9, {target="door47", action="openclose"})
set_item("it-trigger",  7, 9, {target="door48", action="openclose"})
set_item("it-trigger",  8, 9, {target="door49", action="openclose"})

set_stone("st-door_a",11, 3, {name="door01"})
set_stone("st-door_a",12, 3, {name="door02"})
set_stone("st-door_a",13, 3, {name="door03"})
set_stone("st-door_a",14, 3, {name="door04"})
set_stone("st-door_a",15, 3, {name="door05"})
set_stone("st-door_a",16, 3, {name="door06"})
set_stone("st-door_a",17, 3, {name="door07"})
set_stone("st-door_a",11, 4, {name="door08"})
set_stone("st-door_a",13, 4, {name="door10"})
set_stone("st-door_a",14, 4, {name="door11"})
set_stone("st-door_a",15, 4, {name="door12"})
set_stone("st-door_a",17, 4, {name="door14"})
set_stone("st-door_a",11, 5, {name="door15"})
set_stone("st-door_a",12, 5, {name="door16"})
set_stone("st-door_a",14, 5, {name="door18"})
set_stone("st-door_a",16, 5, {name="door20"})
set_stone("st-door_a",17, 5, {name="door21"})
set_stone("st-door_a",11, 6, {name="door22"})
set_stone("st-door_a",12, 6, {name="door23"})
set_stone("st-door_a",14, 6, {name="door25"})
set_stone("st-door_a",16, 6, {name="door27"})
set_stone("st-door_a",17, 6, {name="door28"})
set_stone("st-door_a",11, 7, {name="door29"})
set_stone("st-door_a",12, 7, {name="door30"})
set_stone("st-door_a",14, 7, {name="door32"})
set_stone("st-door_a",16, 7, {name="door34"})
set_stone("st-door_a",17, 7, {name="door35"})
set_stone("st-door_a",11, 8, {name="door36"})
set_stone("st-door_a",13, 8, {name="door38"})
set_stone("st-door_a",14, 8, {name="door39"})
set_stone("st-door_a",15, 8, {name="door40"})
set_stone("st-door_a",17, 8, {name="door42"})
set_stone("st-door_a",11, 9, {name="door43"})
set_stone("st-door_a",12, 9, {name="door44"})
set_stone("st-door_a",13, 9, {name="door45"})
set_stone("st-door_a",14, 9, {name="door46"})
set_stone("st-door_a",15, 9, {name="door47"})
set_stone("st-door_a",16, 9, {name="door48"})
set_stone("st-door_a",17, 9, {name="door49"})










