-- Bendixxon, a level for Enigma
-- Copyright (C) 2005 Alain Busser
-- Licensed under GPL v2.0 or above 

levelw = 20
levelh = 13

create_world(levelw, levelh)
oxyd_default_flavor = "a"
--draw_border("st-rock1")
enigma.BumperForce=200
enigma.SlopeForce=200

fill_floor("fl-red")

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="*" then
			set_stone( "st-actorimpulse", i-1, line)
		elseif c == "o" then
			oxyd( i-1, line)
            elseif c=="z" then
			set_actor("ac-blackball", i-.5,line+.5, {player=0})
        	elseif c == "1" then
            	set_floor("fl-gradient",  i-1,  line, {type=21})
        	elseif c == "2" then
            	set_floor("fl-gradient",  i-1,  line, {type=22})
        	elseif c == "3" then
            	set_floor("fl-gradient",  i-1,  line, {type=23})
        	elseif c == "4" then
            	set_floor("fl-gradient",  i-1,  line, {type=24})
        	elseif c == "5" then
            	set_floor("fl-gradient",  i-1,  line, {type=5})
        	elseif c == "6" then
            	set_floor("fl-gradient",  i-1,  line, {type=6})
        	elseif c == "7" then
            	set_floor("fl-gradient",  i-1,  line, {type=7})
        	elseif c == "8" then
            	set_floor("fl-gradient",  i-1,  line, {type=8})
		elseif c=="+" then
			set_item("it-wormhole", i-1,line, {targetx=" 10.5",targety="2.5"})
		elseif c=="f" then
			set_floor("fl-bumps",i-1,line)
		elseif c=="." then
			set_stone("st-actorimpulse_invisible", i-1, line)

		end
	end	
end


--               01234567890123456789
renderLine(00 , "          .         ")
renderLine(01 , "  f     *o*o*    f f")
renderLine(02 , " ff+   *33331*   f f")
renderLine(03 , "  f   *32*o*31*  fff")
renderLine(04 , "  f  *32*   *31*   f")
renderLine(05 , "  f  o2* fff *1o z f")  
renderLine(06 , "     *2o f f o1*    ")
renderLine(07 , "fff  o2* fff *1o fff")
renderLine(08 , "  f  *24*   *14*   f")
renderLine(09 , " f    *24*o*14*   ff")
renderLine(10 , "f      *24444*     f")
renderLine(11 , "fff     *o*o*    fff")
renderLine(12 , "                    ") 
--               01234567890123456789


oxyd_shuffle()

display.SetFollowMode(display.FOLLOW_SCROLLING)



















