-- Copyright (c) 2004 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Laser Tricks

rooms_wide=2
rooms_high=1

levelw=1+(19*rooms_wide)
levelh=1+(12*rooms_high)

create_world( levelw, levelh)
enigma.ConserveLevel=FALSE

fill_floor("fl-black", 0,0,levelw,levelh)

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone( "st-laserswitch", i-1, line)
		elseif c=="&" then
			set_stone( "st-laserswitch", i-1, line)
			abyss(i-1,line)
		elseif c =="%" then
			set_stone( "st-greenbrown", i-1, line)
		elseif c == "o" then
			oxyd( i-1, line)
		elseif c == "*" then
			set_stone( "st-brownie", i-1, line)
                elseif c == "!" then
			abyss(i-1,line)
		elseif c == "~" then
		   set_floor("fl-water",i-1,line)
		elseif c=="z" then
		   set_actor("ac-blackball", i-1,line+.5, {player=0})
		elseif c == "g" then
			draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
		elseif c=="+" then
			set_stone( "st-wood", i-1, line)
		elseif c=="=" then
			set_floor("fl-space",i-1,line)
		elseif c=="A" then
		   set_stone("st-laserswitch",i-1,line,{action="callback",target="funcc1"})
		elseif c=="C" then
		   set_attrib(laser(i-1,line, FALSE, EAST), "name","laser1")
		elseif c=="c" then
		   set_item("it-coin2",i-1,line)
		elseif c=="E" then
		   set_stone("st-coinslot",i-1,line,{action="onoff",target="laser1"})
		elseif c=="B" then
			doorv( i-1,line, {name="door1"})
 		elseif c == ":" then
			mirrorp(i-1,line,FALSE,FALSE, 2)
 		elseif c == "/" then
			mirrorp(i-1,line,TRUE,FALSE, 4)
 		elseif c == ";" then
			mirrorp(i-1,line,TRUE,FALSE, 2)
 		elseif c == "?" then
			mirrorp(i-1,line,FALSE,FALSE, 4)
 		elseif c == "." then
			mirrorp(i-1,line,TRUE,FALSE, 1)
 		elseif c == "S" then
		   set_stone("st-bolder", i-1,line, {name="bolder1",direction=SOUTH})
 		elseif c == "R" then
		   	set_stone( "st-rotator-right", i-1, line)
 		elseif c == "b" then
		   set_item("it-trigger",i-1,line,{action="openclose",target="door1"})
	     end
	end	
end

renderLine(00,"####################!!!!!!!!!!!!!!!!!!!")
renderLine(01,"#C    ?     !     b#!!!!!!!!!!!!!!!!!!!")
renderLine(02,"#E       c  !      #!!!!!!!!!!!!!!!!!!!")
renderLine(03,"#    /    % !!!!!! #!!!!!!!!!!!!!!!!!!!")
renderLine(04,"# %   %     !    % #######!!!!!!!!!!!!!")
renderLine(05,"#     ;     &      #     #!!!!!!!!!!!!!")
renderLine(06,"#co z    .  B    A #   o #!!!!!!!!!!!!!")
renderLine(07,"#     /     &      #     #!!!!!!!!!!!!!")
renderLine(08,"# %   %     !    % #######!!!!!!!!!!!!!")
renderLine(09,"#    ;    % !!!!!! #!!!!!!!!!!!!!!!!!!!")
renderLine(10,"#        c  !      #!!!!!!!!!!!!!!!!!!!")
renderLine(11,"#         ? !    RS#!!!!!!!!!!!!!!!!!!!")
renderLine(12,"####################!!!!!!!!!!!!!!!!!!!")

oxyd_shuffle()

ff1=0

function funcc1()
   if ff1==0 then
set_stone("st-greenbrown",19,6)
enigma.KillStone(19,6)
enigma.KillItem(18,6)
ff1=1
   elseif ff1==1 then
			set_stone( "st-laserswitch", 19, 6)
ff1=0
		     end
end