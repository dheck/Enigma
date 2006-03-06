-- Dirt Clod, a level for Enigma
-- Copyright (C) 2005 Xerxes M. Dynatos
-- Licensed under GPL v2.0 or above 

levelw=60
levelh=33

create_world( levelw, levelh)

fill_floor("fl-himalaya", 0,0,levelw,levelh) --fl-leaves --fl-acblack

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone( "st-greenbrown", i-1, line)
		elseif c == "o" then
			oxyd( i-1, line)
		elseif c == "H" then
			set_stone( "st-greenbrown_hole", i-1, line)
		elseif c == "h" then
			set_stone( "st-greenbrown_hole", i-1, line)
			set_item("it-key_a", i-1 ,line)
		elseif c == "G" then
			set_stone( "st-glass1_hole", i-1, line)
                elseif c == "!" then
			fill_floor("fl-water", i-1,line, 1,1)
		elseif c=="z" then
			set_actor("ac-blackball", i-.5,line+.5)
			--set_actor("ac-whiteball", i-.5,line+.5)
			--set_item("it-extralife", i-.5,line+.5)
			--set_item("it-extralife", i-.5,line+.5)
			--set_item("it-extralife", i-.5,line+.5)
		elseif c=="+" then
			set_stone( "st-wood", i-1, line)
			--fill_floor("fl-leaves", i-1,line, 1,1)
			fill_floor("fl-brick", i-1,line, 1,1)
		elseif c=="A" then
			doorv(i-1,line,{name="door1"})
		elseif c=="B" then
			doorv(i-1,line,{name="door2"})
		elseif c=="E" then
			doorv(i-1,line,{name="door3"})
		elseif c=="D" then
			set_stone("st-floppy", i-1, line, {action="openclose", target="door2"})
		elseif c=="d" then
			set_stone( "st-greenbrown_hole", i-1, line)
			set_item("it-floppy", i-1, line)
		elseif c=="C" then
			set_stone("st-key_a", i-1, line, {action="openclose", target="door1"})
		elseif c=="c" then		
			set_item("it-key_a", i-1 ,line)
	        elseif c=="e" then
			set_stone("st-switch", i-1,line, {action="openclose",target="door5"})
		elseif c=="x" then
			set_stone( "st-greenbrown_hole", i-1, line)
			set_item("it-extralife", i-.5,line+.5)
		elseif c=="r" then
			set_stone("st-door_b", i-1,line, {name="door5", type="v"})
		elseif c=="q" then
			set_stone("st-door_b", i-1,line, {name="door6", type="v"})
		elseif c=="W" then
			set_stone( "st-greenbrown_hole", i-1, line)
			set_item("it-wormhole", i-1,line, {strength=1,targetx="5",targety="6"})
		elseif c=="M" then
			set_stone( "st-greenbrown_hole", i-1, line)
			set_item("it-coin1",i-1,line)
		elseif c=="f" then
			set_stone( "st-fart", i-1, line)
		elseif c=="S" then
			set_stone( "st-coinslot", i-1, line, {action="openclose", target="door8"})
		elseif c=="s" then
			doorv(i-1,line,{name="door8"})
		elseif c=="P" then
			doorv(i-1,line,{name="door9"})
		elseif c=="p" then
			set_stone("st-switch", i-1,line, {action="openclose",target="door9"})
		end
	end	
end

-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"

renderLine(00,"############################################################")
renderLine(01,"#HHHHHHHHHHHHHHHHH##########################################")
renderLine(02,"#H###############H####W##H######W#####p######W#######HH#####")
renderLine(03,"#H#         o    B          o         s      +  ! o      ###")
renderLine(04,"#H#         o    #          o         q      +  !       # d#")
renderLine(05,"#H#         o    #          o         E      +  ! o    #  ##")
renderLine(06,"#H#z        H    #          G         q     +   !     #   ##")
renderLine(07,"#H#         h    C          o         q    +    !    ##   W#")
renderLine(08,"#H#         H    A          G         E     +   !    P    ##")
renderLine(09,"#H#         o    #          o         q   +     ! o ##    ##")
renderLine(10,"#H#              #          G         q    +    !   #     H#")
renderLine(11,"#H#         o    E          o         r   +     ! o#     f##")
renderLine(12,"#H##HH########H###M###H############H##########H#########H###")
renderLine(13,"#H##WH########H#######W############H##########H#########H###")
renderLine(14,"#H###H########H####################H##########H#########H###")
renderLine(15,"#H###HHHHHHHHHH#############xxxxx#HHHHHHHHHHeHH#########H###")
renderLine(16,"#H###########################################S##########H###")
renderLine(17,"#H######################################################HHH#")
renderLine(18,"#H########################################################H#")
renderLine(19,"# HHHHHHHHHHHHHHHHH     HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH #H#")
renderLine(20,"########################################################H#H#")
renderLine(21,"########################################################H#H#")
renderLine(22,"########################################################H#H#")
renderLine(23,"########################################################H#H#")
renderLine(24,"########################################################H#H#")
renderLine(25,"########################################################H#H#")
renderLine(26,"########################################################H#H#")
renderLine(27,"########################################################H#H#")
renderLine(28,"############HHH##H   H##H H###################H H#H  H##H#H#")
renderLine(29,"#########o##H#H##H###H##H#H###################H H#H##H##H#H#")
renderLine(30,"########W    #HHHH###H  H#HHHHH     HHHHHHHHHHH#HHH##HHH #H#")
renderLine(31,"#########H#################################H##############D#")
renderLine(32,"############################################################")
renderLine(33,"############################################################")

oxyd_shuffle()

display.SetFollowMode(display.FOLLOW_SCROLLING)























