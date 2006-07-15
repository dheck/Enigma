--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 25

create_world(levelw, levelh)
draw_border("st-rock5")
enigma.ConserveLevel = FALSE
oxyd_default_flavor = "d"
fill_floor("fl-samba")

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c =="#" then
         fill_floor("fl-abyss", i-1,line, 1,1)
      elseif c == "o" then
         oxyd( i-1, line)
      elseif c == "r" then
         set_stone("st-rock5",i-1,line)
      elseif c == "i" then
         set_stone("st-stoneimpulse",i-1,line)
      elseif c == "t" then
         set_stone("st-shogun",i-1,line)
      elseif c == "v" then
         set_stone("st-yinyang1",i-1,line)
      elseif c == "w" then
         set_stone("st-break_acwhite",i-1,line)
      elseif c == "b" then
         set_stone("st-break_acblack",i-1,line)
      elseif c == "a" then
         set_stone("st-wood",i-1,line)
      elseif c == "h" then
         set_item("it-hammer",i-1,line)
      elseif c == "k" then
         set_item("it-key_a",i-1,line)
      elseif c == "z" then
         set_actor("ac-blackball", i-.5,line+.5)
         set_item("it-yinyang", i-1, line+.5)
      elseif c == "y" then
         set_actor("ac-whiteball", i-.5,line+.5)
         set_item("it-yinyang", i-1, line+.5)
        end
    end
end
--              01234567890123456789
renderLine(00, "                    ")
renderLine(01, "                    ")
renderLine(02, "  r                 ")
renderLine(03, "  r     rrr         ")
renderLine(04, "  r     r r      o  ")
renderLine(05, "  rrrrrrr r         ")
renderLine(06, "  a       r      o  ")
renderLine(07, "  rrrrrrr r         ")
renderLine(08, "  r     rwr      o  ")
renderLine(09, "  r     r r         ")
renderLine(10, " hrrrrrrr r      o  ")
renderLine(11, "      rrr r         ")
renderLine(12, "  t   rrr r         ")
renderLine(13, "   r  rrr r         ")
renderLine(14, "   r  rrr rrrrrrrrr ")
renderLine(15, "   r  rrr r         ")
renderLine(16, "   r  rrr rrrbtw y  ")
renderLine(17, "   r     bb  wr     ")
renderLine(18, "  rr   r w w  r wrr ")
renderLine(19, "   vtrtr r r  r     ")
renderLine(20, "  tii  r   r#  vrtr ")
renderLine(21, "   tiz r rrrvr   v  ")
renderLine(22, "      r  rwtw       ")
renderLine(23, "          wkw   r   ")
renderLine(24, "                    ")
--              01234567890123456789

oxyd_shuffle()

doorh( 1,10, {name="door1"})
shogundot1( 8,17, {action="openclose", target="door1"})

doorh( 1, 9, {name="door2"})
shogundot1( 8,18, {action="openclose", target="door2"})

doorh( 1, 8, {name="door3"})
shogundot1(11,17, {action="openclose", target="door3"})

doorh( 1, 7, {name="door4"})
shogundot1(11,18, {action="openclose", target="door4"})

doorh( 1, 5, {name="door5"})
shogundot1( 9,17, {action="openclose", target="door5"})

doorh( 1, 4, {name="door6"})
shogundot1( 9,18, {action="openclose", target="door6"})

doorh( 1, 3, {name="door7"})
shogundot1(10,17, {action="openclose", target="door7"})

doorh( 1, 2, {name="door8"})
shogundot1(10,18, {action="openclose", target="door8"})

doorv( 16,22, {name="door9"})
set_stone("st-key_a",16,21, {action="openclose", target="door9"})











