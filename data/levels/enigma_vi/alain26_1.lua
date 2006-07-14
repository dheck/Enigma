-- Banana Republic, a level for Enigma
-- Copyright (C) 2006 Alain Busser
-- Licensed under GPL v2.0 or above 

levelw = 39
levelh = 25
wealth=0

if difficult then
		gcforce=20
	else
		gcforce=8
end

create_world(levelw, levelh)
oxyd_default_flavor = "a"
display.SetFollowMode(display.FOLLOW_SCROLLING)
fill_floor("fl-leaves", 0,0, level_width,level_height)

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone( "st-glass1", i-1, line)
  		elseif c=="z" then
			set_actor("ac-blackball",i-0.5,line+0.5,{player=0})
		elseif c=="-" then
			set_floor("fl-swamp",i-1,line)
		elseif c=="." then
			set_floor("fl-sand",i-1,line)
		elseif c=="t" then
			set_actor("ac-top",i-0.5,line+0.5,{range=10,force=gcforce,name="guard1",gohome=TRUE})
		elseif c=="b" then
			set_item("it-banana", i-1,line)
		elseif c=="c" then
			if random(2)==1 then
				set_item("it-trigger",i-1,line,{invisible=1,action="callback",target="plusdejus"})
			else
				set_item("it-coin1",i-1,line)
				wealth=wealth+1
			end
		elseif c=="C" then
			set_stone("st-coinslot",i-1,line,{action="callback", target="func1"}) 
		elseif c=="e" then
			set_item("it-dynamite", i-1,line)
		elseif c=="B" then
			set_item("it-blackbomb",i-1,line)
		elseif c=="k" then
			set_item("it-key_a",i-1,line)
		elseif c=="w" then
			set_stone("st-wood",i-1,line)
		elseif c=="h" then
			doorh(i-1,line, {name="door1"})
		elseif c=="a" then
            	set_stone("st-key_a", i-1,line, {action="callback", target="riendutout"})
		elseif c=="x" then
			set_stone("st-knight", i-1,line)
		elseif c=="1" then
			set_attrib(laser(i-1,line,FALSE, SOUTH), "name", "lasero")
		elseif c=="d" then
			document(i-1,line,"Caramba !! El Dictator has muchos pesos in his cristal safe but muchos costa guardia too; Hay !! Poor Bola Negra has only frutos and a lasero !!!")
		elseif c=="o" then
			oxyd(i-1,line)
		end
	end	
end


function func1()
	set_item("it-sword", 10,20)
end

function riendutout()
	document(20,12,"You have been seen using a forbidden key; costa guardia are chasing you now; El Dictator too")
end

function plusdejus()
	SendMessage("lasero","off") 
end


--               012345678901234567890123456789012345678
renderLine(00 , "---------------------------------------")
renderLine(01 , "---------------------------------------")
renderLine(02 , "----......-----------------------------")
renderLine(03 , "---........-------------------.....----")
renderLine(04 , "--..t####t..-----------------..ttt..---")  
renderLine(05 , "--.. #cc# ..-----------------..tkt..---")
renderLine(06 , "--..B#cc# ..-----------------..ttt..---")
renderLine(07 , "--.. #ah# ..------------------.....----")
renderLine(08 , "---...tt...----------------------------")
renderLine(09 , "----......-----------------------------")
renderLine(10 , "----------------......-----------------")
renderLine(11 , "---------------..z..d..----------------")
renderLine(12 , "--------------..      ..---------------")
renderLine(13 , "--------------..  1bwb..---------------")
renderLine(14 , "--------------..   bbb..---------------")  
renderLine(15 , "--------------..      ..---------------")
renderLine(16 , "--------------..   B  ..---------------")
renderLine(17 , "---------------........----------------")
renderLine(18 , "------......----......------.......----")
renderLine(19 , "-----..   e..--------------..xxxxx..---")
renderLine(20 , "-----..B C ..--------------..xoxox..---")
renderLine(21 , "-----...  ...--------------..xxxxx..---")
renderLine(22 , "------......----------------.......----")
renderLine(23 , "---------------------------------------")
renderLine(24 , "---------------------------------------")
--               012345678901234567890123456789012345678

oxyd_shuffle()
if wealth==0 then
	set_item("it-coin1",6,5)
end
	
SendMessage("lasero","on") 


