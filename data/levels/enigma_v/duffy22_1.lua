-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Choo-Choo

levelw=80
levelh=15

create_world( levelw, levelh)
enigma.ConserveLevel=FALSE

fill_floor("fl-metal", 0,0,levelw,levelh)

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone( "st-greenbrown", i-1, line)
		elseif c =="D" then
			set_stone( "st-death", i-1, line)
		elseif c == "o" then
			oxyd( i-1, line)
                elseif c == "!" then
--			abyss(i-1,line)
			fill_floor("fl-water", i-1,line, 1,1)
		elseif c=="+" then
			set_stone( "st-wood", i-1, line)
		elseif c=="g" then
			draw_stones("st-grate1",{i-1,line}, {1,1}, 1)

		elseif c=="h" then
		   set_item("it-tinyhollow", i-1, line)
		elseif c=="H" then
		   set_item("it-hollow", i-1, line)
		elseif c=="J" then
		   set_item("it-hill", i-1, line)
		elseif c=="j" then
		   set_item("it-tinyhill", i-1, line)
		elseif c == "1" then --ur
		   set_floor("fl-gradient",  i-1,  line, {type=11})
		elseif c == "3" then --dl
		   set_floor("fl-gradient",  i-1,  line, {type=9})
		elseif c == "7" then --dr
		   set_floor("fl-gradient",  i-1,  line, {type=12})
		elseif c == "9" then --ul
		   set_floor("fl-gradient",  i-1,  line, {type=10})
		elseif c == "4" then --dl
		   set_floor("fl-gradient",  i-1,  line, {type=4})
 		elseif c == "S" then
		   set_stone("st-bolder-s", i-1,line, {name="bolder1"})
		elseif c == "R" then
		   set_stone("st-bolder-e", i-1,line, {name="bolder2"})
		elseif c=="u" then
		   set_item("it-trigger", i-1,line, {action="callback", target="funcc1"})
		elseif c=="r" then
		   set_item("it-trigger", i-1,line, {action="callback", target="funcc2"})
		elseif c=="d" then
		   set_item("it-trigger", i-1,line, {action="callback", target="funcc3"})
		elseif c=="l" then
		   set_item("it-trigger", i-1,line, {action="callback", target="funcc4"})
		elseif c=="s" then
		   set_item("it-trigger", i-1,line, {action="callback", target="funcc5"})
		elseif c=="e" then
		   set_item("it-trigger", i-1,line, {action="callback", target="funcc6"})
		elseif c=="A" then
		   set_stone("st-switch", i-1,line, {action="openclose",target="door1"})
		elseif c=="B" then
		   set_stone("st-switch", i-1,line, {action="callback",target="funcc7"})
		elseif c=="C" then
		   set_stone("st-switch", i-1,line, {action="openclose",target="door2"})
		elseif c=="F" then
		   set_stone("st-switch", i-1,line, {action="openclose",target="door3"})
		elseif c=="a" then
		   doorh( i-1,line, {name="door1"})
		elseif c=="c" then
		   doorh( i-1,line, {name="door2"})
		elseif c=="f" then
		   doorh( i-1,line, {name="door3"})
		elseif c=="y" then
		   set_actor("ac-whiteball",  i-.5, line+1)
		elseif c=="L" then
			oneway(i-1,line, enigma.WEST)
		elseif c=="~" then
			oneway(i-1,line, enigma.NORTH)
		elseif c=="`" then
			oneway(i-1,line, enigma.SOUTH)
		elseif c =="X" then
		   set_stone( "st-rubberband", i-1, line,{strength=0})

elseif c=="w" then
yy1( "white",  i-1, line)
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

renderLine(00,"####################################################################")
renderLine(01,"#                  #DDDDDDDDDDDDDDDDDD#C#         #d#              #")
renderLine(02,"#                  #D                D# #         #!#              #")
renderLine(03,"#                  #D                D# #                          #")
renderLine(04,"#  #################D   #DDDDDDDD#   D#~#   #c#####!## #############")
renderLine(05,"#        D         #D   D            D#     #`#s     !R!l#")
renderLine(06,"#   J    31     D  #D   DA           D######o #e    l# # #")
renderLine(07,"#  j     97        #D   DDDDD#a#DDDDDD#       #####!## ######")
renderLine(08,"#     D        J   #D        # #     D#ooooooo#             #")
renderLine(09,"# D    31     D    #D        D #     D#########    S        #")
renderLine(10,"#  J   97    J     #######   D    #   jJJJJJJJj  ##!#########")
renderLine(11,"#          D       J         D    #   jJJJJJJJj  # u     #")
renderLine(12,"##########################################################")


oxyd_shuffle()

local actor0=set_actor("ac-blackball", 15.5,2.5)
local actor1=set_actor("ac-whiteball-small", 14.5,2.5, {player=1,mouseforce=0})
local actor2=set_actor("ac-whiteball-small", 13.5,2.5, {player=1,mouseforce=0})
local actor3=set_actor("ac-whiteball-small", 12.5,2.5, {player=1,mouseforce=0})
local actor4=set_actor("ac-whiteball-small", 11.5,2.5, {player=1,mouseforce=0})
local actor5=set_actor("ac-whiteball-small", 10.5,2.5, {player=1,mouseforce=0})
local actor6=set_actor("ac-whiteball-small", 9.5,2.5, {player=1,mouseforce=0})
local actor7=set_actor("ac-whiteball-small", 8.5,2.5, {player=1,mouseforce=0})
local actor8=set_actor("ac-whiteball-small", 7.5,2.5, {player=1,mouseforce=0})
local actor9=set_actor("ac-whiteball-small", 6.5,2.5, {player=1,mouseforce=0})
local actor10=set_actor("ac-whiteball-small", 5.5,2.5, {player=1,mouseforce=0})
local actor11=set_actor("ac-whiteball-small", 4.5,2.5, {player=1,mouseforce=0})

rr=0

AddRubberBand(actor0, actor1, 50,0)
AddRubberBand(actor1, actor2, 50,0)
AddRubberBand(actor2, actor3, 50,0)
AddRubberBand(actor3, actor4, 50,0)
AddRubberBand(actor4, actor5, 50,0)
AddRubberBand(actor5, actor6, 50,0)
AddRubberBand(actor6, actor7, 50,0)
AddRubberBand(actor7, actor8, 50,0)
AddRubberBand(actor8, actor9, 50,0)
AddRubberBand(actor9, actor10, 50,0)
AddRubberBand(actor10, actor11, 50,0)

s1=0
e1=0
ss=0
ee=0
rr=0

function funcc1()
   SetAttribs("bolder1", {direction=NORTH})
end

function funcc2()
   SetAttribs("bolder2", {direction=EAST})
end

function funcc3()
   SetAttribs("bolder1", {direction=SOUTH})
end

function funcc4()
   SetAttribs("bolder2", {direction=WEST})
end

function funcc5()
    if ss==0 then
        if s1==0 then
            SetAttribs("bolder2", {direction=SOUTH})
            s1=1
        elseif s1==1 then
            SetAttribs("bolder2", {direction=EAST})
            s1=0
        end
        ss=1
    elseif ss==1 then
        ss=0
    end
end

function funcc6()
    if ee==0 then
        if e1==0 then
            SetAttribs("bolder2", {direction=EAST})
            e1=1
        elseif e1==1 then
            SetAttribs("bolder2", {direction=NORTH})
            e1=0
        end
        ee=1
    elseif ee==1 then
        ee=0
    end
end
















