-- Copyright (c) 2004 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Just Stay Calm

rooms_wide=1
rooms_high=1

levelw=1+(19*rooms_wide)+1
levelh=1+(12*rooms_high)

create_world( levelw, levelh)
enigma.SlopeForce=90

fill_floor("fl-mortar", 0,0,levelw,levelh)

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone( "st-greenbrown", i-1, line)
		elseif c =="%" then
			set_stone( "st-greenbrown", i-1, line)
		   set_floor("fl-gradient",i-1,line,{type=21})
		elseif c == "o" then
			oxyd( i-1, line)
		elseif c == "O" then
			oxyd( i-1, line)
		   set_floor("fl-gradient",i-1,line,{type=21})
		elseif c == "*" then
			set_stone( "st-brownie", i-1, line)
                elseif c == "!" then
			abyss(i-1,line)
		elseif c == "~" then
		   set_floor("fl-water",i-1,line)
		elseif c=="z" then
		   set_actor("ac-blackball", i-.5,line+.5, {player=0})
			draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
		   set_floor("fl-gradient",i-1,line,{type=21})
		elseif c=="y" then
		   set_actor("ac-whiteball", i-1,line+.5, {player=1})
		elseif c == "g" then
			draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
		elseif c == "G" then
			draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
		   set_floor("fl-gradient",i-1,line,{type=21})
		elseif c=="+" then
			set_stone( "st-wood", i-1, line)
		elseif c=="&" then
			set_stone( "st-wood", i-1, line)
		   set_floor("fl-gradient",i-1,line,{type=21})
		elseif c=="^" then
			set_stone( "st-wood", i-1, line)
		   set_floor("fl-gradient",i-1,line,{type=21})
		   set_item("it-extralife",i-1,line)
		elseif c=="=" then
			set_floor("fl-space",i-1,line)
		elseif c=="d" then
		   set_floor("fl-gradient",i-1,line,{type=21})
		elseif c=="W" then
		fill_floor("fl-wood",i-1,line+1,5,8)
		elseif c=="T" then
		   set_stone("st-timer",i-1,line,{loop=1,interval=0.15,action="callback",target="funcc1"})
		   set_floor("fl-gradient",i-1,line,{type=21})
		elseif c=="U" then
		   set_stone("st-timer",i-1,line,{loop=1,interval=0.15,action="callback",target="funcc3"})
		   set_floor("fl-gradient",i-1,line,{type=21})
		elseif c=="V" then
		   set_stone("st-timer",i-1,line,{loop=1,interval=0.5,action="callback",target="funcc2"})
		   set_floor("fl-gradient",i-1,line,{type=21})
		elseif c=="R" then
		   set_stone("st-oneway", i-1,line, {orientation=enigma.EAST})
			set_floor("fl-gradient",  i-1,  line, {type=11})
		elseif c=="1" then
			set_floor("fl-gradient",  i-1,  line, {type=11})
	     end
	end	
end

renderLine(00,"#######%O%O%O%O%O%O%T")
renderLine(01,"#ooooo#zGGGGGGGGGGG%U")
renderLine(02,"#W    R^dGGGGGGGGGGOV")
renderLine(03,"#+++++#&&&&&&&&&&&G%d")
renderLine(04,"#+++++#GGGGGGGGGGGG%d")
renderLine(05,"#+++++oGGGGGGGGGGGG%d")
renderLine(06,"#+++++#G&&&&&&&&&&&%d")
renderLine(07,"#+++++#GGGGGGGGGGGG%d")
renderLine(08,"#+++++#GGGGGGGGGGGGOd")
renderLine(09,"#+++++#&&&&&&&&&&&G%d")
renderLine(10,"#+++++#GGGGGGGGGGGG%d")
renderLine(11,"#     1GGGGGGGGGGGG%d")
renderLine(12,"#######%&&&&&&&&&&&%d")

oxyd_shuffle()

set_item("it-seed",17,3,{name="seedb1"})
seedb1=enigma.GetNamedObject("seedb1")
   enigma.SendMessage(seedb1,"grow",nil)

set_item("it-seed",18,6,{name="seedb2"})
seedb2=enigma.GetNamedObject("seedb2")
   enigma.SendMessage(seedb2,"grow",nil)

set_item("it-seed",17,9,{name="seedb3"})
seedb3=enigma.GetNamedObject("seedb3")
   enigma.SendMessage(seedb3,"grow",nil)

set_item("it-seed",18,12,{name="seedb4"})
seedb4=enigma.GetNamedObject("seedb4")
   enigma.SendMessage(seedb4,"grow",nil)

   enigma.KillStone(1,10)
   enigma.KillStone(2,10)
   enigma.KillStone(3,10)
   enigma.KillStone(4,10)
   enigma.KillStone(5,10)

--fill_floor("fl-water",1,10,5,1)
   set_item("it-seed",1,10,{name="seedd1"})
seedd1=enigma.GetNamedObject("seedd1")
   enigma.SendMessage(seedd1,"grow",nil)

   set_item("it-seed",2,10,{name="seedd2"})
seedd2=enigma.GetNamedObject("seedd2")
   enigma.SendMessage(seedd2,"grow",nil)

   set_item("it-seed",3,10,{name="seedd3"})
seedd3=enigma.GetNamedObject("seedd3")
   enigma.SendMessage(seedd3,"grow",nil)

   set_item("it-seed",4,10,{name="seedd4"})
seedd4=enigma.GetNamedObject("seedd4")
   enigma.SendMessage(seedd4,"grow",nil)

   set_item("it-seed",5,10,{name="seedd5"})
seedd5=enigma.GetNamedObject("seedd5")
   enigma.SendMessage(seedd5,"grow",nil)

t1=1
function funcc1()
t1=t1+1
if t1<11 then
   set_item("it-seed",18-t1,3,{name="seed1"})
seed1=enigma.GetNamedObject("seed1")
   enigma.SendMessage(seed1,"grow",nil)

   set_item("it-seed",19-t1,6,{name="seed2"})
seed2=enigma.GetNamedObject("seed2")
   enigma.SendMessage(seed2,"grow",nil)

   set_item("it-seed",18-t1,9,{name="seed3"})
seed3=enigma.GetNamedObject("seed3")
   enigma.SendMessage(seed3,"grow",nil)

   set_item("it-seed",19-t1,12,{name="seede1"})
   seede1=enigma.GetNamedObject("seede1")
   enigma.SendMessage(seede1,"grow",nil)
else
t1=0
   set_item("it-seed",7,3,{name="seed4"})
seed4=enigma.GetNamedObject("seed4")
   enigma.SendMessage(seed4,"grow",nil)

   set_item("it-seed",8,6,{name="seed5"})
seed5=enigma.GetNamedObject("seed5")
   enigma.SendMessage(seed5,"grow",nil)

   set_item("it-seed",7,9,{name="seed6"})
seed6=enigma.GetNamedObject("seed6")
   enigma.SendMessage(seed6,"grow",nil)

   set_item("it-seed",8,12,{name="seede2"})
seede2=enigma.GetNamedObject("seede2")
   enigma.SendMessage(seede2,"grow",nil)
end
end


t2=1
function funcc2()
t2=t2+1
if t2<8 then

   enigma.KillStone(1,11-t2)
   enigma.KillStone(2,11-t2)
   enigma.KillStone(3,11-t2)
   enigma.KillStone(4,11-t2)
   enigma.KillStone(5,11-t2)

--   fill_floor("fl-water",1,11-t2,5,1)
   set_item("it-seed",1,11-t2,{name="seedc1"})
seedc1=enigma.GetNamedObject("seedc1")
   enigma.SendMessage(seedc1,"grow",nil)

   set_item("it-seed",2,11-t2,{name="seedc2"})
seedc2=enigma.GetNamedObject("seedc2")
   enigma.SendMessage(seedc2,"grow",nil)

   set_item("it-seed",3,11-t2,{name="seedc3"})
seedc3=enigma.GetNamedObject("seedc3")
   enigma.SendMessage(seedc3,"grow",nil)

   set_item("it-seed",4,11-t2,{name="seedc4"})
seedc4=enigma.GetNamedObject("seedc4")
   enigma.SendMessage(seedc4,"grow",nil)

   set_item("it-seed",5,11-t2,{name="seedc5"})
seedc5=enigma.GetNamedObject("seedc5")
   enigma.SendMessage(seedc5,"grow",nil)
else
t2=0

   enigma.KillStone(1,3)
   enigma.KillStone(2,3)
   enigma.KillStone(3,3)
   enigma.KillStone(4,3)
   enigma.KillStone(5,3)

--   fill_floor("fl-water",1,3,5,1)
   set_item("it-seed",1,3,{name="seedc6"})
seedc6=enigma.GetNamedObject("seedc6")
   enigma.SendMessage(seedc6,"grow",nil)

   set_item("it-seed",2,3,{name="seedc7"})
seedc7=enigma.GetNamedObject("seedc7")
   enigma.SendMessage(seedc7,"grow",nil)

   set_item("it-seed",3,3,{name="seedc8"})
seedc8=enigma.GetNamedObject("seedc8")
   enigma.SendMessage(seedc8,"grow",nil)

   set_item("it-seed",4,3,{name="seedc9"})
seedc9=enigma.GetNamedObject("seedc9")
   enigma.SendMessage(seedc9,"grow",nil)

   set_item("it-seed",5,3,{name="seedc10"})
seedc10=enigma.GetNamedObject("seedc10")
   enigma.SendMessage(seedc10,"grow",nil)
end
end

function funcc3 ()
end