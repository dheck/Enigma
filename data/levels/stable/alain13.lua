-- The life game, a level for Enigma
-- Copyright (C) 2006 Alain Busser
-- License under GPL2.0 or above
-- Bugs fixed by Raoul

levelw = 20
levelh = 13

create_world(levelw, levelh)
oxyd_default_flavor = "a"
fill_floor("fl-leaves", 0,0, level_width,level_height)


function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone("st-glass", i-1, line)
		elseif c=="a" then
		   	set_floor("fl-hay",i-1,line)
		elseif c=="o" then
		   	oxyd(i-1,line)
		elseif c=="A" then
			set_item("it-trigger", i-1,line, {action="callback", target="fA"})
		elseif c=="B" then
			set_item("it-trigger", i-1,line, {action="callback", target="fB"})
		elseif c=="C" then
			set_item("it-trigger", i-1,line, {action="callback", target="fC"})
		elseif c=="D" then
			set_item("it-trigger", i-1,line, {action="callback", target="fD"})
		elseif c=="E" then
			set_item("it-trigger", i-1,line, {action="callback", target="fE"})
		elseif c=="F" then
			set_item("it-trigger", i-1,line, {action="callback", target="fF"})
		elseif c=="d" then
			document(i-1,line,"the nine switches in square serve to configure the initial population")
		elseif c == "1" then
         		set_stone("st-switch",i-1,line, {action="callback", target="switch1"})
		elseif c == "2" then
         		set_stone("st-switch",i-1,line, {action="callback", target="switch2"})
		elseif c == "3" then
         		set_stone("st-switch",i-1,line, {action="callback", target="switch3"})
		elseif c == "4" then
         		set_stone("st-switch",i-1,line, {action="callback", target="switch4"})
		elseif c == "5" then
         		set_stone("st-switch",i-1,line, {action="callback", target="switch5"})
		elseif c == "6" then
         		set_stone("st-switch",i-1,line, {action="callback", target="switch6"})
		elseif c == "7" then
         		set_stone("st-switch",i-1,line, {action="callback", target="switch7"})
		elseif c == "8" then
         		set_stone("st-switch",i-1,line, {action="callback", target="switch8"})
		elseif c == "9" then
         		set_stone("st-switch",i-1,line, {action="callback", target="switch9"})
		elseif c == "R" then
         		set_stone("st-switch",i-1,line, {action="callback", target="run0"})
		elseif c == "S" then
         		set_stone("st-switch",i-1,line, {action="callback", target="clear"})
		elseif c=="W" then
		   	mirror3(i-1,line,FALSE,FALSE, 1)
		elseif c=="L" then
			set_attrib(laser(i-1,line,FALSE, NORTH), "name", "las1")
		elseif c=="z" then
            	set_actor("ac-blackball", i-.5,line+.5)
		end
	end	
end

-- switches to place the initial population

function switch1()
	l1=1-l1
	if l1==0 then
		enigma.KillStone(13,6)
	else
		set_stone("st-wood",13,6)
	end
end

function switch2()
	l2=1-l2
	if l2==0 then
		enigma.KillStone(14,6)
	else
		set_stone("st-wood",14,6)
	end
end

function switch3()
	l3=1-l3
	if l3==0 then
		enigma.KillStone(15,6)
	else
		set_stone("st-wood",15,6)
	end
end

function switch4()
	l4=1-l4
	if l4==0 then
		enigma.KillStone(13,7)
	else
		set_stone("st-wood",13,7)
	end
end

function switch5()
	l5=1-l5
	if l5==0 then
		enigma.KillStone(14,7)
	else
		set_stone("st-wood",14,7)
	end
end

function switch6()
	l6=1-l6
	if l6==0 then
		enigma.KillStone(15,7)
	else
		set_stone("st-wood",15,7)
	end
end

function switch7()
	l7=1-l7
	if l7==0 then
		enigma.KillStone(13,8)
	else
		set_stone("st-wood",13,8)
	end
end

function switch8()
	l8=1-l8
	if l8==0 then
		enigma.KillStone(14,8)
	else
		set_stone("st-wood",14,8)
	end
end

function switch9()
	l9=1-l9
	if l9==0 then
		enigma.KillStone(15,8)
	else
		set_stone("st-wood",15,8)
	end
end



-- look if all switches are triggered
bA=-1
bB=-1
bC=-1
bD=-1
bE=-1
bF=-1
tot=0

function fA()
	bA=-bA
	tot=tot+bA
	if tot==6 then
		SendMessage("las1", "on")
	end
end
function fB()
	bB=-bB
	tot=tot+bB
	if tot==6 then
		SendMessage("las1", "on")
	end
end

function fC()
	bC=-bC
	tot=tot+bC
	if tot==6 then
		SendMessage("las1", "on")
	end
end
function fD()
	bD=-bD
	tot=tot+bD
	if tot==6 then
		SendMessage("las1", "on")
	end
end

function fE()
	bE=-bE
	tot=tot+bE
	if tot==6 then
		SendMessage("las1", "on")
	end
end
function fF()
	bF=-bF
	tot=tot+bF
	if tot==6 then
		SendMessage("las1", "on")
	end
end



--Used intern to compute new generation
t1={}
t2={}

function lifeg(s,n)
	if s==0 then
		if n==3 then
			return 1
		else
			return 0
		end
	elseif s==1 then
		if n==2 then
			return 1
		elseif n==3 then
			return 1
		else
			return 0
		end
	end
end


-- Start Game

function run0()
--init tables
	
	for i=1,9 do
		for j=1,9 do
			t2[j*9+i]=0
			t1[j*9+i]=0
		end
	end
	t1[9*4+4]=l1
	t1[9*4+5]=l2
	t1[9*4+6]=l3
	t1[9*5+4]=l4
	t1[9*5+5]=l5
	t1[9*5+6]=l6
	t1[9*6+4]=l7
	t1[9*6+5]=l8
	t1[9*6+6]=l9
        doit=1
		
end


-- compute new generation
function run1()
if doit==1 then

	asum=t1[9*1+2]+t1[9*2+1]+t1[9*2+2]
	t2[9*1+1]=lifeg(t1[9*1+1],asum)
	for i=2,8 do
		asum=t1[9*1+i-1]+t1[9*2+i-1]+t1[9*2+i]+t1[9*2+i+1]+t1[9*1+i+1]
		t2[9*1+i]=lifeg(t1[9*1+i],asum)
	end
	asum=t1[9*1+8]+t1[9*2+8]+t1[9*2+9]
	t2[9*1+9]=lifeg(t1[9*1+9],asum)
	for j=2,8 do
		asum=t1[9*(j-1)+1]+t1[9*(j-1)+2]+t1[9*j+2]+t1[9*(j+1)+2]+t1[9*(j+1)+1]
		t2[9*j+1]=lifeg(t1[9*j+1],asum)
	end
	for i=2,8 do
		for j=2,8 do
			asum=t1[9*(j-1)+i-1]+t1[9*(j-1)+i]+t1[9*(j-1)+i+1]
			asum=asum+t1[9*j+i-1]+t1[9*j+i+1]
			asum=asum+t1[9*(j+1)+i-1]+t1[9*(j+1)+i]+t1[9*(j+1)+i+1]
			t2[9*j+i]=lifeg(t1[9*j+i],asum)
		end
	end
	for j=2,8 do
		asum=t1[9*(j-1)+9]+t1[9*(j-1)+8]+t1[9*j+8]+t1[9*(j+1)+8]+t1[9*(j+1)+9]
		t2[9*j+9]=lifeg(t1[9*j+9],asum)
	end
	asum=t1[9*8+1]+t1[9*8+2]+t1[9*9+2]
	t2[9*9+1]=lifeg(t1[9*9+1],asum)
	for i=2,8 do
		asum=t1[9*9+i-1]+t1[9*8+i-1]+t1[9*8+i]+t1[9*8+i+1]+t1[9*9+i+1]
		t2[9*9+i]=lifeg(t1[9*9+i],asum)
	end
	asum=t1[9*8+9]+t1[9*8+8]+t1[9*9+8]
	t2[9*9+9]=lifeg(t1[9*9+9],asum)

-- display

	for i=1,9 do
		for j=1,9 do
			t1[9*j+i]=t2[9*j+i]
		end
	end
	for i=1,9 do
		for j=1,9 do
			if t1[9*j+i]==0 then
				enigma.KillStone(i+9,j+2)
			else
				set_stone("st-wood",i+9,j+2)
			end
		end
	end


else
 return 0
end
end

l1=0
l2=0
l3=0
l4=0
l5=0
l6=0
l7=0
l8=0
l9=0

--               01234567890123456789
renderLine(00 , "o    W             o")
renderLine(01 , "#####L##############")
renderLine(02 , "#        ###########")
renderLine(03 , "#        #         #")
renderLine(04 , "# 1 2 3  # C B     #")
renderLine(05 , "#        #   A     #")  
renderLine(06 , "# 4 5 6  #   aaa   #")
renderLine(07 , "#        #   aaa   #")
renderLine(08 , "# 7 8 9  #   aaa   #")
renderLine(09 , "#        #   D     #")
renderLine(10 , "#   z    # F       #")
renderLine(11 , "#   d    #  E      #")
renderLine(12 , "##R###S#############") 
--               01234567890123456789

oxyd_shuffle()

set_stone("st-timer",10,12, {action="callback", target="run1",interval=0.1})
document(2,11,"START")
document(6,11,"CLEAR")

function clear()
 doit=0
 for i=1,9 do
  for j=1,9 do
   t2[j*9+i]=0
   t1[j*9+i]=0
  end
 end
 for i=1,9 do
  for j=1,9 do
   kill_stone(9+i,2+j)
 end
 end

 l1=0
 l2=0
 l3=0
 l4=0
 l5=0
 l6=0
 l7=0
 l8=0
 l9=0
end













