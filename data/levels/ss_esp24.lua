-- A level for Enigma
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above

-- ESPRIT #024

-- problem: how can you change the magnet strength?



levelw = 20

levelh = 13

create_world(levelw, levelh)

oxyd_default_flavor = "b"

set_actor("ac-blackball", 10,6.5)

fill_floor( "fl-red", 0, 0,levelw,levelh)



function renderLine( line, pattern)

    for i=1, strlen(pattern) do

      local c = strsub( pattern, i, i)

      if c ==   "#" then

         set_stone("st-blue-sand", i-1,line)

      elseif c=="M" then

         set_item("it-magnet",i-1,line,{name="magnet", on=1})

      elseif c=="D" then                                                                

         set_stone("st-death", i-1,  line)

      elseif c=="1" then                                                                

         set_stone("st-switch",i-1,line, {action="callback", target="s1",on=1})

	 set_item("it-magnet",i-1,line-12,{name="magnet1", on=1})

      elseif c=="2" then                                                                

         set_stone("st-switch",i-1,line, {action="callback", target="s2",on=1})    

         set_item("it-magnet",i-1,line-12,{name="magnet2", on=1})

      elseif c=="3" then                                                                

         set_stone("st-switch",i-1,line, {action="callback", target="s3",on=1})

         set_item("it-magnet",i-1,line-12,{name="magnet3", on=1})

      elseif c=="4" then                                                                

         set_stone("st-switch",i-1,line, {action="callback", target="s4",on=1})

         set_item("it-magnet",i-1,line-12,{name="magnet4", on=1})

      elseif c=="5" then                                                                

         set_stone("st-switch",i-1,line, {action="callback", target="s5",on=1})

         set_item("it-magnet",i-1,line-12,{name="magnet5", on=1})

      elseif c=="6" then                                                                

         set_stone("st-switch",i-1,line, {action="callback", target="s6",on=1})

         set_item("it-magnet",i-1,line-12,{name="magnet6", on=1})

      elseif c=="7" then                                                                

         set_stone("st-switch",i-1,line, {action="callback", target="s7",on=1})

         set_item("it-magnet",i-1,line-12,{name="magnet7", on=1})

      elseif c=="8" then                                                                

         set_stone("st-switch",i-1,line, {action="callback", target="s8",on=1})

         set_item("it-magnet",i-1,line-12,{name="magnet8", on=1})

      elseif c=="9" then                                                                

         set_stone("st-switch",i-1,line, {action="callback", target="s9",on=1})

         set_item("it-magnet",i-1,line-12,{name="magnet9", on=1})

      elseif c=="F" then                                                                

         fakeoxyd( i-1,  line)

      elseif c=="O" then

	 oxyd(i-1,line)

        end

    end  

end

--               01234567890123456789

renderLine(00 , "#DDDDDDDDDDDDDDDDDD#")

renderLine(01 , "#        M         #")

renderLine(02 , "#                  #")

renderLine(03 , "#                  #")

renderLine(04 , "#                  #")  

renderLine(05 , "#                  #")

renderLine(06 , "#                  #")

renderLine(07 , "#                  #")

renderLine(08 , "#                  #")

renderLine(09 , "#                  #")

renderLine(10 , "#                  #")

renderLine(11 , "#                  #")

renderLine(12 , "#1O2O3O4O5O6O7O8O9F#")

--               01234567890123456789



local num = {1,1,1,1,1,1,1,1,1}

power = 27



function s1() sx(1) end

function s2() sx(2) end

function s3() sx(3) end

function s4() sx(4) end

function s5() sx(5) end

function s6() sx(6) end

function s7() sx(7) end

function s8() sx(8) end

function s9() sx(9) end



function sx(x)

%num[x] = 1-%num[x]

power = 3*(%num[1] + %num[2] + %num[3] + %num[4] + %num[5] + %num[6] + %num[7] + %num[8] + %num[9])

if %num[x] == 0 then

	SendMessage("magnet"..x, "off")

      else

        SendMessage("magnet"..x, "on")

      end

if power == 0 then 

	SendMessage("magnet", "off")	

      else

	SendMessage("magnet", "on")

      end

SendMessage("magnet", "strength", power)   -- does this work?

end



oxyd_shuffle()

