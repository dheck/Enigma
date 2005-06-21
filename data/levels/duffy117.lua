-- Copyright (c) 2004 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Bad Nightmare

rooms_wide=3
rooms_high=2

levelw=1+(19*rooms_wide)
levelh=1+(12*rooms_high)

ffct=.4

create_world( levelw, levelh)
enigma.FrictionFactor=-ffct

fill_floor("fl-rough-blue", 0,0,levelw,levelh)

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
		   set_stone( "st-stone1", i-1, line)
		elseif c =="X" then
		   set_stone( "st-death", i-1, line)
		elseif c =="&" then
		   set_stone( "st-death", i-1, line)
			set_floor("fl-space",i-1,line)
		elseif c =="R" then
		   set_stone( "st-stone1", i-1, line)
		   set_floor( "fl-rough-red", i-1, line)
		elseif c == "o" then
			oxyd( i-1, line)
		elseif c == "%" then
			oxyd( i-1, line)
			set_floor("fl-space",i-1,line)
		elseif c == "*" then
			set_stone( "st-brownie", i-1, line)
                elseif c == "!" then
			abyss(i-1,line)
		elseif c == "~" then
		   set_floor("fl-water",i-1,line)
		elseif c == "r" then
		   set_floor("fl-rough-red",i-1,line)
		   set_item("it-trigger",i-1,line,{invisible=1,action="callback",target="funcc1"})
		elseif c == "H" then
		   set_item("it-hammer",i-1,line)
		elseif c == "h" then
		   set_stone("st-stone_break",i-1,line)
		elseif c == "O" then
		   set_item("it-extralife",i-1,line)
		elseif c == "F" then
		   set_item("it-flagblack",i-1,line)
		elseif c == "L" then
		   set_item("it-landmine",i-1,line)
		elseif c=="z" then
		   set_actor("ac-blackball", i-.5,line+.5, {player=0})
		elseif c=="y" then
		   set_actor("ac-whiteball", i-1,line+.5, {player=1})
		elseif c == "g" then
			draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
		elseif c=="+" then
			set_stone( "st-wood", i-1, line)
		elseif c=="=" then
			set_floor("fl-space",i-1,line)
		elseif c=="N" then
			set_stone("st-bolder", i-1,line, {direction=NORTH})
		elseif c=="E" then
			set_stone("st-bolder", i-1,line, {direction=EAST})
		elseif c=="S" then
			set_stone("st-bolder", i-1,line, {direction=SOUTH})
		elseif c=="W" then
			set_stone("st-bolder", i-1,line, {direction=WEST})
		elseif c=="T" then
		   set_actor("ac-top", i-.5,line+.5, {player=1, mouseforce=0, range=6, force=10})
		elseif c=="B" then
			yy1( "black",  i-1, line)
	     end
	end	
     end

function yy1( color, x, y)
        stone = format( "st-%s4", color)
        set_stone( stone, x, y)
end

renderLine(00,"#############RR##RR####################XXXXXXXXXXXXXXXXXXX")
renderLine(01,"#           #rr  rrRr r r r r r & r r #    XX      X     X")
renderLine(02,"#  O        #rr  rrR r r r r r r r r r#            X     X")
renderLine(03,"#           #rrrrrrRr r r r r r r & rX#        X   X     X")
renderLine(04,"#           #  rrrrR r r r r rXrLr r r#  XXXXXXX         X")
renderLine(05,"#           #  rr  RR#r r r r r r r r #     rrrX         X")
renderLine(06,"#     z      rrrr      r r rLr r r rXr      rrrX      X  X")
renderLine(07,"#           #rrrrrrRR#r r r r rXr r r #     rrrXXXXXXXX  X")
renderLine(08,"#           #rr  rrR r r r rXr r r r r#    XXXXX         X")
renderLine(09,"#           #rr  rrRr r r r r r rXr r #    X         X   X")
renderLine(10,"#  F        #rrrrrrR r r r r & r rLr X#    X     X       X")
renderLine(11,"#           #rrrr  Rr r r r r r & r r #    X             X")
renderLine(12,"#############RRRR###########################B#XXXXXXXXXXXX")
renderLine(13,"# % = =o= = % = =o=#      N   S       #                  #")
renderLine(14,"#= = = = = = = = = #EhX  Eh  Eh  hW   #                  #")
renderLine(15,"# = = = = = = = = =# SX   N   S       #                  #")
renderLine(16,"#= = = = = = = = = #hS   Eh  Eh  hW   #                  #")
renderLine(17,"# = = = = = = = = =#NS    N   S       #                  #")
renderLine(18,"#=X= = & = =X= = &  NS   Eh  Eh  hW   B         T        #")
renderLine(19,"# = = = = = = = = =#NS    N   S       #                  #")
renderLine(20,"#= = = = = = = = = #Nh   Eh  Eh  hW   #                  #")
renderLine(21,"# = = = = = = = = =#N X   N   S       #              H   #")
renderLine(22,"#= = = = = = = = = #hWX  Eh  Eh  hW   #                  #")
renderLine(23,"# % = =o= = % = =o=#      N   S       #                  #")
renderLine(24,"##########################################################")

oxyd_shuffle()

ff1=0
function funcc1()
    if ff1==0 then
        enigma.FrictionFactor=.6
        ff1=1
    elseif ff1==1 then
        enigma.FrictionFactor=-ffct
        ff1=0
    end
end
