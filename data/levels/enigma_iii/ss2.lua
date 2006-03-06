-- A level for Enigma
-- Name:	Overshoot
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above

levelw = 20
levelh = 13
create_world(levelw, levelh)
oxyd_default_flavor = "d"       -- Default flavor for oxyd stones.

fill_floor("fl-sahara")
function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c ==     "G" then
         set_stone("st-glass",i-1,line)
      elseif c=="a" then
	 doorh( i-1,line, {name="door1"})
      elseif c=="b" then
	 doorv( i-1,line, {name="door2"})
      elseif c=="c" then
	 doorv( i-1,line, {name="door3"})
      elseif c=="d" then
	 doorh( i-1,line, {name="door4"})
      elseif c=="1" then
	 set_stone("st-fourswitch", i-1,line, {action="callback", target="s1"})
      elseif c=="2" then
	 set_stone("st-fourswitch", i-1,line, {action="callback", target="s2"})
      elseif c=="3" then
	 set_stone("st-fourswitch", i-1,line, {action="callback", target="s3"})
      elseif c=="4" then
	 set_stone("st-fourswitch", i-1,line, {action="callback", target="s4"})
      elseif c=="w" then
          set_stone("st-bolder-n", i-1,line, {name="bolder1"})
      elseif c=="x" then
          set_stone("st-bolder-n", i-1,line, {name="bolder2"})
      elseif c=="y" then
	 set_stone("st-bolder-n", i-1,line, {name="bolder3"})
      elseif c=="z" then
	 set_stone("st-bolder-n", i-1,line, {name="bolder4"})
      elseif c == "O" then
         oxyd(i-1,line)
      elseif c == "A" then
         if difficult then
            set_floor("fl-abyss",i-1,line)
         end
      elseif c == "B" then
         set_actor("ac-blackball", i-.5,line+.5)
         set_item("it-yinyang",i,line+1)
      elseif c == "W" then
         set_actor("ac-whiteball", i-.5,line+.5)
         set_item("it-yinyang",i-1,line)
        end
    end
end
--              01234567890123456789
renderLine(00, "G12GGGGGGGGGGGGGGGGG")
renderLine(01, "GB Gw             xG")
renderLine(02, "G  G               G")
renderLine(03, "G34G               G")
renderLine(04, "GGGG       A       G")
renderLine(05, "Gy        A        G")
renderLine(06, "G        A         G")
renderLine(07, "G       A        G G")
renderLine(08, "G      A       GGOGG")
renderLine(09, "G              GGaGG")
renderLine(10, "G             GObWcO")
renderLine(11, "G             zGGdGG")
renderLine(12, "GGGGGGGGGGGGGGGGGOGG")
--              01234567890123456789

set_item ("it-trigger", 7, 4, {action="openclose", target="door1"})
set_item ("it-trigger", 13, 4, {action="openclose", target="door2"})
set_item ("it-trigger", 5, 8, {action="openclose", target="door3"})
set_item ("it-trigger", 11, 8, {action="openclose", target="door4"})

hitcounter = { 0, 0, 0, 0 }
todir = { EAST, SOUTH, WEST, NORTH }

function sx(x)
   local val = todir[hitcounter[x]+1]
   SendMessage("bolder"..x, "direction", val)
   hitcounter[x] = hitcounter[x]+1
   if (hitcounter[x]==4) then
      hitcounter[x] = 0
   end
end

function s1() sx(1) end
function s2() sx(2) end
function s3() sx(3) end
function s4() sx(4) end

oxyd_shuffle()

















