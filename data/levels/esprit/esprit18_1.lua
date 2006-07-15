-- A level for Enigma
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above

-- ESPRIT #018



levelw = 20

levelh = 25

create_world(levelw, levelh)

oxyd_default_flavor = "b"       -- Default flavor for oxyd stones.



set_actor("ac-blackball", 4.5,22)

set_item("it-extralife",13,1)

fill_floor("fl-abyss",0,0,levelw,levelh)



function renderLine( line, pattern)

    for i=1, strlen(pattern) do

      local c = strsub( pattern, i, i)

      if c ==   "G" then

         set_stone("st-oneway-e", i-1,line)

	 set_floor("fl-normal",  i-1,  line)

      elseif c=="1" then

	 set_floor("fl-gradient",  i-1,  line, {type=3})         

      elseif c=="2" then

	 set_floor("fl-gradient",  i-1,  line, {type=4})   

      elseif c=="3" then

	 set_floor("fl-gradient",  i-1,  line, {type=1})   

      elseif c=="4" then

	 set_floor("fl-gradient",  i-1,  line, {type=2})         

      elseif c=="5" then

         set_floor("fl-gradient",  i-1,  line, {type=5})   

      elseif c=="6" then

         set_floor("fl-gradient",  i-1,  line, {type=6})   	

      elseif c=="7" then

         set_floor("fl-gradient",  i-1,  line, {type=7})         

      elseif c=="8" then

         set_floor("fl-gradient",  i-1,  line, {type=8})   

      elseif c=="a" then

         set_floor("fl-gradient",  i-1,  line, {type=12})   

      elseif c=="b" then

         set_floor("fl-gradient",  i-1,  line, {type=10})         

      elseif c=="c" then

         set_floor("fl-gradient",  i-1,  line, {type=11})   

      elseif c=="d" then

         set_floor("fl-gradient",  i-1,  line, {type=9})   		 	 	 

      elseif c=="O" then

	 oxyd(i-1,line)

        end

    end  

end

--               01234567890123456789

renderLine(00 , "                    ")

renderLine(01 , "  53333      33336  ")

renderLine(02 , "  1a444      444b2  ")

renderLine(03 , "  12  O       O 12  ")

renderLine(04 , " O12            12  ")  

renderLine(05 , "  12  5333G336  12  ")

renderLine(06 , "  12  1a44G4b2  12  ")

renderLine(07 , "  12O 12 O  12O 12  ")

renderLine(08 , "  12  12    12  12  ")

renderLine(09 , "  12  12    12  12  ")

renderLine(10 , "  12  12    12  12  ")

renderLine(11 , "  12  12    12  12  ")

renderLine(12 , "  12  12    12  12  ")

renderLine(13 , "  12  12    12  12  ")

renderLine(14 , "  12  12    12  12  ")

renderLine(15 , "  12  12    12  12  ")

renderLine(16 , "  12  12O   12  12  ")

renderLine(17 , "  12  12    12 O12  ")

renderLine(18 , "  12O 12   O12  12  ")

renderLine(19 , "  12  12    12  12  ")

renderLine(20 , "  12  12    12  12  ")

renderLine(21 , "  1c33d2    1c33d2O ")

renderLine(22 , "  744448    744448  ")

renderLine(23 , "    O               ")

renderLine(24 , "                    ")

--               01234567890123456789

oxyd_shuffle()












