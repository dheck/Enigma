-- Buridan, a level for Enigma
-- Copyright (C) 2005 Alain Busser
-- Licensed under GPL v2.0 or above 
-- an illustration of the famous Epimenides paradox

dofile(enigma.FindDataFile("levels/lib/ant.lua"))

levelw = 20
levelh = 13

create_world(levelw, levelh)
oxyd_default_flavor = "a"
draw_border("st-rock1")
fill_floor("fl-bluegreen", 0,0, level_width,level_height)

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone( "st-glass1", i-1, line)
		elseif c == "o" then
			oxyd( i-1, line)
            elseif c == "a" then
			set_item("it-wormhole",i-1,line, {targetx=" 15.5",targety="9.5",strength=0,range=0})          
		elseif c=="d" then
         		document(i-1,line, "The other document lies and the left wormhole is the right one") 
		elseif c=="e" then
         		document(i-1,line, "The other document tells the truth and the other wormhole has been left on the right side") 
            elseif c == "b" then
			set_item("it-wormhole",i-1,line, {targetx=" 7.5",targety="9.5",strength=0,range=0})          
  		elseif c=="z" then
			set_actor("ac-blackball", i-.5,line+.5, {player=0})
		elseif c=="+" then
			set_stone("st-wood", i-1, line)
		elseif c=="*" then
			set_stone("st-fart", i-1,line)
		elseif c=="S" then
			fill_floor("fl-space", i-1,line, 1,1)
		elseif c=="g" then
			doorh(i-1,line, {name="door1"})
		elseif c=="h" then
			doorh(i-1,line, {name="door2"})
		elseif c=="i" then
			doorh(i-1,line, {name="door3"})
		elseif c=="j" then
			doorh(i-1,line, {name="door4"})
		elseif c == "1" then
         		set_item("it-trigger",i-1,line, {action="openclose", target="door1"})
     		elseif c == "2" then
         		set_item("it-trigger",i-1,line, {action="openclose", target="door2"})
     		elseif c == "3" then
         		set_item("it-trigger",i-1,line, {action="openclose", target="door3"})
     		elseif c == "4" then
         		set_item("it-trigger",i-1,line, {action="openclose", target="door4"})
     		end
	end	
end

hammer(1,1)
set_stone("st-chameleon", 1,1)

--hammer(18,8)

--               01234567890123456789
renderLine(00 , "                    ")
renderLine(01 , "  *        *  34  * ")
renderLine(02 , " g*          *12*   ")
renderLine(03 , " h**********++++++* ")
renderLine(04 , " i*       *       + ")
renderLine(05 , " j* ***** * *****   ")
renderLine(06 , "  * *aaS* * *bbS* + ")  
renderLine(07 , "  * *o*S*z* *o*S*   ")
renderLine(08 , "  * *** * * *** * + ")
renderLine(09 , "  *    d* *    e*   ")
renderLine(10 , "  ******* ******* + ")
renderLine(11 , "                    ")
renderLine(12 , "                    ") 
--               01234567890123456789

oxyd_shuffle()































