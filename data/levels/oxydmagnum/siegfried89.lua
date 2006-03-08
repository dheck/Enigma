--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 13

create_world(levelw, levelh)
draw_border("st-glass2")
enigma.ConserveLevel = FALSE
oxyd_default_flavor = "d"
fill_floor("fl-abyss")
fill_floor("fl-marble", 1, 1, level_width-2, level_height-2)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c =="s" then
         set_stone("st-stoneimpulse",i-1,line)
      elseif c == "c" then
         set_stone("st-stoneimpulse-hollow",i-1,line)
      elseif c == "g" then
         set_stone("st-glass2",i-1,line)
      elseif c == "H" then
         set_stone("st-glass2_hole",i-1,line)
      elseif c == "A" then
         set_stone("st-stoneimpulse",i-1,line, {name="impulse1"})
      elseif c == "B" then
         set_stone("st-stoneimpulse",i-1,line, {name="impulse2"})
      elseif c == "C" then
         set_stone("st-stoneimpulse-hollow",i-1,line, {name="impulse3"})
      elseif c == "D" then
         set_stone("st-stoneimpulse-hollow",i-1,line, {name="impulse4"})
      elseif c == "E" then
         set_stone("st-stoneimpulse-hollow",i-1,line, {name="impulse5"})
      elseif c == "N" then
         set_stone("st-oneway-n",i-1,line)
      elseif c == "S" then
         set_stone("st-oneway-s",i-1,line)
      elseif c == "w" then
         set_stone("st-wood",i-1,line)
      elseif c == "1" then
         set_item("it-trigger",i-1,line, {action="callback", target="st1"})
      elseif c == "2" then
         set_item("it-trigger",i-1,line, {action="callback", target="st2"})
      elseif c == "3" then
         set_item("it-trigger",i-1,line, {action="callback", target="st3"})
      elseif c == "4" then
         set_item("it-trigger",i-1,line, {action="callback", target="st4"})
      elseif c == "5" then
         set_item("it-trigger",i-1,line, {action="callback", target="st5"})
      elseif c == "o" then
         oxyd( i-1, line)
      elseif c == "#" then
         set_item("it-seed",i-1,line)
      elseif c == "a" then
         set_actor("ac-blackball", i-.5,line+.5)
        end
    end
end

--              01234567890123456789
renderLine(00, "                    ")
renderLine(01, "   gggggss          ")
renderLine(02, "    12  #ss       o ")
renderLine(03, "   gggHs##ss      o ")
renderLine(04, " gNEggSss##ss     o ")
renderLine(05, " gcwwc gss##ss    o ")
renderLine(06, " Cc45cDg ss##ss   o ")
renderLine(07, "     ggg  ss##ss  o ")
renderLine(08, "     g     ss# B  o ")
renderLine(09, " o   g     gssw   o ")
renderLine(10, " o   ggggggg sA     ")
renderLine(11, "       3 a gggggggg ")
renderLine(12, "                    ")
--              01234567890123456789

oxyd_shuffle()

function st1()
    SendMessage("impulse1", "trigger")
end

function st2()
    SendMessage("impulse2", "trigger")
end

function st3()
    SendMessage("impulse3", "trigger")
    SendMessage("impulse5", "trigger")
end

function st4()
    SendMessage("impulse3", "trigger")
end

function st5()
    SendMessage("impulse4", "trigger")
end













