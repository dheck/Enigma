-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Slinky Mayhem

levelw=21
levelh=13

create_world( levelw, levelh)

fill_floor("fl-leaves", 0,0,levelw,levelh)

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone( "st-glass", i-1, line)
		elseif c == "o" then
			oxyd( i-1, line)
                elseif c == "!" then
			abyss(i-1,line)
--			fill_floor("fl-water", i-1,line, 1,1)
		elseif c=="z" then
		        set_stone( "st-stoneimpulse-hollow", i-1,line)
			set_actor("ac-blackball", i-.5,line+.5)
		elseif c=="+" then
			set_stone( "st-wood", i-1, line)
		elseif c=="W" then
			set_attrib(laser(i-1,line, FALSE, WEST), "name", "laser")
		elseif c=="x" then
		        fill_floor("fl-leaves", i-1,line, 1,1)
		elseif c=="s" then
			set_stone("st-stoneimpulse",i-1,line)
		elseif c=="A" then
		   set_stone("st-stoneimpulse",i-1,line,{name="s1"})
		elseif c=="B" then
		   set_stone("st-stoneimpulse",i-1,line,{name="s2"})
		elseif c=="C" then
		   set_stone("st-stoneimpulse",i-1,line,{name="s3"})
		elseif c=="D" then
		   set_stone("st-stoneimpulse",i-1,line,{name="s4"})
		elseif c=="S" then
		        set_stone( "st-stoneimpulse-hollow", i-1,line)
		elseif c == "b" then
			yy1( "black",  i-1, line)
		elseif c == "w" then
			yy1( "white",  i-1, line)
		     elseif c=="g" then
			set_stone("st-grate1",i-1,line)
		     elseif c=="1" then
		        set_stone( "st-stoneimpulse-hollow", i-1,line)
            set_item("it-wormhole", i-1, line, {strength=0,targetx="10.5",targety="1.5"})
		     elseif c=="2" then
		        set_stone( "st-stoneimpulse-hollow", i-1,line)
            set_item("it-wormhole", i-1, line, {strength=0,targetx="15.5",targety="6.5"})
		     elseif c=="3" then
		        set_stone( "st-stoneimpulse-hollow", i-1,line)
            set_item("it-wormhole", i-1, line, {strength=0,targetx="10.5",targety="11.5"})
		     elseif c=="4" then
		        set_stone( "st-stoneimpulse-hollow", i-1,line)
            set_item("it-wormhole", i-1, line, {strength=0,targetx="5.5",targety="6.5"})
		end
	end	
end

function yy1( color, x, y)
        stone = format( "st-%s4", color)
        set_stone( stone, x, y)
end

-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"

renderLine(00,"!!!!###o##o##o###!!!")
renderLine(01,"!!!!#ASSSSSSSSSB#!!!")
renderLine(02,"!!!!#SSSSSSSSSSS#!!!")
renderLine(03,"!!!!oSSSSSSSSSSSo!!!")
renderLine(04,"!!!!#SSSSSSSSSSS#!!!")
renderLine(05,"!!!!#SSSSS1SSSSS#!!!")
renderLine(06,"!!!!oSSSS4z2SSSSo!!!")
renderLine(07,"!!!!#SSSSS3SSSSS#!!!")
renderLine(08,"!!!!#SSSSSSSSSSS#!!!")
renderLine(09,"!!!!oSSSSSSSSSSSo!!!")
renderLine(10,"!!!!#SSSSSSSSSSS#!!!")
renderLine(11,"!!!!#CSSSSSSSSSD#!!!")
renderLine(12,"!!!!###o##o##o###!!!")

oxyd_shuffle()

function timer_callback()
    s_num=random(4)
    if s_num==1 then
        SendMessage("s1", "trigger")
    elseif s_num==2 then
        SendMessage("s2", "trigger")
    elseif s_num==3 then
        SendMessage("s3", "trigger")
    elseif s_num==4 then
        SendMessage("s4", "trigger")
    end
end

set_stone( "st-timer", 20, 0,
           {target="timer_callback", action="callback",
            name="timer", interval=3} )















